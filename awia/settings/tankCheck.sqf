while {true} do
{
	waitUntil {sleep 0.5; alive player};
	if (typeOf player != "B_crew_F") then
	{
		while {alive player} do
		{
			waitUntil {sleep 0.5; vehicle player != player};
			_v = vehicle player;
			if (_v isKindOf "O_MBT_02_cannon_F") then
			{
				if (driver _v == player) then
				{
					player action ["eject", _v];
					waitUntil {sleep 0.5; vehicle player == player};
					player action ["engineOff", _v];
					systemChat format ["Server: Welcome %1! - You must be a Mechanized Infantry - Driver!", name player];
					sleep 3;
					systemChat format ["%1, the reason for the restriction is, Crewman has hes own functions.", name player];
				};
				
			};
			if (_v isKindOf "O_MBT_02_cannon_F") then
			{
				if (gunner _v == player) then
				{
					player action ["eject", _v];
					waitUntil {sleep 0.5; vehicle player == player};
					player action ["engineOff", _v];
					systemChat format ["Server: Welcome %1! - You must be a Mechanized Infantry - Gunner!", name player];
					sleep 3;
					systemChat format ["%1, the reason for the restriction is, Crewman has hes own functions.", name player];
				};
				
			};
		};
	} else {
		waitUntil {sleep 0.5; !alive player};
	};
};