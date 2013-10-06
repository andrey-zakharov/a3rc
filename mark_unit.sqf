/**
 * @author Vaulter <aazaharov81@gmail.com>
 */
if (isDedicated) exitWith {};

//if (isServer) exitWith {};
format [ "mark: %1", _this ] call BIS_fnc_log;

_this spawn {
    private ["_unit", "_label", "_size", "_varname", "_type", "_marker"];
    _unit = _this select 0;
    _label = _this select 1;
    _size = _this select 2;

    _varname = vehicleVarName _unit;
    if (_varname == "") then {_varname = _label;};

    //format ["init _unit=%1, _label=%2, _size=%3, varname=%4 ",
    //_unit, _label, _size, _varname ] call BIS_fnc_log;


    _marker = createMarkerLocal [_varname, [0,0]];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerColorLocal "ColorWhite";
    _marker setMarkerSizeLocal [ _size, _size ];
    _marker setMarkerTextLocal _label;

    //hint format ["varname: %1, label: %2", _varname, _label];

    while {true} do {
        waitUntil {
            //call compile format ["_unit = %1", _varname];
            sleep 0.2;
            alive _unit
        };

        _type = "n_unknown";

        switch true do {
        	case (_unit iskindOf "Helicopter"): { _type = "n_air"; };
        	case (_unit iskindOf "UAV"): { _type = "n_uav"; };
        	case (_unit iskindOf "Plain"): { _type = "n_plane"; };
        	case (typeOf _unit in ["B_Truck_01_fuel_F", "B_Truck_01_ammo_F", "B_G_Van_01_fuel_F" ]): { _type = "n_support"; };
        	case (_unit iskindOf "B_Truck_01_Repair_F"): { _type = "n_maint"; };
        	case (_unit iskindOf "B_Truck_01_medical_F"): { _type = "n_med"; };
    	};

        //format ["marker = %1, type = %2", _varname, _type ] call BIS_fnc_log;

        _marker setMarkerTypeLocal _type;

        //hint format["%1", _unit];

        while {alive _unit} do {
            if (side _unit == west) then {
                _marker setMarkerColorLocal "ColorBlue";
            };
            if (side _unit == east) then {
                _marker setMarkerColorLocal "ColorRed";
            };
            //_varname setMarkerDir getDir _unit;
            _marker setMarkerPosLocal (getPos _unit);

            sleep 0.5;
        };

        _marker setMarkerColorLocal "ColorBlack";
        sleep 60;
        deleteMarkerLocal _marker;
    };
};
