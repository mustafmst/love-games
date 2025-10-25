local Vector = require("src.vector")

local M = {
	world = nil,
}

local Body = { pos = Vector:zero(), class = nil, filter = {}, events = {} }
Body.__index = Body

function Body:newCircle(pos, r, class, filter)
	local obj = {
		pos = pos or Body.pos,
		r = r or 10,
		class = class or "default",
		filter = filter or {},
		events = {},
	}
	setmetatable(obj, Body)
	return obj
end

function Body:update(new_pos)
	self.pos = new_pos
end

function Body:createEvent(event_type, data)
	local event = {
		type = event_type,
		data = data or {},
	}
	local with_class = ""
	if event.data.with ~= nil and event.data.with.class ~= nil then
		with_class = event.data.with.class
	end
	for _, filter_class in ipairs(self.filter) do
		if filter_class == with_class then
			return -- filtered out
		end
	end
	table.insert(self.events, event)
end

function Body:clearEvents()
	self.events = {}
end

-- gives option to init a world with different properties
function M:init()
	self.world = {}
end

function M:clear()
	self.world = nil
end

function M:reset_world()
	M:clear()
	M:init()
end
function M:get_world()
	if self.world == nil then
		self:init() -- default world
	end
	return self.world
end

function M:is_initialized()
	return self.world ~= nil
end

function M:add_body(start_pos, r, class, filter)
	if self.world == nil then
		error("WorldManager not initialized. Call WorldManager:init() before adding bodies.")
	end
	local body = Body:newCircle(start_pos, r, class, filter)
	table.insert(self.world, body)
	return body
end

function M:remove_body(body)
	for i, b in ipairs(self.world) do
		if b == body then
			table.remove(self.world, i)
			return
		end
	end
end

function M:clear_events()
	for _, body in ipairs(self.world) do
		body:clearEvents()
	end
end

function M:detectCollisions()
	self:clear_events()
	for i = 1, #self.world do
		local bodyA = self.world[i]
		for j = i + 1, #self.world do
			local bodyB = self.world[j]
			-- Simple circle-circle collision detection
			local dist = bodyA.pos:distance_to(bodyB.pos)
			if dist < (bodyA.r + bodyB.r) then
				-- Collision detected
				bodyA:createEvent("collision", { with = bodyB })
				bodyB:createEvent("collision", { with = bodyA })
			end
		end
	end
end

function M:debug_draw()
	if self.world == nil then
		return
	end
	love.graphics.setColor(1, 0, 0, 0.5)
	for _, body in ipairs(self.world) do
		love.graphics.setLineWidth(2)
		love.graphics.circle("line", body.pos.x, body.pos.y, body.r)
	end
	love.graphics.setColor(1, 1, 1)
end

return M
