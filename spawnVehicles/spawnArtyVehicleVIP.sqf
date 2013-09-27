_artyVehicleVIP = createVehicle ["B_MBT_01_arty_F", getMarkerPos "artyVehicleVIP",[],0,"NONE"];
waitUntil {alive _artyVehicleVIP};
_artyVehicleVIP setDir 45;
    _artyVehicleVIP setVehicleVarName "artyVehicleeVIP";
    artyVehicleeVIP = _artyVehicleVIP;
_m = [artyVehicleeVIP, 300, 920, 0, FALSE] execVM "vehicle.sqf";
artyVehicleeVIP setObjectTexture [0,"GamersCentral.de.jpg"];
while { true } do  
{
_artyVehicleVIP removeMagazines "6Rnd_155mm_Mo_AT_mine"; 
_artyVehicleVIP removeMagazines "6Rnd_155mm_Mo_mine"; 
_artyVehicleVIP removeMagazines "6Rnd_155mm_Mo_Cluster"; 
};
