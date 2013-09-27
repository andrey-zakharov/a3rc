/*
      ::: ::: :::             ::: :::             ::: 
     :+: :+:   :+:           :+:   :+:           :+:  
    +:+ +:+     +:+         +:+     +:+         +:+   
   +#+ +#+       +#+       +#+       +#+       +#+    
  +#+ +#+         +#+     +#+         +#+     +#+     
 #+# #+#           #+#   #+#           #+#   #+#      
### ###             ### ###             ### ###      

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.7 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/


private ["_damage","_percentage","_veh","_vehType","_fuelLevel"];
_veh = (vehicle player);
_vehType = getText(configFile>>"CfgVehicles">>typeOf _veh>>"DisplayName");

if (_veh isKindOf "ParachuteBase" || !alive _veh) exitWith {};
if !(_veh isKindOf "LandVehicle") exitWith { _veh vehicleChat "This pad is for Vehicle repairs only, soldier!"; };

_fuelLevel = fuel _veh;
_damage = getDammage _veh;
_veh setFuel 1;

_veh vehicleChat format ["Servicing %1... Please stand by...", _vehType];
_magazines = getArray(configFile >> "CfgVehicles" >> _vehType >> "magazines");

if (count _magazines > 0) then {
	_removed = [];
	{
		if (!(_x in _removed)) then {
			_veh removeMagazines _x;
			_removed = _removed + [_x];
		};
	} forEach _magazines;
	{
		_veh vehicleChat format ["Reloading %1", _x];
		sleep 0.1;
		_veh addMagazine _x;
	} forEach _magazines;
};


_veh vehicleChat format ["Refuelling %1. Stand by...", _vehType];

while {_fuelLevel < 1} do
{
	sleep 0.30;
	_percentage = (_fuelLevel * 100);
	_veh vehicleChat format["Refuelling (%1%)...", floor _percentage];
	if ((_fuelLevel + 0.01) >= 1) then
	{
		_veh setFuel 1;
		_fuelLevel = 1;
	} else {
		_fuelLevel = _fuelLevel + 0.01;
	};
};

_veh vehicleChat "Refuelled (100%).";

sleep 1;

_veh vehicleChat format ["%1 successfully refuelled. Ready to go!", _vehType];