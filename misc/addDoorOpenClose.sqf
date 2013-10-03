
private ["_targetChoppa"];
_targetChoppa = _this;

// THIS ADDS THE DOORS TO THE MH-9
_targetChoppa animate ["addDoors",1];

// THIS REMOVES THE BENCHES FROM THE MH-9 (BUT PEOPLE CAN STILL SIT THERE)
_targetChoppa animate ["addBenches",0];


// THIS ADDS THE ACTIONS TO THE HELICOPTER
_targetChoppa addAction ["Open/Close Left Front Door", "misc\openClose.sqf",  (0), 0, false, true, "", "true"];
_targetChoppa addAction ["Open/Close Left Rear Door","misc\openClose.sqf",(1), 0, false, true, "", "true"];
_targetChoppa addAction ["Open/Close Right Front Door","misc\openClose.sqf",(2), 0, false, true, "", "true"];
_targetChoppa addAction ["Open/Close Right Rear Door","misc\openClose.sqf",(3), 0, false, true, "", "true"];
