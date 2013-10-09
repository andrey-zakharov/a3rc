//destroyExplosivesCoast		
//Set up briefing message
_briefing =
"<t align='center'><t size='2.2'>New Side Mission</t><br/>
<t size='1.5' color='#00B2EE'>Destroy Smuggled Explosives</t><br/>
____________________<br/>
The OPFOR have been smuggling explosives onto the island and hiding them in a Mobile HQ on the coastline.<br/>
<br/>We've marked the building on your map; head over there and destroy their stock. Keep well back when you blow it; there's a lot of stuff in that building.</t>";

_flatPos = [0,0,0];
_accepted = false;

while {!_accepted} do
{
	_position = [[[getPos island, 4000]],["water","out"]] call BIS_fnc_randomPos;
	_flatPos = _position isFlatEmpty
	[
		2,
		0,
		0.3,
		1,
		1,
		true
	];

	while {(count _flatPos) < 1} do
	{
		_position = [[[getPos island,4000]], ["water","out"]] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty
		[
			2,
			0,
			0.3,
			1,
			1,
			true
		];
	};

	if ((_flatPos distance (getMarkerPos "respawn_west")) > 1700 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
	{
		_accepted = true;
	};
};

//Spawn Mobile HQ
_randomDir = (random 360);
sideObj = "Land_Cargo_HQ_V1_F" createVehicle _flatPos;
waitUntil {alive sideObj};
sideObj setDir _randomDir;
sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 0.5)];
sideObj setVectorUp [0,0,1];

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
[_spawnGroup, _flatPos, 100] call aw_fnc_spawn2_randomPatrol;
[(units _spawnGroup)] call aw_setGroupSkill;

_unitsArray = _unitsArray + [_spawnGroup];

//Set marker up
_fuzzyPos = 
[
	((_flatPos select 0) - 300) + (random 600),
	((_flatPos select 1) - 300) + (random 600),
	0
];

{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
"sideMarker" setMarkerText "Side Mission: Destroy Smuggled Explosives";
publicVariable "sideMarker";
publicVariable "sideObj";

//Throw briefing hint
GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
showNotification = ["NewSideMission", "Destroy Smuggled Explosives"]; publicVariable "showNotification";

sideMissionUp = true;
publicVariable "sideMissionUp";
sideMarkerText = "Destroy Smuggled Explosives";
publicVariable "sideMarkerText";

//Wait for boats to be dead
waitUntil {sleep 0.5; !alive sideObj};

sideMissionUp = false;
publicVariable "sideMissionUp";

//Improve this to do some randomised mortar explosions quite quickly after the killing of the building in a small radius

//Throw completion hint
[] call AW_fnc_rewardPlusHint;

//Hide marker
"sideMarker" setMarkerPos [0,0,0];
"sideCircle" setMarkerPos [0,0,0];
sleep 5;
publicVariable "sideMarker";
[] spawn aw_cleanGroups;
true
