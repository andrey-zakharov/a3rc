if (isDedicated) exitWith {};
sleep 1;
private ["_unit"];
_unit = _this select 1;
_unit unassignItem "ACRE_PRC343";
_unit addItem "ACRE_PRC119";