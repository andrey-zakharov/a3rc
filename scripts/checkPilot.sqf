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
    if (_veh isKindOf _vehType && !(_veh isKindOf "ParachuteBase")) then {
      _seats = [driver _veh];
      if (_veh isKindOf "Helicopter") then {_seats = _seats + [_veh turretUnit [0]];};
        if (player in _seats) then {
          player action ["GetOut",_veh];
          waitUntil {vehicle player == player};
          hint format ["ОГРАНИЧЕНИЕ\n\nТребуется класс: %1",_crewTypeName];
          if (isEngineOn _veh) then {_veh engineOn false};
        };
    };
  };
};