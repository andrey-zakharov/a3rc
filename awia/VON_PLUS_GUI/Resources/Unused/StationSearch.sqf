/* 
* ** needs global variables **
* CommunicationMatrix
* ** needs global functions
*
*/
#include "Stations.hpp"
#include "Radios.hpp"
#define CH_MAP(CH) ([CH,_PlayerActStations,_PlayerActTransmit,CommunicationMatrix] call ChannelMap)
#define Active_CH ([_PlayerActStations,_PlayerActTransmit,CommunicationMatrix] call ActiveChannels)

//_ComMatrix=call CalcComMatrix;
//_PlayerActStations=call ActiveStations;
//_PlayerActTransmit=call ActiveTransmitters;

/*
ChannelSelect={
_channels _this select 0; //Channels you want to be open
_PlayerActStations=call ActiveStations;
_PlayerActTransmit=call ActiveTransmitters;

_Active_Channels=([_PlayerActStations,_PlayerActTransmit,CommunicationMatrix] call ActiveChannels)

_possible_channels=_channels-(_channels-_Active_Channels); //für den fall das sich seid aufruf der gui die channels verändert haben


	for[{_j=0},{_j<(count _PlayerActTransmit)},{_j=_j+1}] do {
	};

};*/

TransmitterChannelWeight={
private["_channels","_PlayerActStations","_PlayerActTransmit","_Active_Channels","_possible_channels","_channelweight","_maxweight","_i","_j"];
_channels=_this select 0; //Channels you want to be open

_PlayerActStations=call ActiveStations;
_PlayerActTransmit=call ActiveTransmitters;

_Active_Channels=([_PlayerActStations,_PlayerActTransmit,CommunicationMatrix] call ActiveChannels);

_possible_channels=_channels-(_channels-_Active_Channels); //für den fall das sich seid aufruf der gui die channels verändert haben
_maxweight=0;
_channelweight=[];
_channeltransmitarr=[];
    for[{_i=0},{_i<(count _possible_channels)},{_i=_i+1}] do 
	{
    _ch=(_possible_channels select _i);
	_channelweight set[_i,0];
	_chmap=([_ch,_PlayerActStations,_PlayerActTransmit,CommunicationMatrix] call ChannelMap);
	
		    _transmitarr=[];
			for[{_j=0},{_j<(count _PlayerActTransmit)},{_j=_j+1}] do {
				_selected_chmap=(_chmap select _j);
				  if((true in _selected_chmap)) then {
				  _transmitarr =_transmitarr + [_j];
				  _newval=((_channelweight select _i)+1);
				  _channelweight set[_i,_newval];
				      if(_newval>_maxweight) then {_maxweight=_newval};
				  };
			};
			_channeltransmitarr set[_i,_transmitarr];
	};
	_return = [_possible_channels,_channelweight,_maxweight,_channeltransmitarr];
	_return
};

SelectChannelTransmitter={
_WeightArray=_this select 0;
_possible_channels=_WeightArray select 1;
_channelweight=_WeightArray select 2;
_maxweight=_WeightArray select 3;
};

//[[0,1,2,3,4,5,6]] call TransmitterChannelWeight;
//hint format["%1", count _PlayerActTransmit];
hint format["%1", [[0,1,2,3,4,5,6]] call TransmitterChannelWeight];
//hint format["%1", ];

