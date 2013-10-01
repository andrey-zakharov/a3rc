if ( isServer ) exitWith{};
[] spawn {
	waitUntil { sleep 15; alive player };

	if ( isClass(configfile >> "CfgPatches" >> "acre_sys_radio") ) then {
		//systemChat "Common SW: 123.0, LW: 50.0";
		hint parseText localize "STR_RADIO_HINT";
	} else {

		if ( isMultiplayer ) then {
			if ( typeOf player == "B_Helipilot_F" ) exitWith {
				titleText [ localize "STR_NO_RADIO_PILOT", "BLACK FADED" ];
				sleep 10;
				forceEnd;
			}

			titleText [ localize "STR_NO_RADIO_15MINS", "PLAIN" ];
			sleep 600;
			titleText [ localize "STR_NO_RADIO_5MINS", "PLAIN" ];
			sleep 300;
			"end1" call BIS_fnc_endMission;
		} else {
		 	hint "no radio";
		 	//"end1" call BIS_fnc_endMission;
		};
	};
};
