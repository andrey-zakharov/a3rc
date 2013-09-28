//if (PARAMS_PilotsOnly == 0 )  exitWith {};
private ["_unit", "_v", "_pl"];
_unit = _this select 0;

//_classes = [
//	"B_Helipilot_F"
//];

if ( _unit isKindOf "ParachuteBase" ) exitWith {};

if ( _unit isKindOf "Air" ) then {
	_unit addEventHandler ["GetIn", { // Passed array: [vehicle, position, unit]
		_v = _this select 0;
		_pos = _this select 1;
		_pl = _this select 2;
		//hint format["%1 -- %2 -- %3 -- %4", _v, _pos, _pl, player];
		//vehicle player vehicleChat format["%1 %2 %3", _this, _pos, _pl];
		//sleep 5;

		if ( typeOf _pl != "B_Helipilot_F") then {
			if (driver _v == _pl) then {
				_pl action ["eject", _v];
				waitUntil {sleep 0.5; vehicle _pl == _pl;};
				_pl action ["engineOff", _v];
				hint "You must be a pilot to fly!";
			};
		};
	} ];
};

//special case for small bird - only with pilot you can sit to co-pilot
if ( _unit isKindOf "B_Heli_Light_01_armed_F" ) then {
	_unit addEventHandler ["GetIn", { // Passed array: [vehicle, position, unit]
		_v = _this select 0;
		_pl = _this select 2;

		if ( typeOf _pl != "B_Helipilot_F") then {
			if ( isNull driver _v ) then {
				
				_pl action ["eject", _v];
				waitUntil {sleep 0.5; vehicle _pl == _pl;};
				_pl action ["engineOff", _v];
				hint "You cannot fly without a pilot in cabin!";
			};
		};
	}];
};
//if (_unit isKindOf "Helicopter" || (_unit isKindOf "Plane") && !(_unit isKindOf "ParachuteBase")) then {
