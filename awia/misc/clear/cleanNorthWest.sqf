private ["_itemsToClear","_obj","_rad","_delay"];
hintSilent "Server Cleanup, please wait!";
_obj = getMarkerPos "northWest"; // get spawn - might as well
_rad = 2500;  //  radius outwards from center point to clear items.

_itemsToClear = nearestObjects [_obj,["weaponholder","GroundWeaponHolder","WeaponHolderSimulated"],_rad];
	{
		deleteVehicle _x;
	} forEach _itemsToClear;