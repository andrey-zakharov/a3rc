_ammoVehicle2 = createVehicle ["B_Truck_01_ammo_F", getMarkerPos "ammoVehicle_2",[],0,"NONE"];
waitUntil {alive _ammoVehicle2};
_ammoVehicle2 setDir 227;
    _ammoVehicle2 setVehicleVarName "ammoVehicleee";
    ammoVehicleee = _ammoVehicle2;
_m = [ammoVehicleee, 10, 920, 0, FALSE] execVM "vehicle.sqf";
_ammoVehicle2 addAction["<t color='#FFA200'>Refuel Vehicle</t>", "misc\RefuelVehicleSupply.sqf"];
_ammoVehicle2 addAction["<t color='#FFA200'>Repair Vehicle</t>", "misc\repairVehicleSupply.sqf"];
_ammoVehicle2 addMagazineCargo ["200Rnd_127x99_mag_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["60Rnd_40mm_GPR_Tracer_Yellow_shells",50];
_ammoVehicle2 addMagazineCargo ["60Rnd_40mm_GPR_Tracer_Red_shells",50];
_ammoVehicle2 addMagazineCargo ["60Rnd_30mm_APFSDS_shells_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["60Rnd_30mm_APFSDS_shells_Tracer_Red",50];
_ammoVehicle2 addMagazineCargo ["2000Rnd_65x39_Belt_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["2000Rnd_65x39_Belt_Tracer_Red",50];
_ammoVehicle2 addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Red",50];
_ammoVehicle2 addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["140Rnd_30mm_MP_shells_Tracer_Red",50];
_ammoVehicle2 addMagazineCargo ["60Rnd_30mm_APFSDS_shells_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["40Rnd_40mm_APFSDS_Tracer_Yellow_shells",50];
_ammoVehicle2 addMagazineCargo ["2000Rnd_65x39_Belt_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["1000Rnd_65x39_Belt_Tracer_Yellow",50];
_ammoVehicle2 addMagazineCargo ["4Rnd_AAA_missiles",50];