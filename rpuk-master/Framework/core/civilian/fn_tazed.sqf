/*
	File: fn_tazed.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Starts the tazed animation and broadcasts out what it needs to.
*/
private["_unit","_shooter","_curWep","_curMags","_attach"];
_unit = [_this,0,Objnull,[Objnull]] call BIS_fnc_param;
_shooter = [_this,1,Objnull,[Objnull]] call BIS_fnc_param;
if(isNull _unit OR isNull _shooter) exitWith {player allowDamage true; life_istazed = false;};
if(player getVariable ["Revive",false]) exitWith {player allowDamage true; life_istazed = false;};
if(life_isknockedout) exitWith {player allowDamage true; life_istazed = false;};

if(_shooter isKindOf "Man" && alive player) then
{
	if((typeName life_istazed != typeName false) || {!life_istazed}) then
	{
		life_istazed = true;
		_curWep = currentWeapon player;
		_curMags = magazines player;
		_attach = if(primaryWeapon player != "") then {primaryWeaponItems _unit} else {[]};
		{player removeMagazine _x} foreach _curMags;
		player removeWeapon _curWep;
		player addWeapon _curWep;
		if(count _attach != 0 && primaryWeapon _unit != "") then
		{
			{
				_unit addPrimaryWeaponItem _x;
			} foreach _attach;
		};
		if(count _curMags != 0) then
		{
			{player addMagazine _x;} foreach _curMags;
		};
		
		[[_unit],"life_fnc_tazeSound",true,false] spawn life_fnc_MP;
		_obj = "Land_ClutterCutter_small_F" createVehicle (getPosATL _unit);
		_obj setPosATL (getPosATL _unit);
		[[player,"AinjPfalMstpSnonWnonDf_carried_fallwc"],"life_fnc_animSync",true,false] spawn life_fnc_MP;
		
		if(side _shooter == civilian) then {
			[0,format[localize "STR_NOTF_Tazed", _unit getVariable["realname",name _unit], format["%1 (BountyHunter)",_shooter getVariable["realname",name _shooter]]]] remoteExecCall ["life_fnc_broadcast",-2];
		} else {
			[0,format[localize "STR_NOTF_Tazed", _unit getVariable["realname",name _unit], _shooter getVariable["realname",name _shooter]]] remoteExecCall ["life_fnc_broadcast",-2];
		};
		
		_unit attachTo [_obj,[0,0,0]];

		_hndlBlur = ppEffectCreate ["DynamicBlur",450];
		_hndlBlur ppEffectEnable true;
		_hndlBlur ppEffectAdjust [30];
		_hndlBlur ppEffectCommit 5;

		disableUserInput true;
		sleep 13 + random 5;
		[[player,"amovppnemstpsraswrfldnon"],"life_fnc_animSync",true,false] spawn life_fnc_MP;
		if(!(player getVariable["Escorting",false])) then {
			detach player;
		};

		_hndlBlur ppEffectAdjust [0];
		_hndlBlur ppEffectCommit 3;
		ppEffectDestroy _hndlBlur;


		life_istazed = false;
		player allowDamage true;
		disableUserInput false;
	};
}
	else
{
	_unit allowDamage true;
	life_iztazed = false;
};