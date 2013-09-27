while {true} do
{
	waitUntil {sleep 0.5; alive player};
	if (typeOf player != "B_engineer_F") then
	{
		private "_vMHQ";

		while {alive player} do
		{
			waitUntil {sleep 0.5; vehicle player != player};

			_vMHQ = vehicle player;
			if (_vMHQ isKindOf "B_APC_Tracked_01_CRV_F") then
			{
				if (driver _vMHQ == player) then
				{
					player action ["eject", _vMHQ];
					waitUntil {sleep 0.5; vehicle player == player};
					player action ["engineOff", _vMHQ];
					systemChat "Server: You must be the MHQ - Supply Driver to use this Vehicle!";
				};
			};
		};
	} else {
		waitUntil {sleep 0.5; !alive player};
	};
};