_operatorVehicle = createVehicle ["B_UGV_01_rcws_F", getMarkerPos "operatorVehicle1",["operatorVehicle2"], 0, "NONE"];
_operatorVehicle setDir -240;
createVehicleCrew _operatorVehicle;
{
	diag_log [_x, faction _x, side _x, side group _x];
} forEach crew _operatorVehicle;

