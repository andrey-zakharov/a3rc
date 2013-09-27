if (!isServer) then
{
	while {true} do
	{
		waitUntil {alive player};
		{ _x radioChannelAdd [player]; } forEach radioChannels;
		waitUntil {!alive player};
	};
} else {
	_mainIndex = radioChannelCreate [
		[1.0, 0.81, 0.06, 1],
		"Main AO Channel",
		"[AO] %UNIT_GRP_NAME %UNIT_NAME [%UNIT_VEH_NAME]",
		[player]
	];

	_sideIndex = radioChannelCreate [
		[0, 0.7, 0.93, 1],
		"Side Mission Channel",
		"[SM] %UNIT_GRP_NAME %UNIT_NAME [%UNIT_VEH_NAME]",
		[player]
	];

	_transportIndex = radioChannelCreate [
		[0.38, 0.81, 0.16, 1],
		"Transport Channel",
		"[TP] %UNIT_GRP_NAME %UNIT_NAME [%UNIT_VEH_NAME]",
		[player]
	];

	radioChannels = [_mainIndex, _sideIndex, _transportIndex];
	publicVariable "radioChannels";
};

/*
	Make sure players are added to this
	channel upon entering the game.

	TODO:
		-	Find a good way to be able to
			subscribe/unsubscribe to/from
			channels. Dialog would be perfect.
*/
