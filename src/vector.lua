local Vector = { x = 0, y = 0 }
Vector.__index = Vector

function Vector:new(x, y)
	local obj = { x = x or 0, y = y or 0 }
	setmetatable(obj, Vector)
	return obj
end

function Vector:zero()
	return Vector:new(0, 0)
end

function Vector:add(v)
	return Vector:new(self.x + v.x, self.y + v.y)
end

function Vector:scale(s)
	return Vector:new(self.x * s, self.y * s)
end

function Vector:length()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:normalize()
	local len = self:length()
	if len == 0 then
		return Vector:new(0, 0)
	end
	return Vector:new(self.x / len, self.y / len)
end

return Vector
