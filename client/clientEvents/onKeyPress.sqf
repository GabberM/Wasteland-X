
//	@file Version: 1.1
//	@file Name: onKeyPress.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [WX] Xstasy
//	@file Created: 20/11/2012 05:19
//	@file Args:


private["_handled", "_faceCP", "_faceVP"];

_key     = _this select 1;
_shift   = _this select 2;
_handled = false;

if(isstunned) exitwith

	{

	if(_key == 50)then{_handled = true};
	if(_key == 11)then{_handled = true};

	_handled

	};

switch _key do
{      
    // U key
    case 22:
    {
		execVM "client\systems\adminPanel\checkAdmin.sqf";
    };
	
	// INS key
	case 210:
	{
		execVM "client\systems\adminPanel\checkAdminVehicle.sqf";
	};
    
	// DEL key
	case 211:
	{
		execVM "client\systems\adminPanel\checkAdminDeleteVehicle.sqf";
	};
	
    // Tilde
    case 41:
    {
        [] call loadPlayerMenu;
    };
	
	// T key
	case 20:
	{
		execVM "client\systems\adminPanel\checkAdminTeleport.sqf";
	};
	
	// Y key
	case 21:
	{
		execVM "client\systems\adminPanel\checkAdminSattelite.sqf";
	};
    
    // E key
	case 18:
    {
    	if (dialog) exitwith { closeDialog 0; }; // Check a current dialog is not already active.
        if(vehicle player != player) exitwith{};  // Check the player is not a car.
        
        private ["_storeInteractionBuffer","_storeInteractionZone","_currPos","_store","_relativeDir","_absoluteDir"];
        
        _storeInteractionBuffer = 10; // The acceptable +/- look direction for interacting with stores. Higher = wider look angle.
        _storeInteractionZone = 3; // The furthest away the player can be from a store to interact with it. Higher = further.
        _currPos = getPosATL player;
        
        _gunStore = nearestObjects [_currPos, ["CIV_Contractor1_BAF"], _storeInteractionZone];    
        _genStore = nearestObjects [_currPos, ["TK_CIV_Takistani04_EP1"], _storeInteractionZone];   
        
        if (!isNull (_gunStore select 0)) then {
        	_relativeDir = [player, _gunStore select 0] call BIS_fnc_relativeDirTo;
       		_absoluteDir = abs _relativeDir;
            
            if (_absoluteDir < _storeInteractionBuffer OR _absoluteDir > (360 - _storeInteractionBuffer)) then {
				//Great success! Player is actually looking at the store keeper and is close by.
            	[] spawn loadGunStore;
        	};   
        };
        
        if (!isNull (_genStore select 0)) then {
        	_relativeDir = [player, _genStore select 0] call BIS_fnc_relativeDirTo;
       		_absoluteDir = abs _relativeDir;
            
            if (_absoluteDir < _storeInteractionBuffer OR _absoluteDir > (360 - _storeInteractionBuffer)) then {
				//Great success! Player is actually looking at the store keeper and is close by.
            	[] spawn loadGeneralStore;
        	};   
        };  
        
    };
};

_handled;



