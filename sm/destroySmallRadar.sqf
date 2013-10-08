//Set up briefing message
_briefing =
"<t align='center'><t size='2.2'>New Side Mission</t><br/>
<t size='1.5' color='#00B2EE'>Destroy Radar</t><br/>
____________________<br/>
OPFOR forces have erected a small radar on the island as part of a project to keep friendly air support at bay.<br/>
<br/>We've marked the position on your map; head over there and take down that radar.</t>";

_flatPos = [0,0,0];
_accepted = false;
while {!_accepted} do
{
	//Get random safe position somewhere on the island
	_position = [] call BIS_fnc_randomPos;
	_flatPos = _position isFlatEmpty 
	[
		5, //minimal distance from another object
		1, //try and find nearby positions if original is incorrect
		0.5, //30% max gradient
		sizeOf "Land_Radar_small_F", //gradient must be consistent for entirety of object
		0, //no water
		false //don't find positions near the shoreline
	];

	while {(count _flatPos) < 1} do
	{
		_position = [] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty 
		[
			10, //minimal distance from another object
			1, //try and find nearby positions if original is incorrect
			0.5, //30% max gradient
			sizeOf "Land_Radar_small_F", //gradient must be consistent for entirety of object
			0, //no water
			false //don't find positions near the shoreline
		];
	};
	
	if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
	{
		_accepted = true;
	};
};

//Spawn radar, set vector and add marker
sideObj = "Land_Radar_Small_F" createVehicle _flatPos;
waitUntil {alive sideObj};
sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 2)];
sideObj setVectorUp [0,0,1];
_fuzzyPos = 
[
	((_flatPos select 0) - 300) + (random 600),
	((_flatPos select 1) - 300) + (random 600),
	0
];

{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
"sideMarker" setMarkerText "Side Mission: Destroy Radar";
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
	[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
	[(units _spawnGroup)] call aw_setGroupSkill;
	
	_unitsArray = _unitsArray + [_spawnGroup];
};

_randomPos = [_flatPos, 50,6] call aw_fnc_randomPos;
_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Armored" >> "OIA_TankPlatoon_AA")] call BIS_fnc_spawnGroup;
[_spawnGroup, _flatPos, 200] call aw_fnc_spawn2_randomPatrol;
[(units _spawnGroup)] call aw_setGroupSkill;

_unitsArray = _unitsArray + [_spawnGroup];

//Throw out objective hint
GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
showNotification = ["NewSideMission", "Destroy Enemy Radar"]; publicVariable "showNotification";

sideMissionUp = true;
publicVariable "sideMissionUp";
sideMarkerText = "Destroy Radar";
publicVariable "sideMarkerText";

waitUntil {sleep 0.5; !alive sideObj}; //wait until the objective is destroyed

sideMissionUp = false;
publicVariable "sideMissionUp";

//Throw out objective completion hint
[] call AW_fnc_rewardPlusHint;

//Hide marker
"sideMarker" setMarkerPos [0,0,0];
"sideCircle" setMarkerPos [0,0,0];
publicVariable "sideMarker";
