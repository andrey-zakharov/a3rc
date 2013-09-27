_timer = 300;

while { true } do
{	
	sleep _timer;
	artyVehiclee vehicleChat "Mortar HE reload in 20 minutes.";
	sleep _timer;
	artyVehiclee vehicleChat "Mortar HE reload in 15 minutes.";
	sleep _timer;
	artyVehiclee vehicleChat "Mortar HE reload in 10 minutes.";
	sleep _timer;
	artyVehiclee vehicleChat "Mortar HE reload in 5 minutes.";
	sleep _timer;
	artyVehiclee removeMagazines "12Rnd_230mm_rockets";
	artyVehiclee vehicleChat "Mortar HE Magazines Removed.";
	sleep 1;
	artyVehiclee addMagazines ["12Rnd_230mm_rockets", 1];
	artyVehiclee vehicleChat "Mortar HE Magazines Reloaded.";
	
};