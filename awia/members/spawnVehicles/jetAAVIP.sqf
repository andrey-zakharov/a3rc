_flag = _this select 0; // Object that had the Action (also _target in the addAction command)
_player = _this select 1; // Unit that used the Action (also _this in the addAction command)
_actID = _this select 2; // ID of the Action

_player = Player;
_uid = getPlayerUID _player;
_nameCheck = false;


if (_uid in masterUIDArrayVIP) then {
_nameCheck = true;
};

if (_nameCheck) then {


_Object = "I_Plane_Fighter_03_AA_F";
_StartPos = spawn_b;
_Azimut = 160;
_Fuel = 1;
_Vehicle = _Object createVehicle position _StartPos;
_Vehicle setDir _Azimut;
_Vehicle setFuel _Fuel;
_Vehicle setpos (_Vehicle modelToWorld [0,5,2]);
player moveInDriver _Vehicle;
titleText ["You are a Member, Welcome","PLAIN DOWN"]; titleFadeOut 8;
} else {
titleText ["You are not a VIP Member, Sorry","PLAIN DOWN"]; titleFadeOut 8;
};