---@param x real
---@param y real
---@return boolean
function InMapXY(x, y)
	return x > GetRectMinX(bj_mapInitialPlayableArea) and x < GetRectMaxX(bj_mapInitialPlayableArea) and y > GetRectMinY(bj_mapInitialPlayableArea) and y < GetRectMaxY(bj_mapInitialPlayableArea)
end

---@param x real
---@param distance real
---@param angle real radian
---@return real
function GetPolarOffsetX(x, distance, angle)
	return x + distance * math.cos(angle)
end

---@param y real
---@param distance real
---@param angle real radian
---@return real
function GetPolarOffsetY(y, distance, angle)
	return y + distance * math.sin(angle)
end

---@param x real
---@param distance real
---@param angle real degrees
---@return real
function MoveX(x, distance, angle)
	return x + distance * math.cos(angle * bj_DEGTORAD)
end

---@param y real
---@param distance real
---@param angle real degrees
---@return real
function MoveY(y, distance, angle)
	return y + distance * math.sin(angle * bj_DEGTORAD)
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

---@param xa real
---@param ya real
---@param xb real
---@param yb real
---@return real radian
function AngleBetweenXY(xa, ya, xb, yb)
	return math.atan(yb - ya, xb - xa)
end

---@param a real radian
---@param b real radian
---@return real radian
function AngleDiff(a, b)
	local c---@type real
	local d---@type real
	if a > b then
		c = a - b
		d = b - a + 2 * bj_PI
	else
		c = b - a
		d = a - b + 2 * bj_PI
	end
	return c > d and d or c
end

---@author xgm.guru/p/wc3/warden-math
---@param a real degrees
---@param b real degrees
---@return real degrees
function AngleDifference(a, b)
	local x---@type real
	a = math.abs(a, 360)
	b = math.abs(b, 360)
	if (a > b) then
		x = a
		a = b
		b = x
	end
	x = b - 360
	if (b - a > a - x) then
		b = x
	end
	return math.abs(a - b)
end


--[[
function DistanceBetweenCoords3D(real x1, real y1, real z1, real x2, real y2, real z2) -> real {
real dx = x2 - x1;
real dy = y2 - y1;
real dz = z2 - z1;
return SquareRoot(dx*dx + dy*dy + dz*dz);
}

function GetUnitZ(unit target) -> real {
return GetTerrainZ(GetUnitX(target), GetUnitY(target)) + GetUnitFlyHeight(target);
}


// https://xgm.guru/p/wc3/perpendicular
// Находит длину перпендикуляра от отрезка, заданного Xa, Ya, Xb, Yb к точке, заданной Xc, Yc.
function Perpendicular (real Xa, real Ya, real Xb, real Yb, real Xc, real Yc) -> real {
return SquareRoot((Xa - Xc) * (Xa - Xc) + (Ya - Yc) * (Ya - Yc)) * Sin(Atan2(Yc-Ya,Xc-Xa) - Atan2(Yb-Ya,Xb-Xa));
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