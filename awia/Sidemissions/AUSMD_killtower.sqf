sidemissionup2 = true;
sleep 5;
_completehint = 
"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>";


	_SMhint = "<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destory Radio Tower</t><br/>____________________<br/>OPFOR have deployed a radio tower on the island that they are using for communications. Take out this tower, and OPFOR will go from organized to chaotic in minutes. Destory that tower!</t>";
	hint parsetext _SMhint;

	_position = [[[getPos island, 5000]],["water","out"]] call BIS_fnc_randomPos;

	sideObj3 = "Land_TTowerBig_1_F" createVehicle _position;
	sideObj3 setdir random 360;
	_normal = surfaceNormal (position sideObj3);
	sideObj3 setVectorUp _normal;
	SMunits = SMunits + [sideObj3];


		_random = floor (random 4) + 1;
		for "_i" from 0 to _random do
		{
		_randomPos = [getPos sideObj3,random 200 + 50] call aw_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, getpos sideObj3,random 200 + 50] call aw_fnc_spawn2_randomPatrol;
		[(units _spawnGroup)] call aw_setGroupSkill;
				
		SMunits = SMunits + (units _spawnGroup);
		};
	

			"sideMarker2" setmarkerpos (position sideObj3);
			"sideMarker2" setmarkertext "    Infantry (ONLY) - Side Mission: Destory Radio Tower";
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