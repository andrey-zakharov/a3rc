//if (PARAMS_PilotsOnly == 0 )  exitWith {};
private ["_unit", "_v", "_pl"];
_unit = _this select 0;

//_classes = [
//	"B_Helipilot_F"
//];

if ( _unit isKindOf "ParachuteBase" ) exitWith {};

if ( _unit isKindOf "Air" ) then {
	_unit addEventHandler ["GetIn", { // Passed array: [vehicle, position, unit]
		if ( player == _this select 2 && typeOf player != "B_Helipilot_F" )  then {
			_this spawn {
				_v = _this select 0;

				if (driver _v == player) then {
					player action ["eject", _v];
					
					waitUntil {sleep 0.5; player == vehicle player; };
					player action ["engineOff", _v];
					hint "You must be a pilot to fly!";
				};
			};
		};

	} ];
};

//special case for small bird - only with pilot you can sit to co-pilot
if ( _unit isKindOf "B_Heli_Light_01_armed_F" ) then {
	_unit addEventHandler ["GetIn", { // Passed array: [vehicle, position, unit]
		if ( player == _this select 2 && typeOf player != "B_Helipilot_F" )  then {
			_this spawn {
				_v = _this select 0;

				if ( isNull driver _v ) then {
					
					player action ["eject", _v];
					waitUntil {sleep 0.5; player == vehicle player };
					player action ["engineOff", _v];
					hint "You cannot fly without a pilot in cabin!";
				};
			};
		};
	}];
};
//if (_unit isKindOf "Helicopter" || (_unit isKindOf "Plane") && !(_unit isKindOf "ParachuteBase")) then {
