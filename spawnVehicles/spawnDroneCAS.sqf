if (typeOf player != "B_soldier_UAV_F") then
	{
		player globalChat "Only UAV are trained with this caliber of Aircraft - MQ4A Greyhawk (CAS). Drone not Spawned.";
	} else {
_drone = createVehicle ["B_UAV_02_CAS_F", getMarkerPos "drone1",["drone2"], 0, "NONE"];
_drone setDir -170;
createVehicleCrew _drone;
{
diag_log [_x, faction _x, side _x, side group _x];
} forEach crew _drone;	
};
