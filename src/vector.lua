local M = {}

M.new = function(x, y)
	return { x = x or 0, y = y or 0 }
end

M.normalize = function(v)
	local len = math.sqrt(v.x * v.x + v.y * v.y)
	if len > 0 then
		return { x = v.x / len, y = v.y / len }
	else
		return { x = 0, y = 0 }
	end
end

M.scale = function(vec, s)
	return { x = vec.x * s, y = vec.y * s }
end

M.add = function(v1, v2)
	return { x = v1.x + v2.x, y = v1.y + v2.y }
end

M.length = function(v)
	return math.sqrt(v.x * v.x + v.y * v.y)
end

M.subtract = function(v1, v2)
	return { x = v1.x - v2.x, y = v1.y - v2.y }
end

return M
