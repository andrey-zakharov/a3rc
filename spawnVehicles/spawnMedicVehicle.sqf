_medicVehicle = createVehicle ["I_MRAP_03_F", getMarkerPos "medicVehicle",[],0,"NONE"];
waitUntil {alive _medicVehicle};
_medicVehicle setDir 227;
    _medicVehicle setVehicleVarName "medicVehiclee";
    medicVehiclee = _medicVehicle;
_m = [medicVehiclee, 300, 920, 0, FALSE] execVM "vehicle.sqf";

