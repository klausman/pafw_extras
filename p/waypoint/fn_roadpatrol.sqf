params ["_group","_markerarray"];

{
    _marker = _x;
    _speed = "LIMTED";
    _form = "COLUMN";
    _type = "MOVE";
    _markerpos = getMarkerPos _marker;
    _behavior = "SAFE";
    _combat = "WHITE";

    [_group, _markerpos, 0, _type, _behavior, _combat, _speed, _form, "", [0,0,0]] call CBA_fnc_addWaypoint;

} forEach _markerarray;
// vim: sts=-1 ts=4 et sw=4
