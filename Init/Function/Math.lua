---@param x real
---@param y real
---@return boolean
function InMapXY(x, y)
	return x > GetRectMinX(bj_mapInitialPlayableArea) and x < GetRectMaxX(bj_mapInitialPlayableArea) and y > GetRectMinY(bj_mapInitialPlayableArea) and y < GetRectMaxY(bj_mapInitialPlayableArea)
end

---@param x real
---@param distance real
---@param angle real degrees
---@return real
function GetPolarOffsetX(x, distance, angle)
	return x + distance * Cos(angle * bj_DEGTORAD)
end

---@param y real
---@param distance real
---@param angle real degrees
---@return real
function GetPolarOffsetY(y, distance, angle)
	return y + distance * Sin(angle * bj_DEGTORAD)
end

local GetTerrainZ_location = Location(0, 0)
---@param x real
---@param y real
---@return real
function GetTerrainZ(x, y)
	MoveLocation(GetTerrainZ_location, x, y)
	return GetLocationZ(GetTerrainZ_location)
end

---@param target unit
---@return real
function GetUnitZ(target)
	MoveLocation(GetTerrainZ_location, GetUnitX(target), GetUnitY(target))
	return GetLocationZ(GetTerrainZ_location) + GetUnitFlyHeight(target)
end

---@param target unit
---@param z real
function SetUnitZ(target, z)
	MoveLocation(GetTerrainZ_location, GetUnitX(target), GetUnitY(target))
	SetUnitFlyHeight(target, z - GetLocationZ(GetTerrainZ_location), 0);
end

---@param h real максимальная высота в прыжке на середине расстояния (x = d / 2)
---@param d real общее расстояние до цели
---@param x real расстояние от исходной цели до точки, где следует взять высоту по параболе
---@return real
function ParabolaZ (h, d, x)
	return (4 * h / d) * (d - x) * (x / d)
end

---@param zs real начальная высота высота одного края дуги
---@param ze real конечная высота высота другого края дуги
---@param h real максимальная высота на середине расстояния (x = d / 2)
---@param d real общее расстояние до цели
---@param x real расстояние от исходной цели до точки
---@return real
function ParabolaZ2(zs, ze, h, d, x)
	return (2 * (zs + ze - 2 * h) * (x / d - 1) + (ze - zs)) * (x / d) + zs
end

---@param xa real
---@param ya real
---@param xb real
---@param yb real
---@return real
function DistanceBetweenXY(xa, ya, xb, yb)
	local dx = xb - xa
	local dy = yb - ya
	return math.sqrt(dx * dx + dy * dy)
end

--[[
function SetUnitPositionPolar(unit target, real distance, real angle){
SetUnitX(target, GetPolarOffsetX(GetUnitX(target), distance, angle));
SetUnitY(target, GetPolarOffsetY(GetUnitY(target), distance, angle));
}

function AngleBetweenXY(real x1, real y1, real x2, real y2) -> real {
return bj_RADTODEG * Atan2(y2 - y1, x2 - x1);
}
function AngleBetweenWidgets(widget target1, widget target2) -> real {
return AngleBetweenCoords(GetWidgetX(target1), GetWidgetY(target1), GetWidgetX(target2), GetWidgetY(target2));
}

function DistanceBetweenCoords3D(real x1, real y1, real z1, real x2, real y2, real z2) -> real {
real dx = x2 - x1;
real dy = y2 - y1;
real dz = z2 - z1;
return SquareRoot(dx*dx + dy*dy + dz*dz);
}

function DistanceBetweenWidgets(widget target1, widget target2) -> real {
return DistanceBetweenCoords(GetWidgetX(target1), GetWidgetY(target1), GetWidgetX(target2), GetWidgetY(target2));
}

function GetTerrainZ(real x, real y) -> real {
MoveLocation(locationZ, x, y);
return GetLocationZ(locationZ);
}
function GetUnitZ(unit target) -> real {
return GetTerrainZ(GetUnitX(target), GetUnitY(target)) + GetUnitFlyHeight(target);
}

function UnitAddAbilityZ(unit target){
if (GetUnitAbilityLevel(target, AbilityUnitZ) == 0){ UnitAddAbility(target, AbilityUnitZ); }
}
function UnitRemoveAbilityZ(unit target){
if (GetUnitAbilityLevel(target, AbilityUnitZ) > 0){ UnitRemoveAbility(target, AbilityUnitZ); }
}

function SetUnitXY(unit target, real x, real y) -> unit {
SetUnitX(target, x);
SetUnitY(target, y);
return target;
}
function SetUnitXYZ(unit target, real x, real y, real z) -> unit {
SetUnitXY(target, x, y);
SetUnitZ(target, z);
return target;
}
function SetUnitXYZF(unit target, real x, real y, real z, real f) -> unit {
SetUnitXY(target, x, y);
SetUnitZ(target, z);
SetUnitFacing(target, f);
return target;
}



// https://xgm.guru/p/wc3/perpendicular
// Находит длину перпендикуляра от отрезка, заданного Xa, Ya, Xb, Yb к точке, заданной Xc, Yc.
function Perpendicular (real Xa, real Ya, real Xb, real Yb, real Xc, real Yc) -> real {
return SquareRoot((Xa - Xc) * (Xa - Xc) + (Ya - Yc) * (Ya - Yc)) * Sin(Atan2(Yc-Ya,Xc-Xa) - Atan2(Yb-Ya,Xb-Xa));
}


// https://xgm.guru/p/wc3/warden-math
// Расстояние между двумя углами
function AngleDifference(real a1, real a2) -> real {
real x;
a1 = ModuloReal(a1, 360);
a2 = ModuloReal(a2, 360);
if (a1 > a2) {
x = a1;
a1 = a2;
a2 = x;
}
x = a2 - 360;
if (a2 - a1 > a1 - x){
a2 = x;
}
return RAbsBJ(a1 - a2);
}

/*


// Приводит угол в божеский вид
function AngleNormalize(real angle) -> real {
if (angle > 360){ angle = angle - 360; }
if (angle < 0){ angle = 360 + angle; }
return angle;
}

}
}
]]