/*
      ::: ::: :::             ::: :::             ::: 
     :+: :+:   :+:           :+:   :+:           :+:  
    +:+ +:+     +:+         +:+     +:+         +:+   
   +#+ +#+       +#+       +#+       +#+       +#+    
  +#+ +#+         +#+     +#+         +#+     +#+     
 #+# #+#           #+#   #+#           #+#   #+#      
### ###             ### ###             ### ###      

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.82 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/
//format ["isDedicated=%1, isServer=%2, isMultiplayer=%3, isPlayer=%4",
//	 isDedicated, isServer, isMultiplayer, isPlayer player] call BIS_fnc_log;
// JIP Check (This code should be placed first line of init.sqf file)
if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};

// Wait until player is initialized
if (!isDedicated) then {waitUntil {!isNull player && isPlayer player};};

#define WELCOME_MESSAGE	"Welcome to Ahoy World's Invade & Annex ~ALTIS~\n" +\
						"by Rarek (Ahoy World) edited by Arma3 Russian Community\n\n" +\
						"www.a3rc.com\n\n" +\
						"TeamSpeak:\n" +\
						"a3rc.com"
call compile preprocessFile "=BTC=_TK_punishment\=BTC=_tk_init.sqf";
					
					
/* =============================================== */
/* =============== GLOBAL VARIABLES ============== */

/*
	These targets are simply markers on the map with
	the same name.
	
	Each AO will be a randomly-picked "target" from
	this list which will be removed upon completion.
	
	To ensure the mission works, make sure that any
	new targets you add have a relevant marker on
	the mission map.
	
	You can NOT have an AO called "Nothing".
*/

private ["_pos","_uavAction","_isAdmin","_i","_isPerpetual","_accepted","_position","_randomWreck","_firstTarget","_validTarget","_targetsLeft","_flatPos","_targetStartText","_lastTarget","_targets","_dt","_enemiesArray","_radioTowerDownText","_targetCompleteText","_null","_unitSpawnPlus","_unitSpawnMinus","_missionCompleteText"];

_handle = execVM "aw_functions.sqf";
waitUntil{scriptDone _handle};
execVM "changeLog.sqf";
_initialTargets = [
	"Kavala & Aggelochori",
	"Solar Plant",
	"Neochori",
	"Athira",
	"Lakka",
	"Panochori",
	"Kore",
	"Galati",
	"Ioannina",
	"Thronos",
	"Kalochori",
	"Sofia",
	"Dome",
	"Feres",
	"Pyrgos",
	"Skopos",
	"Neri",
	"Factory",
	"Syrta",
	"Zaros",
	"Chalkeia",
	"Aristi",
	"Dump",
	"Agia Stemma",
	"Outpost",
	"Frini"
];

_targets = + _initialTargets;

//Grab parameters and put them into readable variables
for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do
{
	call compile format 
	[
		"PARAMS_%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};

if(isMultiplayer) then 
{
	if(PARAMS_DebugMode == 1) then {DEBUG = true} else {DEBUG = false};
} else {DEBUG = true};

enableSentences false;
//if (PARAMS_AhoyCoinIntegration == 1) then { OnPlayerConnected "_handle = [_uid, _name] execVM ""ac\init.sqf"";"; };

"GlobalHint" addPublicVariableEventHandler
{
	private ["_GHint"];
	_GHint = _this select 1;
	hint parseText format["%1", _GHint];
};

"runOnServer" addPublicVariableEventHandler
{
	if (isServer) then
	{
		private ["_codeToRun"];
		_codeToRun = _this select 1;
		call _codeToRun;
	};
};

"radioTower" addPublicVariableEventHandler
{
	"radioMarker" setMarkerPosLocal (markerPos "radioMarker");
	"radioMarker" setMarkerTextLocal (markerText "radioMarker");
	"radioMineCircle" setMarkerPosLocal (markerPos "radioMineCircle");
};

"refreshMarkers" addPublicVariableEventHandler
{
	{
		_x setMarkerShapeLocal (markerShape _x);
		_x setMarkerSizeLocal (markerSize _x);
		_x setMarkerBrushLocal (markerBrush _x);
		_x setMarkerColorLocal (markerColor _x);
	} forEach _targets;

	{
		_x setMarkerPosLocal (markerPos _x);
		_x setMarkerTextLocal (markerText _x);
	} forEach ["aoMarker","aoCircle"];
};

"showNotification" addPublicVariableEventHandler
{
	private ["_type", "_message"];
	_array = _this select 1;
	_type = _array select 0;
	_message = "";
	if (count _array > 1) then { _message = _array select 1; };
	[_type, [_message]] call bis_fnc_showNotification;
};

"showSingleNotification" addPublicVariableEventHandler
{
	/* Slam somethin' 'ere */
};

"sideMarker" addPublicVariableEventHandler
{
	"sideMarker" setMarkerPosLocal (markerPos "sideMarker");
	"sideCircle" setMarkerPosLocal (markerPos "sideCircle");
	"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];
};

"priorityMarker" addPublicVariableEventHandler
{
	"priorityMarker" setMarkerPosLocal (markerPos "priorityMarker");
	"priorityCircle" setMarkerPosLocal (markerPos "priorityCircle");
	"priorityMarker" setMarkerTextLocal format["Priority Target: %1",priorityTargetText];
};

"aw_addAction" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_actionArray = [(_this select 1) select 1, (_this select 1) select 2];
	_obj addAction _actionArray;
};

"aw_removeAction" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_id = (_this select 1) select 1;
	_obj removeAction _id;
};

