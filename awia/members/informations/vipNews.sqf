waitUntil {sleep 0.5; alive player};
_player = Player;
_uid = getPlayerUID _player;
_nameCheck = false;

if (_uid in masterUIDArrayVIP) then {
_nameCheck = true;
};
if (_nameCheck) then {

if (isServer) then { execVM "members\informations\newsCommands.sqs"};  

} else {
};