sidemissionup2 = true;
sleep 5;

_completehint = 
"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>";

	_SMhint = "<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Kill Officer</t><br/>____________________<br/>The OPFOR have an officer on the island. We must eliminate him as soon as possible. Kill that officer at all cost!</t>";
	
	hint parsetext _SMhint;

	_position = [[[getPos island, 5000]],["water","out"]] call BIS_fnc_randomPos;

	sideObj3 = "O_officer_F" createVehicle _position;
	objgaurd = "O_recon_F" createVehicle _position;
	objgaurd2 = "O_recon_F" createVehicle _position;

	sideObj3 setdir random 360;
	objgaurd setdir random 360;
	objgaurd2 setdir random 360;

	["objgaurd","objgaurd2"] join sideObj3;
	SMunits = SMunits + [sideObj3,objgaurd,objgaurd2];

	removeallweapons sideObj3;


		
		_random = floor (random 5) + 1;
		for "_i" from 0 to _random do
		{
		_randomPos = [getPos sideObj3,random 200 + 50] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, getpos sideObj3,random 200 + 50] call aw_fnc_spawn2_randomPatrol;
		[(units _spawnGroup)] call aw_setGroupSkill;
				
		SMunits = SMunits + (units _spawnGroup);
		};
			
			



			"sideMarker2" setmarkerpos (position sideObj3);
			"sideMarker2" setmarkertext "    Infantry (ONLY) - Side Mission: Kill Officer";
			"sideMarker2" setmarkercolor "ColorRed";
			waitUntil {!alive sideObj3};
			"sideMarker2" setMarkerPos [0,0,0];
			"sideMarker2" setmarkertext "";
			"sideMarker2" setmarkeralpha 0;
			hint parsetext _completehint;
			[] call AW_fnc_rewardPlusHintSideMissionTwo;
			sidemissionup2 = false;
			sleep 20;
			{deletevehicle _x} foreach SMunits;
			SMunits = [];