"aw_unitSay" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_sound = (_this select 1) select 1;
	_obj say [_sound,15];
};

"hqSideChat" addPublicVariableEventHandler
{
	_message = _this select 1;
	[WEST,"HQ"] sideChat _message;
};

"debugMessage" addPublicVariableEventHandler
{
	private ["_isAdmin", "_message"];
	_isAdmin = serverCommandAvailable "#kick";
	if (_isAdmin) then
	{
		if (debugMode) then
		{
			_message = _this select 1;
			[_message] call bis_fnc_error;
		};
	};
};


/* =============================================== */
/* ================ PLAYER SCRIPTS =============== */
// vehicle crew display 
[player] execVM "scripts\crew\crew.sqf";
0 = [] execVM 'misc\group_manager.sqf';
if (PARAMS_RadioCheck == 1) then { 0 = [] execVM 'scripts\a3rc_RadioCheck.sqf' };
_null = [] execVM "restrictions.sqf";

/* ================ RESTRICTED VEHICLE/GUNNER =============== */
0 = ["I_Plane_Fighter_03_CAS_F","B_Pilot_F"] execVM "scripts\checkPilot.sqf"; /* Проверка пилота самолета */
0 = ["Helicopter","B_Helipilot_F"] execVM "scripts\checkPilot.sqf"; /* Проверка пилота */
0 =["Heli_Attack_01_base_F","B_Helipilot_F"] execVM "scripts\checkGunner.sqf";
0 =["Heli_Attack_02_base_F","B_Helipilot_F"] execVM "scripts\checkGunner.sqf"; 
0 =["B_MBT_01_arty_F","B_Crew_F"] execVM "scripts\checkGunner.sqf"; /* Проверка артеллириста */
0 =["B_MBT_01_mlrs_F","B_Crew_F"] execVM "scripts\checkGunner.sqf"; /* Проверка артеллириста */

if (PARAMS_ViewDistance == 1) then { _null = [] execVM "taw_vd\init.sqf"; };
if (PARAMS_SpawnProtection == 1) then { _null = [] execVM "scripts\grenadeStop.sqf"; };
if (PARAMS_ReviveEnabled == 1) then 
{
	call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";
	if (PARAMS_MedicMarkers == 1) then { _null = [] execVM "misc\medicMarkers.sqf"; };
};
if (PARAMS_PlayerMarkers == 1) then { _null = [] execVM "misc\playerMarkers.sqf"; };
if (PARAMS_DynamicWeather == 1) then { [] execVM "misc\DynamicWeatherEffects.sqf"; };
/* 	Disabled while Alpha bug is present
	_null = [] execVM "misc\radioChannels.sqf"; */

if (PARAMS_BulletWind == 1) then { 
	if (isServer) then {execVM "misc\bulletWindServer.sqf";};
	execVM "misc\bulletWindClient.sqf";
	player addAction [format[ "<t color='#FFFFFF'>%1</t>", localize "STR_ACTION_CHECK_WIND"],"misc\action_checkWind.sqf", nil, -10, false, false];
};


[] spawn {
	scriptName "initMission.hpp: mission start";
	["rsc\FinalComp.ogv", ""] spawn BIS_fnc_titlecard;
	waitUntil {sleep 0.5; !(isNil "BIS_fnc_titlecard_finished")};

	_timeout = time + 1; //wait 2 seconds for currentAO
	_titlePos = [14600.0,16801.0,100];
	waitUntil { (!isNil"currentAO" && currentAO != "Nothing") || time > _timeout };
	if (!isNil"currentAO" && currentAO != "Nothing" ) then { _titlePos = getMarkerPos currentAO; };
	[_titlePos,"We've gotten a foot-hold on the island,|but we need to take the rest.||Listen to HQ and neutralise all enemies designated."] spawn BIS_fnc_establishingShot;
	titleText [WELCOME_MESSAGE, "PLAIN", 3];

	_script = execVM "scripts\EtV.sqf";
	waitUntil {scriptDone _script && !isNil "EtVInitialized" && !isNil "EtV_Actions"};
	player call EtV_Actions;
};

