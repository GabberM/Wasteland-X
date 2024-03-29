//	@file Version: 1.0
//	@file Name: mission_APC.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args:

//Side Mission Colour = #4BC9B0 - Turquoise 
//Main Mission Colour = #52bf90 - Light blue
//Fail Mission Colour = #FF1717 - Light red
//Fail Mission Colour = #17FF41 - Light green
//Sub Colour = #FFF - White

if(!isServer) exitwith {};
diag_log format["WASTELAND SERVER - Mission Started"];
private ["_unitsAlive","_playerPresent","_missionType","_successTextColour","_randomIndex","_mainTextColour","_failTextColour","_subTextColour","_picture","_vehicleName","_centerPos","_missionTimeOut","_missionDelayTime","_missionTriggerRadius","_missionPlayerRadius","_flatAreas","_randomArea","_hint","_startTime","_currTime","_result","_tank", "_randomPos"];

//Mission Initialization.
_result = 0;
_missionType = "Immobile APC";
_mainTextColour = "#52bf90";
_successTextColour = "#17FF41";
_failTextColour = "#FF1717";
_subTextColour = "#FFFFFF";
_missionTimeOut = 1800;
_missionDelayTime = 1200;
_missionPlayerRadius = 50;

_GotLoc = false;
while {!_GotLoc} do 
{
	_randomIndex = random (count MissionSpawnMarkers - 1);

	//If the index of the mission markers array is false then break the loop and finish up doing the mission
	if (!((MissionSpawnMarkers select _randomIndex) select 1)) then 
	{
		_selectedMarker = MissionSpawnMarkers select _randomIndex select 0;
		_randomPos = getMarkerPos _selectedMarker;
		MissionSpawnMarkers select _randomIndex set[1, true];
		_GotLoc = true;
	};
};

//ensure the rest of the script doesn't continue until we are done
waitUntil {_GotLoc};

//Tell everyone their will be a mission soon.
_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", _missionDelayTime / 60, _mainTextColour, _subTextColour];
[nil,nil,rHINT,_hint] call RE;

//Wait till the mission is ready to be ran.
diag_log format["WASTELAND SERVER - Mission Waiting to run"];
_startTime = floor(time);
waitUntil
{ 
    _currTime = floor(time);
    if(_currTime - _startTime >= _missionDelayTime) then {_result = 1;};
    (_result == 1)
};
diag_log format["WASTELAND SERVER - Mission Resumed"];
_result = 0;

//Add marker to client marker array.
clientMissionMarkers set [count clientMissionMarkers,["APC_Marker",_randomPos,"Immobile APC"]];
publicVariable "clientMissionMarkers";

_veh = ["BTR60_TK_EP1","M1126_ICV_MK19_EP1","BRDM2_TK_GUE_EP1","M113_UN_EP1","BTR90","LAV25","M6_EP1"] call BIS_fnc_selectRandom;

_tank = createVehicle [_veh,[(_randomPos select 0), _randomPos select 1,0],[], 0, "NONE"];
_tank setFuel 0;
_tank setVehicleAmmo 1;
_tank setdamage 0.75;

_tank setVehicleLock "LOCKED";
_tank setVariable["original",1,true];
_tank setVariable ["R3F_LOG_disabled", true, true];

_picture = getText (configFile >> "cfgVehicles" >> typeOf _tank >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _tank >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A<t color='%4'> %3</t>, has been immobilized go get it for your team.</t>", _missionType, _picture, _vehicleName, _mainTextColour, _subTextColour];
[nil,nil,rHINT,_hint] call RE;

CivGrpM = createGroup civilian;
[CivGrpM,_randomPos]execVM "server\missions\createUnits\midGroup.sqf";

diag_log format["WASTELAND SERVER - Mission Waiting to be Finished"];
_startTime = floor(time);
waitUntil
{
    sleep 1; 
	_playerPresent = false;
    _currTime = floor(time);
    if(_currTime - _startTime >= _missionTimeOut) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _tank <= _missionPlayerRadius)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units CivGrpM);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _tank) == 1)
};

_tank setVehicleLock "UNLOCKED";
_tank setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
    deleteVehicle _tank;
    {deleteVehicle _x;}forEach units CivGrpM;
    deleteGroup CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time</t>", _missionType, _picture, _vehicleName, _failTextColour, _subTextColour];
	[nil,nil,rHINT,_hint] call RE;
	//Reset the mission spawn bool
    diag_log format["WASTELAND SERVER - Mission Failed"];
} else {
	//Mission Complete.
    deleteGroup CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The APC has been captured, now go destroy the enemy</t>", _missionType, _picture, _vehicleName, _successTextColour, _subTextColour];
	[nil,nil,rHINT,_hint] call RE;
	//Reset the mission spawn bool
    diag_log format["WASTELAND SERVER - Mission Finished"];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false]; 

//Remove marker from client marker array.
{
    if(_x select 0 == "APC_Marker") then
    {
    	clientMissionMarkers set [_forEachIndex, "REMOVETHISCRAP"];
		clientMissionMarkers = clientMissionMarkers - ["REMOVETHISCRAP"];
        publicVariable "clientMissionMarkers";    
    };
}forEach clientMissionMarkers;
mainMissionRunning = false;