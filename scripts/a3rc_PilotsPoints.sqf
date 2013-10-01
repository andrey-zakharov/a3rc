/** points for pilots */
if (isDedicated) exitWith {};

waitUntil {sleep 0.5; alive player;}
_unit = _this select 0;

PFP_count_players = 0.0;
PFP_getins = []; // array of players getins
//centerposition for distance coef
PFP_max_distance = [0,0,0] distance getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");

_countPoints = {
	private ["_points", "_landedAtPos", "_filtered_getins"];
	_landedAtPos = position player call _getClosestObjective;
	_points = 0.0;
	_countGroup = 0;
	_filtered_getins = [];
	{
		_getOutPos = _x select 1 call _getClosestObjective;

		if ( _landedAtPos != _getOutPos &&  _x select 2 > 0 ) {
			_points = _points + _x select 2;
			_countGroup = _countGroup + 1;

		} else {
			_filtered_getins set [count _filtered_getins, _x];
		};
	} forEach PFP_getins;

	PFP_getins = _filtered_getins;
	[ _points, _countGroup ];
};

//Passed array: [vehicle, position, unit]
_heliOnGetIn = {
	// this player is on drive place
	if (driver _this select 0 == player) then {
		// but player getin not me
		if ( _this select 2 != player ) then {
			_passageer = _this select 2;
			_idx = count PFP_getins;

			for "_i" from 0 to count PFP_getins step 1 do {
				if ( PFP_getins select _i select 0 == _passageer ) exitWith {
					_idx = _i;
				};
			};

			PFP_getins set[ _idx, [ _passageer, position _passageer ] ];
		};
	};
};

//Passed array: [vehicle, position, unit]
_heliOnGetOut = {
	private ["_destObj", "_srcObj", "_idx", "_from", "_points"];
	// this player is on drive place
	if (driver _this select 0 == player) then {
		if (_this select 2 != player) then {
			_passageer = _this select 2;
			_isIn = { _x select 0 == _passageer } count PFP_getins;
			if !(isIn) exitWith {};

			{
				if ( PFP_getins select _i select 0 == _passageer ) exitWith {
					_idx = _i;
				};
			} forEach PFP_getins;

			_from = PFP_getins select _idx select 1;
			if ( _from distance position player <= 100 ) exitWith {
				PFP_getins set [_idx, objnull];
			};

			_srcObj = _from call _getClosestObjective;
			_destObj = position player call _getClosestObjective;

			_penalty = [_from, position player, _srcObj, _destObj ] call _getPenalty;


			/// 1 point for PFP_max_distance / 2.
			_points = _srcObj distance _destObj / ( PFP_max_distance / 2 );
			_points = _points * _penalty;
			PFP_getins set[ _idx, [ _passageer, position _passageer, _points ] ];
		};
	};
};

//Passed array: [plane, airportID]
_heliOnLandedTouchDown = {

	if (driver _this select 0 == player) then {
		_points = call _countPoints;
		if ( _points select 0 > 0 ) then {
			addToScore = [player, _points select 0]; publicVariable "addToScore";
			["ScoreBonus", [format ["Transported group of %1 soldiers.", _points select 1], _points select 2]] call bis_fnc_showNotification;
		};
	};
}
// [_from, _srcObj, _to, _dstObj ]
_getPenalty = {
	private ["_from","_to","_srcObj","_dsstObj"];
	_from = _this select 0;
	_srcObj = _this select 1;
	_to = _this select 2;
	_dstObj = _this select 3;

	_from distance _to  / _srcObj distance _dstObj
};
// argument - from 
_getClosestObjective = {
	private ["_from", "_min_dist", "_objs", "_d"];
	_from = _this;
	_min_dist = PFP_max_distance;
	_objs = [ markerPos "respawn_west" ];
	// AHOY
	if (currentAOUp) then { _objs set[ count _objs, getMarkerPos currentAO ]; };
	if (priorityTargetUp) then { _objs set[ count _objs, markerPos "priorityMarker" ]; };
	if (sideMissionUp) then { _objs set[ count _objs, getPos sideObj ]; };
	
	{ 
		_d = _this distance _x;
		if ( _d < _min_dist ) then { _min_dist = _d; _from = _x };
	} forEach _objs;

	_from
};


_unit addEventHandler[ "GetIn", _heliOnGetIn ];
_unit addEventHandler[ "GetOut", _heliOnGetOut ];
_unit addEventHandler[ "LandedTouchDown", _heliOnLandedTouchDown ];
