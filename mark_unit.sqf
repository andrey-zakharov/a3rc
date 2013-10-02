/**
 * @author Vaulter <aazaharov81@gmail.com>
 */
//if (isDedicated) exitWith {};
if (isServer) exitWith {};

_this spawn {
    private ["_unit", "_label", "_size", "_varname", "_type"];
    _unit = _this select 0;
    _label = _this select 1;
    _size = _this select 2;

    _varname = vehicleVarName _unit;
    if (_varname != "") then {_varname = _label;};



    createMarkerLocal [_varname, [0,0]];
    _varname setMarkerShapeLocal "ICON";
    _varname setMarkerColorLocal "ColorBlack";
    _varname setMarkerSizeLocal [ _size, _size ];

    //hint format ["varname: %1, label: %2", _varname, _label];

    while {true} do {
        waitUntil {
            //call compile format ["_unit = %1", _varname];
            alive _unit;
            sleep 0.2;
        };

        _type = "n_unknown";

        switch(true) do {
        	case (_unit iskindOf "Helicopter"): { _type = "n_air"; };
        	case (_unit iskindOf "UAV"): { _type = "n_uav"; };
        	case (_unit iskindOf "Plain"): { _type = "n_plane"; };
        	case (typeOf _unit in ["B_Truck_01_fuel_F", "B_Truck_01_ammo_F", "B_G_Van_01_fuel_F" ]): { _type = "n_support"; };
        	case (_unit iskindOf "B_Truck_01_Repair_F"): { _type = "n_maint"; };
        	case (_unit iskindOf "B_Truck_01_medical_F"): { _type = "n_med"; };
    	};

        _varname setMarkerTypeLocal _type;

        //hint format["%1", _unit];

        while {alive _unit} do {
            if (side _unit == west) then {
                _varname setMarkerColorLocal "ColorBlue";
            };
            if (side _unit == east) then {
                _varname setMarkerColorLocal "ColorRed";
            };
            //_varname setMarkerDir getDir _unit;
            _varname setMarkerPosLocal (getPos _unit);

            sleep 0.5;
        };

        _varname setMarkerColorLocal "ColorBlack";
        sleep 5;
    };
};
