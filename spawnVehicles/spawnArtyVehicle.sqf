_artyVehicle = createVehicle ["B_MBT_01_mlrs_F", getMarkerPos "artyVehicle",[],0,"NONE"];
waitUntil {alive _artyVehicle};
_artyVehicle setDir 40;
    _artyVehicle setVehicleVarName "artyVehiclee";
    artyVehiclee = _artyVehicle;
_m = [artyVehiclee, 300, 920, 0, FALSE] execVM "vehicle.sqf";
/*
while { true } do  
{
_artyVehicle removeMagazines "6Rnd_155mm_Mo_AT_mine"; 
_artyVehicle removeMagazines "6Rnd_155mm_Mo_mine"; 
_artyVehicle removeMagazines "6Rnd_155mm_Mo_Cluster"; 
};
*/