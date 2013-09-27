_ammoVehicle = createVehicle ["B_Truck_01_ammo_F", getMarkerPos "ammoVehicle",[],0,"NONE"];
waitUntil {alive _ammoVehicle};
_ammoVehicle setDir 230;
    _ammoVehicle setVehicleVarName "ammoVehiclee";
    ammoVehiclee = _ammoVehicle;
_m = [ammoVehiclee, 60, 920, 0, FALSE] execVM "vehicle.sqf";
_ammoVehicle addAction["<t color='#FFA200'>Refuel Vehicle</t>", "misc\RefuelVehicleSupply.sqf"];
_ammoVehicle addAction["<t color='#FFA200'>Repair Vehicle</t>", "misc\repairVehicleSupply.sqf"];
_ammoVehicle addMagazineCargo ["200Rnd_127x99_mag_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["60Rnd_40mm_GPR_Tracer_Yellow_shells",50];
_ammoVehicle addMagazineCargo ["60Rnd_40mm_GPR_Tracer_Red_shells",50];
_ammoVehicle addMagazineCargo ["60Rnd_30mm_APFSDS_shells_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["60Rnd_30mm_APFSDS_shells_Tracer_Red",50];
_ammoVehicle addMagazineCargo ["2000Rnd_65x39_Belt_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["2000Rnd_65x39_Belt_Tracer_Red",50];
_ammoVehicle addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Red",50];
_ammoVehicle addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Red",50];
_ammoVehicle addMagazineCargo ["60Rnd_30mm_APFSDS_shells_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["40Rnd_40mm_APFSDS_Tracer_Yellow_shells",50];
_ammoVehicle addMagazineCargo ["2000Rnd_65x39_Belt_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["1000Rnd_65x39_Belt_Tracer_Yellow",50];
_ammoVehicle addMagazineCargo ["4Rnd_AAA_missiles",50];