if (!isServer) then
{	
	sleep 20;

	waitUntil {sleep 0.5; currentAO != "Nothing"};

	if (radioTowerAlive) then
	{
		"radioMarker" setMarkerPosLocal (getPos radioTower);
		"radioMineCircle" setMarkerPosLocal (getPos radioTower);
		"radioMarker" setMarkerTextLocal (markerText "radioMarker");
	} else {
		"radioMarker" setMarkerPosLocal [0,0,0];
		"radioMineCircle" setMarkerPosLocal [0,0,0];
	};
	
	if (sideMissionUp) then
	{
		"sideMarker" setMarkerPosLocal (getPos sideObj);
		"sideCircle" setMarkerPosLocal (getPos sideObj);
		"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];
	} else {
		"sideMarker" setMarkerPosLocal [0,0,0];
		"sideCircle" setMarkerPosLocal [0,0,0];
	};
	
	if (priorityTargetUp) then
	{
		_pos = [0,0,0];
		if (alive priorityTarget1) then
		{
			_pos = getPos priorityTarget1;
		} else {
			_pos = getPos priorityTarget2;
		};
		"priorityMarker" setMarkerPosLocal _pos;
		"priorityCircle" setMarkerPosLocal _pos;
		"priorityMarker" setMarkerTextLocal format["Priority Target: %1",priorityTargetText];
	} else {
		"priorityMarker" setMarkerPosLocal [0,0,0];
		"priorityCircle" setMarkerPosLocal [0,0,0];
	};

	if (currentAOUp) then
	{
		{
			_x setMarkerPosLocal (getMarkerPos currentAO);
		} forEach ["aoCircle","aoMarker"];
		"aoMarker" setMarkerTextLocal format["Take %1",currentAO];
	} else {
		{
			_x setMarkerPosLocal [0,0,0];
		} forEach ["aoCircle","aoMarker"];
	};
	
	_uavAction = player addAction 
	[
		"<t color='#FFCF11'>Activate Personal UAV</t>",
		"uavView.sqf",
		[
			currentAO
		],
		0,
		false,
		true
	];
};
	
if (!isServer) exitWith
{
	_spawnBuildings = nearestObjects [(getMarkerPos "respawn_west"), ["building"], 1000];

	{
		_x allowDamage false;
		_x enableSimulation false;
	} forEach _spawnBuildings;

	while {true} do
	{
		_isAdmin = serverCommandAvailable "#kick";
		if (_isAdmin) then
		{
			1 setRadioMsg "Toggle Debug Mode";
			2 setRadioMsg "Debug Information";
			3 setRadioMsg "Skip AO (N/A)";
			4 setRadioMsg "Destroy Side Mission";
			5 setRadioMsg "Skip Priority Target (N/A)";
		} else {
			{ _x setRadioMsg "NULL"; } forEach [1,2,3,4,5];
		};
		waitUntil {sleep 0.5; !alive player};
		waitUntil {sleep 0.5; alive player};
		_uavAction = player addAction 
		[
			"<t color='#FFCF11'>Activate Personal UAV</t>",
			"uavView.sqf",
			[
				currentAO
			],
			0,
			false,
			true
		];
	};
};


/* =============================================== */
/* ============ SERVER INITIALISATION ============ */

//Set a few blank variables for event handlers and solid vars for SM
debugMode = true; publicVariable "debugMode";
eastSide = createCenter EAST;
radioTowerAlive = false;
sideMissionUp = false;
priorityTargetUp = false;
currentAOUp = false;
refreshMarkers = true;
sideObj = objNull;
priorityTargets = ["None"];
smRewards = 
[
	["an AH-99 Blackfoot", "B_Heli_Attack_01_F"],
	["a Hunter HMG", "B_MRAP_01_hmg_F"],
	["an AMV-7 Marshall", "B_APC_Wheeled_01_cannon_F"],
	["an A-143 Buzzard", "I_Plane_Fighter_03_CAS_F"],
	["an M2A1 Slammer", "B_MBT_01_cannon_F"],
	["an IFV-6a Cheetah","B_APC_Tracked_01_AA_F"],
	["an M5 Sandstorm", "B_MBT_01_mlrs_F"],
	["an AFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F"],
	["an Strider GMG", "I_MRAP_03_gmg_F"]
];
smMarkerList = 
["smReward1","smReward2","smReward3","smReward4","smReward5","smReward6","smReward7","smReward8","smReward9","smReward10","smReward11","smReward12","smReward13","smReward14","smReward15","smReward16","smReward17","smReward18","smReward19","smReward20","smReward21","smReward22","smReward23","smReward24","smReward25","smReward26","smReward27"];

/*---------------------------------------------------------------------------
Disabled while Alpha bug is present
---------------------------------------------------------------------------*/
/* radioChannels = []; publicVariable "radioChannels";
_null = [] execVM "misc\radioChannels.sqf"; */

