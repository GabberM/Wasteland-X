_radiusC = 200;
_gunStoresC = ["gs1", "gs2", "gs3", "gs4"];
{
	_unitC = missionNamespace getVariable (_gunStoresC select _forEachIndex);
	if(player distance _unitC <= _radiusC) then {
		_bullet = _this select 6;
		deleteVehicle _bullet;
		hint "You cannot shoot inside gun/general store safe zones.";
	};
} forEach _gunStoresC;