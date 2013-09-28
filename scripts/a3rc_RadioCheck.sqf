if ( isServer ) exitWith{};
waitUntil {!isNull player};

if !( player canAdd "tf_rt1523g" ) then {
	player globalChat "You can play 15 minutes without <br />Task Force Radio plugin. <t color=#7f0000>Visit A3RC.COM for instructions</t>";
	sleep 10 * 60;
	player globalChat "5 minutes remains without <br />Task Force Radio plugin. <t color=#7f0000>Visit A3RC.COM for instructions</t>";
	sleep 5 * 60;
	"end1" call BIS_fnc_endMission;
};