//Run a few miscellaneous server-side scripts
_null = [] execVM "misc\clearBodies.sqf";
_null = [] execVM "misc\clearItems.sqf";

/*
//Run mortar scripts
_null = [] execVM "misc\mortar\spawnhq.sqf";
_null = [] execVM "misc\mortar\mortarHEReload.sqf";
_null = [] execVM "misc\mortar\mortarSupportReload.sqf";
*/

//Run Patrols
if (PARAMS_AOReinforcementJet == 1) then { _null = [] execVM "reinforcements\AO_JET_BUZZARD.sqf"; };
if (PARAMS_AOReinforcement == 1) then { _null = [] execVM "reinforcements\AO_HELO_ORCA.sqf"; };
if (PARAMS_AOReinforcementHeavyHelo == 1) then { _null = [] execVM "reinforcements\AO_HELO_MI48.sqf"; };
if (PARAMS_SideMissionReinforcement == 1) then { _null = [] execVM "reinforcements\SM_HELO_ORCA.sqf"; };

_isPerpetual = false;

if (PARAMS_Perpetual == 1) then 
{
	_isPerpetual = true;
};

currentAO = "Nothing";
publicVariable "currentAO";
_lastTarget = "Nothing";
_targetsLeft = count _targets;

"TakeMarker" addPublicVariableEventHandler
{	
	createMarker [((_this select 1) select 0), getMarkerPos ((_this select 1) select 1)];
	"theTakeMarker" setMarkerShape "ICON";
	"theTakeMarker" setMarkerType "o_unknown";
	"theTakeMarker" setMarkerColor "ColorOPFOR";
	"theTakeMarker" setMarkerText format["Take %1", ((_this select 1) select 1)];
};

"addToScore" addPublicVariableEventHandler
{
	((_this select 1) select 0) addScore ((_this select 1) select 1);
};

AW_fnc_minefield = {
	_centralPos = _this select 0;
	_unitsArray = [];
	for "_x" from 0 to 79 do 
	{
		_mine = createMine ["SLAMDirectionalMine", _centralPos, [], 50];
		_unitsArray = _unitsArray + [_mine];
	};

	_distance = 50;
	_dir = 0;
	for "_c" from 0 to 7 do
	{
		_pos = [_flatPos, _distance, _dir] call BIS_fnc_relPos;
		_sign = "Land_Sign_Mines_F" createVehicle _pos;
		waitUntil {alive _sign};
		_sign setDir _dir;
		_dir = _dir + 45;
		
		_unitsArray = _unitsArray + [_sign];
	};

	_unitsArray
};

AW_fnc_deleteOldAOUnits =
{
	private ["_unitsArray", "_obj", "_isGroup"];
	sleep 600;
	_unitsArray = _this select 0;
	for "_c" from 0 to (count _unitsArray) do
	{
		_obj = _unitsArray select _c;
		_isGroup = false; if (_obj in allGroups) then { _isGroup = true; };
		if (_isGroup) then
		{
			{
				if (!isNull _x) then { deleteVehicle _x; };
			} forEach (units _obj);
		} else {
			if (!isNull _obj) then { deleteVehicle _obj; };
		};
	};
};

AW_fnc_deleteSingleUnit = {
	
	private ["_obj","_time"];
	_obj = _this select 0;
	_time = _this select 1;
	sleep _time;
	deleteVehicle _obj;
};

AW_fnc_rewardPlusHint = {	
	
	private ["_veh","_vehName","_vehVarname","_completeText","_reward"];
	_veh = smRewards call BIS_fnc_selectRandom;
	_vehName = _veh select 0;
	_vehVarname = _veh select 1;
	
	_completeText = format[
	"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>We've given you %1 to help with the fight. You'll find it at base.<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>",_vehName];
	
	_reward = createVehicle [_vehVarname, getMarkerPos "smReward1",smMarkerList,0,"NONE"];
	if (_reward isKindOf "UAV") then {createVehicleCrew _reward;} else {sleep 1;};
	waitUntil {!isNull _reward};
	_reward setDir 284;
	
	[_reward] execVM "scripts\aw_unitSetup.sqf";
	
	GlobalHint = _completeText; publicVariable "GlobalHint"; hint parseText _completeText;
	showNotification = ["CompletedSideMission", sideMarkerText]; publicVariable "showNotification";
	showNotification = ["Reward", format["Your team received %1!", _vehName]]; publicVariable "showNotification";
};

_unitSpawnPlus = PARAMS_AOSize;
_unitSpawnMinus = _unitSpawnPlus - (_unitSpawnPlus * 2);

