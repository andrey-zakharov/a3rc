//Set up briefing message
_briefing =
"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Chopper</t><br/>____________________<br/>OPFOR forces have been provided with a new prototype attack chopper and they're keeping it in a hangar somewhere on the island.<br/><br/>We've marked the suspected location on your map; head to the hangar and destroy that chopper. Fly it into the sea if you have to, just get rid of it.</t>";

_flatPos = [0,0,0];
_accepted = false;
while {!_accepted} do
{
	_position = [] call BIS_fnc_randomPos;
	_flatPos = _position isFlatEmpty
	[
		5,
		0,
		0.3,
		10,
		0,
		false
	];

	while {(count _flatPos) < 3} do
	{
		_position = [] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty
		[
			5,
			0,
			0.3,
			10,
			0,
			false
		];
	};

	if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
	{
		_accepted = true;
	};
};

//Spawn hangar and chopper
_randomDir = (random 360);
_hangar = "Land_TentHangar_V1_F" createVehicle _flatPos;
waitUntil {alive _hangar};
_hangar setPos [(getPos _hangar select 0), (getPos _hangar select 1), ((getPos _hangar select 2) - 1)];
sideObj = "O_Heli_Light_02_unarmed_F" createVehicle _flatPos;
waitUntil {!isNull sideObj};

sideObj lock 3;
{_x setDir _randomDir} forEach [sideObj,_hangar];
sideObj setVehicleLock "LOCKED";
_fuzzyPos = 
[
	((_flatPos select 0) - 300) + (random 600),
	((_flatPos select 1) - 300) + (random 600),
	0
];

{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
"sideMarker" setMarkerText "Side Mission: Destroy Chopper";
publicVariable "sideMarker";
publicVariable "sideObj";

//Spawn some enemies around the objective
_unitsArray = [sideObj];
_x = 0;
for "_x" from 0 to 2 do
{
	_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
	_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
	[_spawnGroup, _flatPos,50] call aw_fnc_spawn2_perimeterPatrol;
	[(units _spawnGroup)] call aw_setGroupSkill;
	
	_unitsArray = _unitsArray + [_spawnGroup];
};

_x = 0;
for "_x" from 0 to 2 do
{
	_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
	_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
	[_spawnGroup, _flatPos, 100] call aw_fnc_spawn2_randomPatrol;
	[(units _spawnGroup)] call aw_setGroupSkill;
	
	_unitsArray = _unitsArray + [_spawnGroup];
};

_randomPos = [_flatPos, 50,6] call aw_fnc_randomPos;
_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Armored" >> "OIA_TankPlatoon_AA")] call BIS_fnc_spawnGroup;
[_spawnGroup, _flatPos, 100] call aw_fnc_spawn2_randomPatrol;
[(units _spawnGroup)] call aw_setGroupSkill;

_unitsArray = _unitsArray + [_spawnGroup];

//Send new side mission hint
GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText _briefing;
showNotification = ["NewSideMission", "Destroy Enemy Chopper"]; publicVariable "showNotification";

sideMissionUp = true;
publicVariable "sideMissionUp";
sideMarkerText = "Destroy Chopper";
publicVariable "sideMarkerText";

//Wait until objective is destroyed
waitUntil {sleep 0.5; !alive sideObj};

sideMissionUp = false;
publicVariable "sideMissionUp";

//Send completion hint
[] call AW_fnc_rewardPlusHint;

//Hide SM marker
"sideMarker" setMarkerPos [0,0,0];
"sideCircle" setMarkerPos [0,0,0];
publicVariable "sideMarker";
true;
