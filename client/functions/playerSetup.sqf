_player = _this;
//Player initialization
_player setskill 0;
{_player disableAI _x} foreach ["move","anim","target","autotarget"];
_player setVariable ["BIS_noCoreConversations", true];

enableSentences false;
_player removeWeapon "ItemRadio";
_player removeWeapon "ItemGPS";
removeAllWeapons _player;
removeBackpack _player;

_player addMagazine "17Rnd_9x19_glock17";
_player addWeapon "glock17_EP1";
_player selectWeapon "glock17_EP1";

_player addrating 1000000;
_player switchMove "amovpknlmstpsraswpstdnon_gear";

thirstLevel = 100;
hungerLevel = 100;

_player setVariable["cmoney",100,false];
_player setVariable["canfood",2,false];
_player setVariable["medkits",0,false];
_player setVariable["water",2,false];
_player setVariable["fuel",0,false];
_player setVariable["repairkits",0,false];
_player setVariable["fuelFull", 0, false];
_player setVariable["fuelEmpty", 1, false];
_player setVariable["bombs",false,false];
_player setVariable["spawnBeacon",0,false];
_player setVariable["camonet",0,false];

// Custom items
_player setVariable["2uaig",0,true];
_player setVariable["gSpawnBeacon",0,true];

[] execVM "client\functions\playerActions.sqf";

_player groupChat format["Player Initialization Complete"];
playerSetupComplete = true;