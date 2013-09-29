if ( isServer ) exitWith{};
[] spawn {
	waitUntil { sleep 1; alive player };

	if ( isClass(configfile >> "CfgPatches" >> "acre_sys_radio") ) then {
		//systemChat "Common SW: 123.0, LW: 50.0";
		//hint "Common SW: 123.0, LW: 50.0";
	} else {
		if ( isMultiplayer ) then {
			systemChat "You can play 15 minutes without Task Force Radio plugin. Visit A3RC.COM for instructions!";
			sleep 600;
			systemChat "5 minutes remains without Task Force Radio plugin. Visit A3RC.COM for instructions!!!";
			sleep 300;
			"end1" call BIS_fnc_endMission;
		} else {
		 	hint "no radio";
		 	//"end1" call BIS_fnc_endMission;
		};
	};
};
