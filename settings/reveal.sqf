while {true} do
{
	
_nearObjects = nearestObjects [vehicle player,[],15];

	{player reveal _x} forEach _nearObjects;

	sleep 4;

};