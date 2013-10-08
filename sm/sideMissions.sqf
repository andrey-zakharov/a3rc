/*
	Insert public variable event handler into player init:

	"sideMarker" addPublicVariableEventHandler
	{
		"sideMarker" setMarkerPos (markerPos "sideMarker");
	};
	
	Also, we need an event handler for playing custom sounds via SAY.
	Pass the EH a variable that it can use to play the correct sound.
	
	For the addAction issue, we need to run the addAction command LOCALLY. Using forEach allUnits won't work as the action is still being run on the server.
	So, set up an EH that can add actions to units.
	
	For deletion of contact (and this applies to AO units, too!)...
		Using []spawn { }; will run code that then ignores the rest of the script!
		AWESOME!
*/

//Create base array of differing side missions

private ["_sideMissions", "_firstRun","_mission","_isGroup","_obj","_skipTimer","_awayFromBase","_road","_position","_deadHint","_civArray","_briefing","_altPosition","_truck","_chosenCiv","_contactPos","_civ","_flatPos","_accepted","_randomPos","_spawnGroup","_unitsArray","_randomDir","_hangar","_x","_completeText","_roadList"];
_sideMissions = 

[
	"talkToContact",
	"destroyChopper",
	"destroySmallRadar",
	"destroyExplosivesCoast"
];

_mission = "";

_completeText = 
"<t align='center'><t size='2.2'>Side Mission</t><br/>
<t size='1.5' color='#00B2EE'>COMPLETE</t><br/>
____________________<br/>
Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/>
<br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>";

//Set up some vars
_firstRun = true; //debug
_skipTimer = false;
_roadList = island nearRoads 4000; //change this to the BIS function that creates a trigger covering the map
_contactPos = [0,0,0];
_unitsArray = [sideObj];

while {true} do
{	
	if (_firstRun) then
	{
		//Debug if statement only...
		_firstRun = false;
		sleep 10;
		//Select random mission from the SM list
		_mission = _sideMissions call BIS_fnc_selectRandom;
	} else {
		if (!_skipTimer) then
		{
			//Wait between 15-30 minutes before assigning a mission
			sleep (900 + (random 900));
			
			//Delete old PT objects
			for "_c" from 0 to (count _unitsArray) do
			{
				_obj = _unitsArray select _c;
				_isGroup = false;
				if (_obj in allGroups) then { _isGroup = true; } else { _isGroup = false; };
				if (_isGroup) then
				{
					{
						if (!isNull _x) then
						{
							deleteVehicle _x;
						};
					} forEach (units _obj);
					deleteGroup _obj;
				} else {
					if (!isNull _obj) then
					{
						deleteVehicle _obj;
					};
				};
			};

			//Select random mission from the SM list
			_mission = _sideMissions call BIS_fnc_selectRandom;
		} else {
			//Reset skipTimer
			_skipTimer = false;
		};
	};
	
	//Grab the code for the selected mission
	_ret = call compile loadfile format ["sm\%1.sqf", _mission ];

	if ( _mission == "talkToContact" && _ret == True ) then {
		while {_mission == "talkToContact"} do {
			_mission = _sideMissions call BIS_fnc_selectRandom;
		};

		_skipTimer = true;
		
		aw_unitSay3D = [sideObj, "nothing"];
		
		switch (_mission) do
		{
			case "destroyChopper":
			{
				aw_unitSay = [sideObj, "contactDestroyChopper"];
			};
			
			case "destroySmallRadar":
			{
				aw_unitSay = [sideObj, "contactDestroySmallRadar"];
			};
			
			case "destroyMortars":
			{
				aw_unitSay = [sideObj, "contactDestroyMortars"];
			};

			case "rescuePilots":
			{
				aw_unitSay = [sideObj, "contactRescuePilots"];
			};

			case "rescueCivs":
			{
				aw_unitSay = [sideObj, "contactRescueCivs"];
			};

			case "convoyKillVIP":
			{
				aw_unitSay = [sideObj, "contactConvoyKillVIP"];
			};
		};

		publicVariable "aw_unitSay";
	};
	/*
	switch (_mission) do
	{


		case "clearMines":
		{
			//Set up briefing message
			_briefing = 
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Clear Mines</t><br/>____________________<br/>OPFOR forces have been placing mines along the roads in Stratis in a desperate attempt to slow us down. Thermal imaging scans have picked up a lot of troop movement around the area we've marked on your map and we suspect they've been planting mines.<br/><br/>Head over to the marker on the map and disarm any mines you find. We've got convoys waiting, soldier; get going!</t>";
		}; /* case "clearMines": 

	}*/
};