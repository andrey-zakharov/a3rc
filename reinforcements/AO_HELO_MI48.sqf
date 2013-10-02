waitUntil {sleep 0.5; !(isNil "currentAOUp")};
waitUntil {sleep 0.5; !(isNil "currentAO")};
private ["_priorityMessageHelo"];

while {true} do {
	sleep (1600 + (random 1600));
    if (currentAOUp && radioTowerAlive) then {    // && {!_helo_in_patrol}) then {
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
    sleep 30;
};
