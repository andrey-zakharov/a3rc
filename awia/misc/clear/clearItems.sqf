private ["_itemsToClear","_obj","_rad","_delay"];
_obj = getPos player; // get spawn - might as well
_rad = 100;  //  radius outwards from center point to clear items.
_delay = 600; // amount of time in-between clean-ups
 
while {true} do
{
	sleep _delay;
	_itemsToClear = nearestObjects [_obj,["weaponholder","GroundWeaponHolder","WeaponHolderSimulated"],_rad];
	{
		deleteVehicle _x;
	} forEach _itemsToClear;	
};
