if ( isServer ) exitWith{};
waitUntil {!isNull player};
[] spawn {

	if !( player canAdd "tf_rt1523g" ) then {
		player globalChat "You can play 15 minutes without Task Force Radio plugin. Visit A3RC.COM for instructions!";
		sleep 600;
		player globalChat "5 minutes remains without Task Force Radio plugin. Visit A3RC.COM for instructions!!!";
		sleep 300;
		"end1" call BIS_fnc_endMission;
	};
};
