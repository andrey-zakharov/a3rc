/*
      ::: ::: :::             ::: :::             ::: 
     :+: :+:   :+:           :+:   :+:           :+:  
    +:+ +:+     +:+         +:+     +:+         +:+   
   +#+ +#+       +#+       +#+       +#+       +#+    
  +#+ +#+         +#+     +#+         +#+     +#+     
 #+# #+#           #+#   #+#           #+#   #+#      
### ###             ### ###             ### ###      

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.7 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/
if (isDedicated) exitWith {};

_temp = _this select 0;
_label = _this select 1;
_size = _this select 2;

_varname = vehicleVarName _temp;
_unit = objnull;


createMarkerLocal [_varname, [0,0]];
_varname setMarkerShape "ICON";
_varname setMarkerColor "ColorBlack";
_varname setMarkerSize [ _size, _size ];
if ( _unit iskindOf "Helicopter" ) then {
	_varname setMarkerType "n_air";
} elseif ( _unit isKindOf "UAV" ) then {
	_varname setMarkerType "n_uav";
} elseif ( _unit isKindOf "Plain" ) then {
	_varname setMarkerType "n_plane";
}


while {true} do {
    waitUntil {
        call compile format ["_unit = %1", _varname];
        alive _unit;
        sleep 0.2;
    };

    while {alive _unit} do {
        if (side _unit == west) then {
            _varname setMarkerColor "ColorBlue";
        };
        if (side _unit == east) then {
            _varname setMarkerColor "ColorRed";
        };
        //_varname setMarkerDir getDir _unit;
        _varname setMarkerPos getPos _unit;
    
        sleep 0.5;
    };

    _varname setMarkerColor "ColorBlack";
    sleep 5;
};
