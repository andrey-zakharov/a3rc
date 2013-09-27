private ["_itemsToClear","_obj","_rad","_delay"];
_obj = getMarkerPos "protection_drones"; // get spawn - might as well
_rad = 50;  //  radius outwards from center point to clear items.
_delay = 1200; // amount of time in-between clean-ups
 
while {true} do
{
	sleep _delay;
	_itemsToClear = nearestObjects [_obj,["weaponholder","WeaponHolderSimulated"],_rad];
	{
		deleteVehicle _x;
	} forEach _itemsToClear;	
};
