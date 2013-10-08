//talkToContact
_position = [0,0,0];

_civArray = 
[
	"C_man_1",
	"C_man_polo_1_F",
	"C_man_polo_2_F",
	"C_man_polo_3_F",
	"C_man_polo_4_F",
	"C_man_polo_5_F",
	"C_man_polo_6_F",
	"C_man_1_1_F",
	"C_man_1_2_F",
	"C_man_1_3_F"
];
	
_briefing =
"<t align='center'><t size='2.2'>New Side Mission</t><br/>
<t size='1.5' color='#00B2EE'>Talk to Contact</t><br/>
____________________<br/>
Part of the civilian rebellion on the island has agreed to share information with us regarding some enemy plans.<br/>
<br/>
We've marked the location on your map; head over there and find out what he knows.</t>";

/*
	1.	Find random position on road. Use nearRoads trick
	2.	On that piece of road spawn a 4x4 truck and a single civilian standing near it
	3.	Create 'talkedToContact' bool; set to false
	3.	Add an action to the civilian which simply activates the "talkedToContact" variable
	4.	waitUntil either the civilian is dead or the variable is true
	5.	Get which has happened. If the civilian has died, end there. Otherwise, choose a new side mission there and then.
	6.	Upon selecting the new side mission, have the civilian say something relevant in direct chat while the global hint is displayed on the screen.
*/

//Find random position on road
_awayFromBase = false;
while {!_awayFromBase} do
{
	_road = _roadList call BIS_fnc_selectRandom;
	_position = getPos _road;
	
	if (_position distance (getMarkerPos "respawn_west") > 500 && (_position distance (getMarkerPos currentAO)) > 600) then
	{
		_awayFromBase = true;
	};
};

//Create truck and civilian using set dir (truck turned diagonally just off the road and the civilian standing by it) then wait until it's alive before we continue
_altPosition = [((_position select 0) + 5), (_position select 1), (_position select 2)];
_truck = "c_offroad" createVehicle _altPosition;
waitUntil {alive _truck};
_truck setDir (random 360);
_truck setVehicleLock "LOCKED";
_chosenCiv = _civArray call BIS_fnc_selectRandom;
sideObj = _chosenCiv createVehicle _position;
waitUntil {alive sideObj};
_contactPos = (getPos sideObj);
"sideMarker" setMarkerPos (getPos sideObj);
"sideMarker" setMarkerText "Side Mission: Talk to Contact";
publicVariable "sideMarker";
publicVariable "sideObj";

//Set up side mission variable
talkedToContact = false;

//Add a talking action to our civilian. Script simply has to set talkedToContact to true and PV it
aw_addAction = [sideObj, "Talk to Contact", "sm\talkedToContact.sqf"];
publicVariable "aw_addAction";

GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText _briefing;
showNotification = ["NewSideMission", "Talk to Contact"]; publicVariable "showNotification";

sideMissionUp = true;
publicVariable "sideMissionUp";
sideMarkerText = "Talk to Contact";
publicVariable "sideMarkerText";

//Wait until we've talked to the contact or the contact is dead
waitUntil {sleep 0.5; talkedToContact || !alive sideObj};

_res = False;

if (!alive sideObj) then
{
	_deadHint =
	"<t align='center'><t size='2.2'>Side Mission</t><br/>
	<t size='1.5' color='#b60000'>FAILED</t><br/>
	____________________<br/>
	Our civilian contact has died! God damnit, men, we're supposed to be protecting these people!<br/>
	<br/>Give us some time here at HQ and we'll figure out something else for you to screw up.<br/>
	<br/>I'm in the right mind to give you a mission to go and tell that poor boy's parents he's dead. Lucky for you I can't be bothered to code that crap.<t/>";

	GlobalHint = _deadHint;
	publicVariable "GlobalHint";
	hint parseText GlobalHint;
	
	"sideMarker" setMarkerPos [0,0,0];
	publicVariable "sideMarker";
	
	aw_removeAction = [sideObj,0];
	publicVariable "aw_removeAction";
	sideObj removeAction 0;
	_res = False;
} else {
	_res = True;
	

	sideObj removeAction 0;
};

sideMissionUp = false;
publicVariable "sideMissionUp";

_civ = sideObj;

{
	[_x,600] spawn AW_fnc_deleteSingleUnit; //DEBUG! This function needs urgently changing before being reintroduced so that it deletes the group these units created
} forEach [_civ, _truck];