AW_fnc_garrisonBuildings = 
{
	_building = _this select 0;
	_faction = "OPF_F";
	_coef = 1;

	BIS_getRelPos = {
		_relDir = [_this, player] call BIS_fnc_relativeDirTo;
		_dist = [_this, player] call BIS_fnc_distance2D;
		_elev = ((getPosASL _this) select 2) - ((getPosASL player) select 2);
		_dir = (direction player) - direction _this;
		
		[_relDir, _dist, _elev, _dir];
	};

	_buildings = [
		"Land_Cargo_House_V1_F", [
			[216.049,2.33014,-0.0721207,-173.782]
		],
		"Land_Cargo_House_V2_F", [
			[216.049,2.33014,-0.0721207,-173.782]
		],
		"Land_Cargo_HQ_V1_F", [
			[-89.3972,5.45408,-0.724457,-89.757],
			[160.876,5.95225,-0.59613,-0.245575],
			[30.379,5.37352,-3.03543,-32.9396],
			[49.9438,7.04951,-3.03488,1.15405],
			[109.73,7.20652,-3.12396,-273.082],
			[190.289,6.1683,-3.12094,-181.174],
			[212.535,6.83544,-3.1217,-154.507]
		],
		"Land_Cargo_Patrol_V1_F", [
			[84.1156,2.21253,-4.1396,88.6112],
			[316.962,3.81801,-4.14061,270.592],
			[31.6563,3.91418,-4.13602,-0.194908]
			
		],
		"Land_Cargo_Tower_V1_F", [
			[99.5325,3.79597,-4.62543,-271,3285],
			[-65.1654,4.17803,-8.59327,2,79],
			[-50.097,4.35226,-12.7691,2,703],
			[115.749,5.55055,-12.7623,-270,6282],
			[-143.89,7.92183,-12.9027,-180,867],
			[67.2957,6.75608,-15.4993,-270,672],
			[-68.9994,7.14031,-15.507,-88,597],
			[195.095,7.46374,-17.792,-182,651],
			[-144.962,8.67736,-17.7939,-178,337],
			[111.831,6.52689,-17.7889,-271,5161],
			[-48.2151,6.2476,-17.7976,-1,334],
			[-24.622,4.62995,-17.796,1,79]
		],
		"Land_i_Barracks_V1_F", [
			[66.6219,14.8599,-3.8678,94.6476],
			[52.0705,10.0203,-3.86142,4.09206],
			[11.4515,6.26249,-3.85385,1.42117],
			[306.455,10.193,-3.84314,0.0715332],
			[294.846,14.2778,-3.83774,-91.0892],
			[7.04782,1.86908,-0.502411,-90.3917],
			[86.3556,7.98911,-0.510651,129.846]
		],
		"Land_i_Barracks_V2_F", [
			[66.6219,14.8599,-3.8678,94.6476],
			[52.0705,10.0203,-3.86142,4.09206],
			[11.4515,6.26249,-3.85385,1.42117],
			[306.455,10.193,-3.84314,0.0715332],
			[294.846,14.2778,-3.83774,-91.0892],
			[7.04782,1.86908,-0.502411,-90.3917],
			[86.3556,7.98911,-0.510651,129.846]
		]
	];

	if (!(typeOf _building in _buildings)) exitWith {_newGrp = objNull; _newGrp};

	_paramsArray = (_buildings select ((_buildings find (typeOf _building)) + 1));
	_finalCnt = count _paramsArray;

	_newGrp = createGroup EAST;

	_units = ["O_Soldier_F", "O_Soldier_AR_F"];

	{
		_pos =  [_building, _x select 1, (_x select 0) + direction _building] call BIS_fnc_relPos;
		_pos = [_pos select 0, _pos select 1, ((getPosASL _building) select 2) - (_x select 2)];
		_units select floor random 2 createUnit [_pos, _newGrp, "BIS_currentDude = this"];
		doStop BIS_currentDude;
		commandStop BIS_currentDude;
		BIS_currentDude setPosASL _pos;
		BIS_currentDude setUnitPos "UP";
		BIS_currentDude doWatch ([BIS_currentDude, 1000, direction _building + (_x select 3)] call BIS_fnc_relPos);
		BIS_currentDude setDir direction _building + (_x select 3);
	} forEach _paramsArray;
	[(units _newGrp)] call aw_setGroupSkill;
	_newGrp
};

