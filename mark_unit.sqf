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
_this spawn {
    private ["_unit", "_label", "_size", "_varname"];
    _unit = _this select 0;
    _label = _this select 1;
    _size = _this select 2;

    _varname = vehicleVarName _unit;
    if (_varname != "") then {_varname = _label;};



    createMarkerLocal [_varname, [0,0]];
    _varname setMarkerShape "ICON";
    _varname setMarkerColor "ColorBlack";
    _varname setMarkerSizeLocal [ _size, _size ];

    //hint format ["varname: %1, label: %2", _varname, _label];

    while {true} do {
        waitUntil {
            //call compile format ["_unit = %1", _varname];
            alive _unit;
            sleep 0.2;
        };

        switch(true) do {
        	case (_unit iskindOf "Helicopter"): { _varname setMarkerType "n_air"; };
        	case (_unit iskindOf "UAV"): { _varname setMarkerType "n_uav"; };
        	case (_unit iskindOf "Plain"): { _varname setMarkerType "n_plane"; };
        	case (typeOf _unit in ["B_Truck_01_fuel_F", "B_Truck_01_ammo_F", "B_G_Van_01_fuel_F" ]): { _varname setMarkerType "n_support"; };
        	case (_unit iskindOf "B_Truck_01_Repair_F"): { _varname setMarkerType "n_maint"; };
        	case (_unit iskindOf "B_Truck_01_medical_F"): { _varname setMarkerType "n_med"; };
        	default { _varname setMarkerType "n_unknown"; };
    	};



        hint format["%1", _unit];

        while {alive _unit} do {
            if (side _unit == west) then {
                _varname setMarkerColor "ColorBlue";
            };
            if (side _unit == east) then {
                _varname setMarkerColor "ColorRed";
            };
            //_varname setMarkerDir getDir _unit;
            _varname setMarkerPos (getPos _unit);
        
            sleep 0.5;
        };

        _varname setMarkerColor "ColorBlack";
        sleep 5;
    };
};