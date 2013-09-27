_flatPos = [0,0,0];
			_accepted = false;
			while {!_accepted} do
			{
				_position = [] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					5,
					0,
					0.3,
					10,
					0,
					false
				];

				while {(count _flatPos) < 3} do
				{
					_position = [] call BIS_fnc_randomPos;
					_flatPos = _position isFlatEmpty
					[
						5,
						0,
						0.3,
						10,
						0,
						false
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 2600 && (_flatPos distance (getMarkerPos currentAO)) > 1600) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};


SMunits = [];
sidemissionup2 = false;

_grouparray = ["OIA_InfSentry","OIA_InfSquad","OIA_InfTeam","OIA_InfTeam_AA"];
_SMvehs = ["O_MRAP_02_F","O_Truck_02_covered_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","O_MBT_02_cannon_F","O_APC_Tracked_02_AA_F"];

while {true} do {

waitUntil {!sidemissionup2};

"sideMarker2" setmarkeralpha 0;

sleep 5 + random 9;

_SMselected = floor (random 3);

switch (_SMselected) do {
case 0:
{
	"sideMarker2" setmarkeralpha 1;
	"sideMarker2" setmarkertype "mil_dot";
	execVM "Sidemissions\AUSMD_killtower.sqf";
};
case 1:
{
	"sideMarker2" setmarkeralpha 1;
	"sideMarker2" setmarkertype "mil_dot";
	execVM "Sidemissions\AUSMD_killammo.sqf";
};
case 2:
{
	"sideMarker2" setmarkeralpha 1;
	"sideMarker2" setmarkertype "mil_dot";
	execVM "Sidemissions\AUSMD_killofficer.sqf";
		};
	};
sleep 500 + random 1000;
};

/*
case 3:
{
	"sideMarker2" setmarkeralpha 1;
	"sideMarker2" setmarkertype "mil_dot";
	execVM "Sidemissions\AUSMD_killvehicle.sqf";
};
*/