AW_fnc_spawnUnits = {
	
	private ["_randomPos","_spawnGroup","_pos","_x","_armourGroup","_armour","_airGroup","_air","_airType"];
	_pos = getMarkerPos (_this select 0);
	_enemiesArray = [grpNull];
	
	_x = 0;
	for "_x" from 1 to PARAMS_SquadsPatrol do {
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
		"O_Soldier_AA_F" createUnit [_randomPos, _spawnGroup];
		[_spawnGroup, getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_spawn2_randomPatrol;
		[(units _spawnGroup)] call aw_setGroupSkill;
		
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	}; 
	
	_x = 0;
	for "_x" from 1 to PARAMS_SquadsDefend do {
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
		"O_Soldier_AA_F" createUnit [_randomPos, _spawnGroup];
		[_spawnGroup, getMarkerPos currentAO,50] call aw_fnc_spawn2_perimeterPatrol;
		[(units _spawnGroup)] call aw_setGroupSkill;
		
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Defend %1",_x];;
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	_x = 0;
	for "_x" from 1 to PARAMS_TeamsPatrol do {
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		/* "O_Soldier_AA_F" createUnit [_randomPos, _spawnGroup];
		[_spawnGroup, getMarkerPos currentAO, (PARAMS_AOSize / 2)] call aw_fnc_spawn2_randomPatrol; */
		[(units _spawnGroup)] call aw_setGroupSkill;
		
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Team Patrol %1",_x];;
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	_x = 0;
	for "_x" from 1 to PARAMS_CarsPatrol do {
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize,6] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Team")] call BIS_fnc_spawnGroup;
		[_spawnGroup, getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_spawn2_randomPatrol;
		(vehicle (leader _spawnGroup)) spawn aw_fnc_fuelMonitor;
		[(units _spawnGroup)] call aw_setGroupSkill;
		
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Car %1",_x];;
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	for "_x" from 1 to PARAMS_ArmourPatrol do {
		_armourGroup = createGroup east;
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize,7] call aw_fnc_randomPos;
		if(random 1 < 0.75) then {_armour = "O_MBT_02_cannon_F" createVehicle _randomPos} else {_armour = "O_APC_Tracked_02_AA_F" createVehicle _randomPos};
		waitUntil{!isNull _armour};
		
		"O_crew_F" createUnit [_randomPos,_armourGroup];
		"O_crew_F" createUnit [_randomPos,_armourGroup];
		
		((units _armourGroup) select 0) assignAsDriver _armour;
		((units _armourGroup) select 1) assignAsGunner _armour;
		((units _armourGroup) select 0) moveInDriver _armour;
		((units _armourGroup) select 1) moveInGunner _armour;
		[_armourGroup,getMarkerPos currentAO,(PARAMS_AOSize / 2)] call aw_fnc_spawn2_perimeterPatrol;
		_armour spawn aw_fnc_fuelMonitor;
		_enemiesArray = _enemiesArray + [_armourGroup];
		[(units _armourGroup)] call aw_setGroupSkill;
		
		//_armour lock true;
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _armourGroup),_x];
			createMarker [_name,getPos (leader _armourGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["APC %1",_x];;
			_name setMarkerColor "ColorRed";
			[_armourGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
	};
	
	if((random 10 <= PARAMS_AirPatrol)) 
		then {
		_airGroup = createGroup east;
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_randomPos;
		_airType = if(random 1 <= 0.5) then {"O_Heli_Attack_02_F"} else {"O_Heli_Attack_02_F"};
		_air = _airType createVehicle [_randomPos select 0,_randomPos select 1,1000];
		waitUntil{!isNull _air};
		_air engineOn true;
		//_air lock 0;
		_air setPos [_randomPos select 0,_randomPos select 1,300];
		
		_air spawn 
		{
			private["_x"];
			for [{_x=0},{_x<=200},{_x=_x+1}] do
			{
				_this setVelocity [0,0,0];
				sleep 0.1;
			};
		};
		
		"O_crew_F" createUnit [_randomPos,_airGroup];
		((units _airGroup) select 0) assignAsDriver _air;
		((units _airGroup) select 0) moveInDriver _air;
		
		if(_airType == "O_Heli_Attack_02_F") then
		{
			"O_crew_F" createUnit [_randomPos,_airGroup];
			((units _airGroup) select 1) assignAsGunner _air;
			((units _airGroup) select 1) moveInGunner _air;
		};
		
		[_airGroup,getMarkerPos currentAO,(2 * (PARAMS_AOSize / 3))] call aw_fnc_spawn2_perimeterPatrol;
		_air spawn aw_fnc_fuelMonitor;
		_enemiesArray = _enemiesArray + [_airGroup];
		[(units _airGroup)] call aw_setGroupSkill;
		
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _airGroup),_x];
			createMarker [_name,getPos (leader _airGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Air %1",_x];;
			_name setMarkerColor "ColorRed";
			[_airGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
	};

	for "_x" from 1 to PARAMS_SniperPatrol do {
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_SniperTeam")] call BIS_fnc_spawnGroup;
		/* "O_Soldier_AA_F" createUnit [_randomPos, _spawnGroup];
		[_spawnGroup, getMarkerPos currentAO, (PARAMS_AOSize / 2)] call aw_fnc_spawn2_randomPatrol; */
		[(units _spawnGroup)] call aw_setGroupSkill;
		
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Sentry Patrol %1",_x];;
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};

	for "_x" from 1 to PARAMS_TeamsMiniDronePatrol do {
		_randomPos = [getMarkerPos currentAO, PARAMS_AOSize] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "SpecOps" >> "OI_SmallTeam_UAV")] call BIS_fnc_spawnGroup;
		[(units _spawnGroup)] call aw_setGroupSkill;
		
		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Mini Drone Patrol %1",_x];;
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn 
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;
				
				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};

	{
		_newGrp = [_x] call AW_fnc_garrisonBuildings;
		if (!isNull _newGrp) then { _enemiesArray = _enemiesArray + [_newGrp]; };
	} forEach (getMarkerPos currentAO nearEntities ["House", 600]);
	
	_enemiesArray
};

//Set time of day
skipTime PARAMS_TimeOfDay;

//Set weather
0 setWindForce random 1;
0 setWindDir random 360;
0 setGusts random 1;

switch (PARAMS_Weather) do 
{
	case 1: {
		0 setOvercast 0;
		0 setRain 0;
		0 setFog 0;
	};
	
	case 2: {
		0 setOvercast 1;
		0 setRain 1;
		0 setFog 0.2;
		0 setGusts 1;
		0 setLightnings 1;
		0 setWaves 1;
		0 setWindForce 0.5;
	};
	
	case 3: {
		0 setOvercast 0.7;
		0 setRain 0;
		0 setFog 0;
		0 setGusts 0.5;
		0 setWaves 0.7;
		0 setWindForce 0.3;
	};
	
	case 4: {
		0 setOvercast 0.7;
		0 setRain 1;
		0 setFog 0.7;
	};
};

//Spawn random wrecks
if (PARAMS_PriorityTargets == 1) then
{
	{
		_accepted = false;
		_position = [0,0,0];
		while {!_accepted} do
		{
			_position = [] call BIS_fnc_randomPos;
			if (_position distance (getMarkerPos "respawn_west") > 800) then
			{
				_accepted = true;
			};
		};
		_randomWreck = _x createVehicle _position;
		_randomWreck setDir (random 360);
	} forEach ["Land_Wreck_Commanche_F","Land_UWreck_Mv22_F","Land_UWreck_Mv22_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Car_F","Land_Wreck_Car2_F","Land_Wreck_Car3_F"];
};

//Begin generating side missions
if (PARAMS_SideMissions == 1) then { _null = [] execVM "sm\sideMissions.sqf"; };

//Begin generating priority targets
if (PARAMS_PriorityTargets == 1) then { _null = [] execVM "sm\priorityTargets.sqf"; };

//Begin creating random patrols
// _null = [] execVM "randomPatrols.sqf";

_firstTarget = true;
_lastTarget = "Nothing";

while {count _targets > 0} do
{
	sleep 10;
	
	//Set new current target and calculate targets left
	if (_isPerpetual) then 
	{
		_validTarget = false;
		while {!_validTarget} do 
		{
			currentAO = _targets call BIS_fnc_selectRandom;
			if (currentAO != _lastTarget) then 
			{
				_validTarget = true;
			};
			debugMessage = format["_validTarget = %1; %2 was our last target.",_validTarget,currentAO];
			publicVariable "debugMessage";
		};
	} else {
		currentAO = _targets call BIS_fnc_selectRandom;
		_targetsLeft = count _targets;
	};
	
	//Set currentAO for UAVs and JIP updates
	publicVariable "currentAO";
	currentAOUp = true;
	publicVariable "currentAOUp";
	
	//Edit and place markers for new target
	//_marker = [currentAO] call AW_fnc_markerActivate
	{_x setMarkerPos (getMarkerPos currentAO);} forEach ["aoCircle","aoMarker"];
	"aoMarker" setMarkerText format["Take %1",currentAO];
	sleep 5;
	publicVariable "refreshMarkers";
	
	//Create AO detection trigger
	_dt = createTrigger ["EmptyDetector", getMarkerPos currentAO];
	_dt setTriggerArea [PARAMS_AOSize, PARAMS_AOSize, 0, false];
	_dt setTriggerActivation ["EAST", "PRESENT", false];
	_dt setTriggerStatements ["this","",""];
	
	//Spawn enemies
	_enemiesArray = [currentAO] call AW_fnc_spawnUnits;

	//Spawn radiotower
	_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
	_flatPos = _position isFlatEmpty[3, 1, 0.7, 20, 0, false];
		
	while {(count _flatPos) < 1} do
	{
		_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty[3, 1, 0.7, 20, 0, false];	
	};
	
	radioTower = "Land_TTowerBig_2_F" createVehicle _flatPos;
	waitUntil {sleep 0.5; alive radioTower};
	radioTower setVectorUp [0,0,1];
	radioTowerAlive = true;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos (getPos radioTower);

	//Spawn mines
	_chance = random 10;
	if (_chance < PARAMS_RadioTowerMineFieldChance) then
	{
		_mines = [_flatPos] call AW_fnc_minefield;
		_enemiesArray = _enemiesArray + _mines;
		"radioMineCircle" setMarkerPos (getPos radioTower);
		"radioMarker" setMarkerText "Radiotower (Minefield)";
	} else {
		"radioMarker" setMarkerText "Radiotower";
	};

	publicVariable "radioTower";
	
	//Set target start text
	_targetStartText = format
	[
		"<t align='center' size='2.2'>New Target</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/>We did a good job with the last target, lads. I want to see the same again. Get yourselves over to %1 and take 'em all down!<br/><br/>Remember to take down that radio tower so you can use your Personal UAVs, too.",
		currentAO
	];
	
	if (!_isPerpetual) then 
	{
		_targetStartText = format
		[
			"%1 Only %2 more targets to go!",
			_targetStartText,
			_targetsLeft
		];
	};
	
	//Show global target start hint
	GlobalHint = _targetStartText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["NewMain", currentAO]; publicVariable "showNotification";
	showNotification = ["NewSub", "Destroy the enemy radio tower."]; publicVariable "showNotification";

	
	/* =============================================== */
	/* ========= WAIT FOR TARGET COMPLETION ========== */
	waitUntil {sleep 5; count list _dt > PARAMS_EnemyLeftThreshhold};
	waitUntil {sleep 0.5; !alive radioTower};
	radioTowerAlive = false;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos [0,0,0];
	_radioTowerDownText = 
		"<t align='center' size='2.2'>Radio Tower</t><br/><t size='1.5' color='#08b000' align='center'>DESTROYED</t><br/>____________________<br/>The enemy radio tower has been destroyed! Fantastic job, lads! You're now all free to use your Personal UAVs!<br/><br/>Keep up the good work, lads; we're countin' on you.";
	GlobalHint = _radioTowerDownText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["CompletedSub", "Enemy radio tower destroyed."]; publicVariable "showNotification";
	showNotification = ["Reward", "Personal UAVs now available."]; publicVariable "showNotification";
	
	waitUntil {sleep 5; count list _dt < PARAMS_EnemyLeftThreshhold};
	
	//Set enemy kill timer
	[_enemiesArray] spawn AW_fnc_deleteOldAOUnits;

	//Delete markers and trigger
	/* if (_isPerpetual) then 
	{
		//_perimeterMarker = [currentAO] call AW_fnc_markerDeactivate;
		if (count _targets == 1) then
		{
			_targets = _initialTargets;
			_lastTarget = currentAO;
			publicVariable "refreshMarkers";
		} else {
			_targets = _targets - [currentAO];
		};	
	} else {
		_targets = _targets - [currentAO];
		//deleteMarker currentAO;
	}; */

	if (_isPerpetual) then
	{
		_lastTarget = currentAO;
		if ((count (_targets)) == 1) then
		{
			_targets = _initialTargets;
		} else {
			_targets = _targets - [currentAO];
		};
	} else {
		_targets = _targets - [currentAO];
	};

	publicVariable "refreshMarkers";
	currentAOUp = false;
	publicVariable "currentAOUp";
	
	//Delete detection trigger and markers
	deleteVehicle _dt;
	radioTowerAlive = true;
	publicVariable "radioTowerAlive";
	
	//Small sleep to let deletions process
	sleep 5;
	
	//Set target completion text
	_targetCompleteText = format
	[
		"<t align='center' size='2.2'>Target Taken</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/><t align='left'>Fantastic job taking %1, boys! Give us a moment here at HQ and we'll line up your next target for you.</t>",
		currentAO
	];

	{_x setMarkerPos [0,0,0];} forEach ["aoCircle","aoMarker","radioMineCircle"];
	
	//Show global target completion hint
	GlobalHint = _targetCompleteText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["CompletedMain", currentAO]; publicVariable "showNotification";
	[] spawn aw_cleanGroups;
};

//Set completion text
_missionCompleteText = "<t align='center' size='2.0'>Congratulations!</t><br/>
<t size='1.2' align='center'>You've successfully completed Ahoy World Invade &amp; Annex!</t><br/>
____________________<br/>
<br/>
Thank you so much for playing and we hope to see you in the future. For more and to aid in the development of this mission, please visit www.AhoyWorld.co.uk.<br/>
<br/>
The game will return to the mission screen in 30 seconds. Consider turning Perpetual Mode on in the parameters to make the game play infinitely.";
	
//Show global mission completion hint
GlobalHint = _missionCompleteText;
publicVariable "GlobalHint";
hint parseText GlobalHint;

//Wait 30 seconds
sleep 30;

//End mission
endMission "END1";