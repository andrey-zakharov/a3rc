/*
	GrenadeStop v0.8 for ArmA 3 Alpha by Bake (tweaked slightly by Rarek)
	
	DESCRIPTION:
	Stops players from throwing grenades in safety zones.
	
	INSTALLATION:
	Move grenadeStop.sqf to your mission's folder. Then add the
	following line to your init.sqf file (create one if necessary):
	execVM "grenadeStop.sqf";
	
	CONFIGURATION:
	Edit the #defines below.
*/

#define SAFETY_ZONES	[["respawn_west", 400], ["protection_drones", 200], ["protection_community", 200], ["community_protection", 200]] // Syntax: [["marker1", radius1], ["marker2", radius2], ...]
#define MESSAGE " ! S ! T ! O ! P !\n\n\nPlacing / throwing items and firing at base is STRICTLY PROHIBITED!\n\n\nPlease don't shoot at the base"
#define MORTAR_MESSAGE	"No point you putting that up, soldier; we're fresh out of ammo for those things."

if (isDedicated) exitWith {};
waitUntil {!isNull player};

player addEventHandler ["Fired", {
	if ({(_this select 0) distance getMarkerPos (_x select 0) < _x select 1} count SAFETY_ZONES > 0) then
	{
		deleteVehicle (_this select 6);
		titleText [MESSAGE, "PLAIN", 3];
	};
}];