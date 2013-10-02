
waitUntil {sleep 0.5; !(isNil "currentAOUp")};
waitUntil {sleep 0.5; !(isNil "currentAO")};

while {true} do {
    if (currentAOUp && radioTowerAlive) then {    // && {!_helo_in_patrol}) then {
        _patrolPos=getMarkerPos currentAO;
        //_helo_in_patrol = true;
        _helo_Array = [[200, _patrolPos select 1, 200], 20, ["O_Heli_Light_02_F"] call BIS_fnc_selectRandom, east] call BIS_fnc_spawnVehicle;
        _helo_Patrol = _helo_Array select 0;
        _helo_crew = _helo_Array select 1;
        [_helo_Array select 2, _patrolPos, 500] call BIS_fnc_taskPatrol;
		showNotification = ["EnemyHelo", "Enemy Helicopter approaching to AO."]; publicVariable "showNotification";
        
        waitUntil {
            sleep 15;
            _helo_Patrol setVehicleAmmo 1;
			sleep 1;
			_helo_Patrol removeMagazineTurret ["12Rnd_PG_missiles",[0]]; 
			_helo_Patrol removeMagazines "12Rnd_PG_missiles"; 
            !alive _helo_Patrol || {!canMove _helo_Patrol}
        };
		showNotification = ["EnemyHeloDown", "Enemy Helicopter is down. Well Done! (AO)"]; publicVariable "showNotification";
        sleep 120;
        _helo_Patrol setDamage 1;
        sleep 120;
        deleteVehicle _helo_Patrol;
        
        {
            _x setDamage 1;
            sleep 10;
            deleteVehicle _x;
        } foreach _helo_crew;
        sleep (900 + (random 300));
        
    };

    sleep 30;
};
