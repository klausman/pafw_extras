// Automatically spawn & despawn parked vehicles in an area the players
// are in.

// Usage:
// - Place a marker around which you want vehicles to be spawned
// - In the marker's init function, use:
//   [this, radius, count] execVM "cos/cosCore.sqf";
//   Where the radius is in meters, and count is the number of vehicles to spawn.

if (!isServer) exitWith {};
private ["_COSmotPool","_mkrpos","_direction","_rdCount","_tempVeh", "_mkr", "_radius","_VehCount", "_roadPosArray", "_showRoads", "_txt", "_debugMkr", "_ParkedArray", "_vehList", "_countVehPool", "_v", "_tempPos", "_roadConnectedTo", "_connectedRoad", "_veh", "_displacement", "_pytho", "_Vangle", "_debugCOS"];
       
// This defines the list of vehicles that can be spawned
_COSmotPool =["B_G_Quadbike_01_F","RHS_Ural_Open_Civ_02","RHS_Civ_Truck_02_transport_F","B_G_Offroad_01_F","B_G_Offroad_01_F","B_G_Offroad_01_F","RHS_Ural_Civ_03","RHS_Ural_Civ_01","LandRover_TK_CIV_EP1","LandRover_TK_CIV_EP1","LandRover_TK_CIV_EP1","RHS_Ural_Open_Civ_03","RHS_Ural_Civ_02"];


_mkr= (_this select 0);
_mkrpos = getpos _mkr;
_radius = _this select 1;
_VehCount = _this select 2;

_roadPosArray= _mkrpos nearRoads _radius;
if (count _roadPosArray < 1) exitWith {};

//debug
_debugCOS = false;
_showRoads = false;               

if (_showRoads) then {
    {
        _txt=format["roadMkr%1",_x];
        _debugMkr = createMarker [_txt,getpos _x];
        _debugMkr setMarkerShape "ICON";
        _debugMkr setMarkerType "hd_dot";
    } foreach _roadPosArray;
};
    

_ParkedArray=[];

_roadPosArray = _roadPosArray call BIS_fnc_arrayShuffle;  
_vehList = _COSmotPool call BIS_fnc_arrayShuffle;
_countVehPool = count _vehList;
_v=0;
_rdCount=0;
_direction= 0;

// SPAWN PARKED VEHICLES
for "_i" from 1 to _VehCount do {

    if (_i >= _countVehPool) then {
        if (_v >= _countVehPool) then {
            _v = 0;
        };
        _tempVeh=_vehList select _v;
        _v=_v+1;
    };
    if (_i < _countVehPool) then {
        _tempVeh=_vehList select _i;
    };

    _tempPos=_roadPosArray select _rdCount;
    _rdCount=_rdCount+1;
    _roadConnectedTo = roadsConnectedTo _tempPos;
    if (count _roadConnectedTo > 0) then {
        _connectedRoad = _roadConnectedTo select 0;
        _direction = [_tempPos, _connectedRoad] call BIS_fnc_DirTo;
        if (random(1)>0.4) then {
            _direction = _direction + 180
        } else {
            _direction = 0;
        };
    };
        
    _veh = createVehicle [_tempVeh, _tempPos, [], 0, "NONE"];
    _veh setdir _direction;
    //_veh setvariable ["cleanthis", false, true];
    _displacement = [3.5,0,0];
    _pytho = sqrt (((_displacement select 0)*(_displacement select 0))+((_displacement select 1)*(_displacement select 1)));
    _Vangle = _direction + ((_displacement select 0) atan2 (_displacement select 1));
    _veh setPosatl ((getpos _veh) vectorAdd [(sin _Vangle) * _pytho,(cos _Vangle) * _pytho,0]);
    
    _ParkedArray set [count _ParkedArray,_veh];
    //null =[_veh] execVM "cos\addScript_Vehicle.sqf";

    IF (_debugCOS) then {
        _txt=format["Park%1,mkr%2",_i,_mkr];
        _debugMkr=createMarker [_txt,getpos _veh];
        _debugMkr setMarkerShape "ICON";
        _debugMkr setMarkerType "hd_dot";
        _debugMkr setMarkerText "Park Spawn";
    };
};

        
// vim: sts=-1 ts=4 et sw=4