///////////////////////////////////////////////////////////////////////////////////////
/*
//this only needs to be calculated once
GetComMatrix={
    private["_ComMatrix"];
	_ComMatrix=[];
	for[{_i=0},{_i<(count TransmitterArray)},{_i=_i+1}] do 
	{
		_TransmitChannelArray=[];
		for[{_j=0},{_j<(count StationArray)},{_j=_j+1}] do 
		{
			_TransmitChannelArray=_TransmitChannelArray+[(get_ST_CHANNELS(_j)-(get_ST_CHANNELS(_j) - get_TM_CHANNELS(_i)))];
		};
	_ComMatrix=_ComMatrix+[_TransmitChannelArray];
	};
	_ComMatrix
};


GetChMatrix={
private["_Ch","_HasStations","_HasTransmitter","_ComMatrix"];
_Ch=_this select 0;
_HasStations=_this select 1;// Bool Array
_HasTransmitter=_this select 2; // Bool Array
_ComMatrix=_this select 3;

	_ChMatrix=[];
	for[{_i=0},{_i<(count TransmitterArray)},{_i=_i+1}] do 
	{
		_TransmitChannelBool=[];
	    for[{_j=0},{_j<(count StationArray)},{_j=_j+1}] do 
		{
		    if((_HasTransmitter select _i) && {(_HasStations select _j)}) then {
			_TransmitChannelBool=_TransmitChannelBool+[(_ch in ((_ComMatrix select _i) select _j))];
			} else {
			_TransmitChannelBool=_TransmitChannelBool+[false];
			}
		};
	_ChMatrix=_ChMatrix+[_TransmitChannelBool];
	}; 	
_ChMatrix	
};


//Transpose a 2D Array
Transpose={
private["_Matrix"];
    _Matrix=_this select 0; 
	_TransposeMatrix=_Matrix; 
	try{
	_ilength=(count  _Matrix);
	}catch{
	breakTo "main";
	};
	scopeName "main";
	    if(_ilength>0) then
	    {
		    try{
			_jlength = (count (_Matrix select 0));
			}catch{
			breakTo "main";
			};
			if(_jlength>0) then 
			{
				for[{_i=1},{_i<_ilength},{_i=_i+1}] do{
				   try{
				   _elementlength=(count (_Matrix  select _i))
				   }catch{
				   breakTo "main";
				   };
				   if(_elementlength!=_jlength) then {breakTo "main";};
				};
			    _TransposeMatrix=[];
				for[{_j=0},{_j<_jlength},{_j=_j+1}] do 
				{
					_Array=[];
					for[{_i=0},{_i<_ilength},{_i=_i+1}] do 
					{
						_Array=_Array+[(_Matrix  select _i) select _j];
					};
					_TransposeMatrix=_TransposeMatrix+[_Array];
			    };
			};
		};
	_TransposeMatrix	   
};
_ComMap=call GetComMatrix;


// ActiveArrys über Funktionen berchnen! 
// Für Station Abhängig von Range, Ob Station Active, Ob Station Zugriff erlaubt, Ob schlüssel stimmt 
// Für Geräte reicht die Prüfung Über Item Bezeichner

ActiveTransmitters={
	_active=[];
	for[{_i=0},{_i<(count TransmitterArray)},{_i=_i+1}] do 
	{ 
	if((get_TM_OBJECT(_i) in assignedItems player)) then {_active=_active+[true];} else {_active=_active+[false];};
	};
	_active
};

ActiveStations={
	_active=[];
	for[{_i=0},{_i<(count StationArray)},{_i=_i+1}] do 
	{    
	   if(get_ST_ACTIVE(_i)) then {
	      if(!get_ST_FACONLY(_i) || {((side player) in get_ST_FACTION(_i)) && {get_ST_FACONLY(_i)}} ) then {
			  _active=_active+[true];
		  }else{_active=_active+[false];};
	   }else{
	   _active=_active+[false];
	   }; 
	   //then {_active=_active+[true];} else {_active=_active+[false];};
	};
	_active
};

	//_ChMatrix

//GetChMatrix={}

PossibleChannels={
_HasStations=_this select 0;// Bool Array
_HasTransmitter=_this select 1; // Bool Array
_ComMatrix=_this select 2;
_ChMatrix=[];//somthing like [0,1,2,3]
for[{_ch=0},{_ch<10},{_ch=_ch+1}] do 
{
    scopeName "search";
	for[{_i=0},{_i<(count TransmitterArray)},{_i=_i+1}] do 
	{
	    for[{_j=0},{_j<(count StationArray)},{_j=_j+1}] do 
		{
		    if((_HasTransmitter select _i) && {(_HasStations select _j)}) then {
			    if((_ch in ((_ComMatrix select _i) select _j))) then {
				_ChMatrix=_ChMatrix+[_ch];
				breakTo "search";
				};
			};
		};
	}; 		
};
_ChMatrix
};
*/
/*
AutoRooming={
_ch _this select 0; //Channels you want to be open
	for[{_i=0},{_i<(count StationArray)},{_i=_i+1}] do 
	}
};
*/

//hint "Test2";
//hint format["%1",([West] == [sideFriendly,sideEnemy])];

//hint format["CH0 %1 Ch1 %2 Ch5 %3  ", CH_MAP(0),CH_MAP(1),CH_MAP(5)];
