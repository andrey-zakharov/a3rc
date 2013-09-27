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
if !((_veh isKindOf "Helicopter" ) or (_veh isKindOf "plane")) exitWith { _veh vehicleChat "This pad is for chopper repairs only, soldier!"; };

_damage = getDammage _veh;


_veh vehicleChat format ["Supply Vehicle Repair Service.", _vehType];
sleep 1;
_veh vehicleChat format ["Repairing %1. Stand by...", _vehType];

while {_damage > 0} do
{
	sleep 0.30;
	_percentage = 100 - (_damage * 100);
	_veh vehicleChat format ["Repairing (%1%)...", floor _percentage];
	if ((_damage - 0.01) <= 0) then
	{
		_veh setDamage 0;
		_damage = 0;
	} else {
		_veh setDamage (_damage - 0.01);
		_damage = _damage - 0.01;
	};
};

_veh vehicleChat "Repaired (100%).";

sleep 1;

_veh vehicleChat format ["%1 successfully repaired. Ready to go!", _vehType];