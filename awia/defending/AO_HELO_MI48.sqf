waitUntil {sleep 0.5; !(isNil "currentAOUp")};
waitUntil {sleep 0.5; !(isNil "currentAO")};
private ["_priorityMessageHelo"];

while {true} do {
sleep (1600 + (random 1600));
    if (currentAOUp) then {
        if (currentAOUp) then {    // && {!_helo_in_patrol}) then {
            _patrolPos=getMarkerPos currentAO;
            //_helo_in_patrol = true;
            _helo_Array = [[25000, _patrolPos select 1, 550], 20, ["O_Heli_Attack_02_F"] call BIS_fnc_selectRandom, east] call BIS_fnc_spawnVehicle;
            _helo_Patrol = _helo_Array select 0;
            _helo_crew = _helo_Array select 1;
            [_helo_Array select 2, _patrolPos, 500] call BIS_fnc_taskPatrol;
			showNotification = ["EnemyHeavyHelo", "Enemy Mi-48 Kajman approaching to AO."]; publicVariable "showNotification";
			_priorityMessageHelo = 
			"<t align='center' size='2.2'>Priority Target (AO)</t><br/><t size='1.5' color='#b60000'>Enemy Mi-48 Kajman Inbound</t><br/>____________________<br/>OPFOR forces inbound with a Ki-48 Kajman to hit you guys damned hard!<br/><br/>This is a priority target, boys! They're just can be there within few minutes and they'll firing, seek cover!<br/><br/>HQ suggest to every Transport Helicopter to return to base until the danger got neutralised *deep peeep* Repeat: HQ suggest to every Transport Helicopter to return to base until the danger got neutralised, over!";
			GlobalHint = _priorityMessageHelo; publicVariable "GlobalHint"; hint parseText _priorityMessageHelo;
            waitUntil {
                sleep 15;
                _helo_Patrol setVehicleAmmo 1;
				sleep 1;
				_helo_Patrol removeMagazineTurret ["8Rnd_LG_scalpel",[0]]; 
				_helo_Patrol removeMagazines "8Rnd_LG_scalpel"; 
				_helo_Patrol removeMagazineTurret ["38Rnd_80mm_rockets",[0]]; 
				_helo_Patrol removeMagazines "38Rnd_80mm_rockets"; 
                !alive _helo_Patrol || {!canMove _helo_Patrol}
            };
			
		 [] call AW_fnc_rewardPlusHintMI;
			
            sleep 120;
            _helo_Patrol setDamage 1;
            sleep 120;
            deleteVehicle _helo_Patrol;
            
            {
                _x setDamage 1;
                sleep 10;
                deleteVehicle _x;
            } foreach _helo_crew;            
        };
    };
    sleep 30;
};
/*
	File: taskPatrol.sqf
	Author: Joris-Jan van 't Land

	Description:
	Create a random patrol of several waypoints around a given position.

	Parameter(s):
	_this select 0: the group to which to assign the waypoints (Group)
	_this select 1: the position on which to base the patrol (Array)
	_this select 2: the maximum distance between waypoints (Number)
	_this select 3: (optional) blacklist of areas (Array)
	
	Returns:
	Boolean - success flag
*/

/*
	File: spawnVehicle.sqf
	Author: Joris-Jan van 't Land

	Description:
	Function to spawn a certain vehicle type with all crew (including turrets).
	The vehicle can either become part of an existing group or create a new group.

	Parameter(s):
	_this select 0: desired position (Array).
	_this select 1: desired azimuth (Number).
	_this select 2: type of the vehicle (String).
	_this select 3: side or existing group (Side or Group).

	Returns:
	Array:
	0: new vehicle (Object).
	1: all crew (Array of Objects).
	2: vehicle's group (Group).
*/
