/*
to use:
see blackfish_selectwp.sqf
*/

_UAV = player getvariable "UAV";
_UAVname = "BLACKFISH";
{
    if (_x iskindof "RHS_C130J") then{
        _UAVname = "AC-130";
    };
} forEach attachedObjects _UAV;  

if (isnil "_UAV") exitWith {hint "Blackfish_enter.sqf error: UAV undefined";};
if (!alive _UAV) exitWith {hint format ["%1 has been destroyed!" ,_UAVname];};

if ((count (crew _UAV)) > 1) then { 


    if (!alive ((crew _UAV) select 0) || !alive ((crew _UAV) select 1)) exitWith {
        hint "UAV crew was killed!";
    };

    (_this select 0) removeaction (_this select 2);


    _UAVplayer = crew _UAV select 1;
        
    if (!(isplayer _UAVplayer)) then {
        if (alive _UAVplayer) then {
            origplayer = player; 

            if ((!(isplayer _UAVplayer))&&(alive _UAVplayer)) then {
                selectplayer _UAVplayer;
                _exitstr = format ["%1 - EXIT" ,_UAVname];
                LeaveUAVAction = _UAVplayer addaction  [_exitstr, "pa\Blackfish_leave.sqf"];
                
                {
                    if (_x iskindof "RHS_C130J") then {
                        _x setobjecttexture [0,""];
                        _x setobjecttexture [1,""];
                    };
                } forEach attachedObjects _UAV;  
                
                origplayer setUnitPos "MIDDLE";
                origplayer allowfleeing 0;
                origplayer forceSpeed 0;
                dostop origplayer;
                origplayer disableAI "TARGET";
                commandstop origplayer;
                
                origplayer allowdamage false;

                hitcounter = true;
                UAVkilledEH = _UAVplayer addEventHandler ["killed", {_this execVM "pa\Blackfish_leave.sqf"}];
                OPERATORkilledEH = origplayer addEventHandler ["killed", {[] execVM "pa\Blackfish_leave.sqf"}];
                OPERATORhitEH = origplayer addEventHandler ["HitPart", { if (hitcounter)then{[] execVM "pa\Blackfish_leave.sqf";hitcounter=false;};}];
            } else {
                hint "action canceled, target was a player or killed!";
                _gunningstr = format ["%1 - GUNNING" ,_UAVname];
                origplayer addaction  [_gunningstr, "pa\Blackfish_enter.sqf"];
            };


        };
    };

};
// vim: sts=-1 ts=4 et sw=4
