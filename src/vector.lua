Vector = {}
Vector.__index = Vector

function Vector:new(x, y)
	local vec = setmetatable({}, Vector)
	vec.x = x or 0
	vec.y = y or 0
	return vec
end

function Vector:normalize()
	local len = math.sqrt(self.x * self.x + self.y * self.y)
	if len > 0 then
		self.x = self.x / len
		self.y = self.y / len
	else
		self.x = 0
		self.y = 0
	end
end

function Vector:scale(s)
	self.x = self.x * s
	self.y = self.y * s
end

function Vector:__add(v1, v2)
	return { x = v1.x + v2.x, y = v1.y + v2.y }
end

return Vector
