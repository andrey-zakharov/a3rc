//////////////////////////////////////////////////////
//////////// Station function options ////////////////
/////////////////////////////////////////////////////
/*
This functions creates the global variable StationArray which is used to 
process the options of stations. 
*/
#include "Resources\Stations.hpp"
#include "Resources\Radios.hpp"
#define Fnc_Prepare(LOCATION) compile (preprocessFileLineNumbers LOCATION)

StationsInit;
TransmitterInit;
////////////////////////////////////////////////////
//////////// you can edit from here one ///////////
///////////////////////////////////////////////////
//Stationen

#define AllFactions [West,East] //define what faction you use

ST_NAME(0)="OSCAR";
ST_CHANNELS(0)=[0,1,2,3,4,5,6,7,8,9];
ST_FACTION(0)=AllFactions;
ST_FACONLY(0)=true;
ST_OBJECT(0)="";
ST_ACTIVE(0)=true;
CreateStation(0);


ST_NAME(1)="MIKE";
ST_CHANNELS(1)=[0,1,2,5];
ST_FACTION(1)=AllFactions;// like [East,Civ,...]
ST_FACONLY(1)=true;
ST_OBJECT(1)="";
ST_ACTIVE(1)=true;
CreateStation(1);


ST_NAME(2)="SILO";
ST_CHANNELS(2)=[8,9];
ST_FACTION(2)=AllFactions;
ST_FACONLY(2)=false;
ST_OBJECT(2)="";
ST_ACTIVE(2)=true;
CreateStation(2);


//transmitter types //Only One allowed at the moment! as there is no selection option available
TM_NAME(0)="Default Radio";
TM_CHANNELS(0)=[0,1,2,3,4,5,6,7];
TM_OBJECT(0)="ItemRadio"; // Must be unique for every transmitter if not more than necessary overhead is created
TM_MAXPORTS(0)=3;
TM_ONESTATION(0)=false; 

CreateTransmitter(0);
///////////////////// do not edit /////////////////////////////////////////////////////////

/** TMTS Global Functions**/
CalcComMatrix=        Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_ComMatrix.SQF");
ChannelMap=           Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_ChMap.SQF");

UsableChannels=       Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_ActiveChannels.SQF");
UsableStations=       Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_ActiveStations.SQF");
UsableTransmitters=   Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_ActiveTransmitters.SQF");

PlayerToggleChannel=  Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_PlayerToggleChannel.SQF");
PlayerRemoveAllCH =   Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_PlayerRemoveAllChannels.SQF");
PlayerReActivateAllCH =   Fnc_Prepare("VON_PLUS_GUI\Resources\TMST_fnc_PlayerReActivateAllChannels.SQF");
/**The global overall communication matrix used to determine what channels can be used**/
CommunicationMatrix=([] call CalcComMatrix);