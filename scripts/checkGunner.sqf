if (PARAMS_RESTRICTED == 0 )  exitWith {};
if (isDedicated) exitWith {};

private ["_vehType","_crewType","_crewTypeName","_veh","_seats"];

while {(true)} do {
  _vehType = _this select 0;
  _crewType = _this select 1;
  _crewTypeName = getText(configFile >> "CfgVehicles" >> _crewType >> "displayName");
  if (typeOf player != _crewType) then {
    waitUntil {vehicle player != player};
    _veh = vehicle player;
    if (_veh isKindof _vehType && !(_veh isKindOf "ParachuteBase")) then {
      _seats = [gunner _veh];
      if (_veh isKindOf "Tank") then {_seats = _seats + [_veh turretUnit [0]]; };
      if (_veh isKindOf "Heli_Transport_01_base_F") then {_seats = _seats + [_veh turretUnit [2]];};
        if (player in _seats) then {
        player action ["GetOut",_veh];
        waitUntil {vehicle player == player};
        hint format ["ОГРАНИЧЕНИЕ\n\nТребуется класс: %1",_crewTypeName];
      };
    };
  };
};