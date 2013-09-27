while {true} do
{
	waitUntil {sleep 0.5; alive player};
	if (typeOf player != "B_soldier_UAV_F") then
	{
		private ["_v","_veh","_seats"];

		while {alive player} do
		{
			waitUntil {sleep 0.5; vehicle player != player};
			_veh = vehicle player;
			_seats = [driver _veh];
      if (_veh isKindOf "B_MBT_01_mlrs_F") then {_seats = _seats + [_veh turretUnit [0]];
        if (player in _seats) then {
          player action ["GetOut",_veh];
          waitUntil {vehicle player == player};
          systemChat "Server: You must be a Artillery Support to use Mortars!";
          if (isEngineOn _veh) then {_veh engineOn false};
        };
};
			_v = vehicle player;
			if (_v isKindOf "B_MBT_01_mlrs_F") then
			{
				if (driver _v == player) then
				{
					player action ["eject", _v];
					waitUntil {sleep 0.5; vehicle player == player};
					player action ["engineOff", _v];
					systemChat "Server: You must be a Artillery Support to use Mortars!";
				};
			};
		};
	} else {
		waitUntil {sleep 0.5; !alive player};
	};
};