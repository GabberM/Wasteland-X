_layer = 85125; 
_block = false; 
 
_restrictedWeapons = ["BAF_L85A2_RIS_CWS","m107_TWS_EP1","M110_TWS_EP1","AKS_74_GOSHAWK","BAF_AS50_TWS","M249_TWS_EP1","M249_TWS_EP1","m8_tws_sd","m8_tws","PMC_AS50_TWS","SCAR_H_STD_TWS_SD","SCAR_L_STD_EGLM_TWS"]; 

while {true} do 
{ 
       if   ({player hasWeapon _x} count _restrictedWeapons > 0) then 
    { 
        if (!_block) then 
        { 
            _layer cutText ["Thermal Weapons are not allowed, it was removed from your inventory.", "PLAIN"]; 
			player removeWeapon _x;
            _block = true; 
        }; 
    } 
    else 
    { 
        if (_block) then 
        { 
            _layer cutText ["", "PLAIN"]; 
            _block = false; 
        }; 
    }; 
    sleep 3; 
};  

_layer = 85125; 
_block = false; 