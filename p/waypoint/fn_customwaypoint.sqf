params ["_group","_markerarray","_radius","_type","_behavior","_combat","_speed","_form","_code","_timeout","_comprad"];

{
    _marker = _x;
    _markerpos = getMarkerPos _marker;
    [_group, _markerpos, _radius, _type, _behavior, _combat, _speed, _form, _code, _timeout,_comprad] call CBA_fnc_addWaypoint;
} forEach _markerarray;

// vim: sts=-1 ts=4 et sw=4
