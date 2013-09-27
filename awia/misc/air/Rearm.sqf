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

_ghosthawkAmmo = 0;
_ghosthawkFlares = 0;

_veh vehicleChat format ["Supply Vehicle Rearm Service.", _vehType];
sleep 1;
_veh setVehicleAmmo 1;
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

_count = count (configFile >> "CfgVehicles" >> _vehType >> "Turrets");

if (_count > 0) then {
	for "_i" from 0 to (_count - 1) do {
		scopeName "xx_reload2_xx";
		_config = (configFile >> "CfgVehicles" >> _vehType >> "Turrets") select _i;
		_magazines = getArray(_config >> "magazines");
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
			sleep 0.1;
		} forEach _magazines;
		_count_other = count (_config >> "Turrets");
		if (_count_other > 0) then {
			for "_i" from 0 to (_count_other - 1) do {
				_config2 = (_config >> "Turrets") select _i;
				_magazines = getArray(_config2 >> "magazines");
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
					sleep 0.1;
				} forEach _magazines;
			};
		};
	};
};
_veh setVehicleAmmo 1;	// Reload turrets / drivers magazine

sleep 1;

_veh vehicleChat format ["%1 successfully rearmed. Ready to go!", _vehType];