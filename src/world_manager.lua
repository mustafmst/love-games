local Vector = require("src.vector")

local WorldManager = {
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

--- Initializes the world with default properties.
-- This function sets up an empty world table.
function WorldManager:init()
	self.world = {}
end

function WorldManager:clear()
	self.world = nil
end

function WorldManager:resetWorld()
	WorldManager:clear()
	WorldManager:init()
end
function WorldManager:getWorld()
	if self.world == nil then
		self:init() -- default world
	end
	return self.world
end

function WorldManager:isInitialized()
	return self.world ~= nil
end

function WorldManager:addBody(start_pos, r, class, filter)
	if self.world == nil then
		error("WorldManager not initialized. Call WorldManager:init() before adding bodies.")
	end
	local body = Body:newCircle(start_pos, r, class, filter)
	table.insert(self.world, body)
	return body
end

function WorldManager:removeBody(body)
	for i, b in ipairs(self.world) do
		if b == body then
			table.remove(self.world, i)
			return
		end
	end
end

function WorldManager:clearEvents()
	for _, body in ipairs(self.world) do
		body:clearEvents()
	end
end

--- Detects collisions between all bodies in the world.
-- This function clears existing events and checks for collisions
-- between all pairs of bodies using circle-circle collision detection.
function WorldManager:detectCollisions()
	self:clearEvents()
	for i, bodyA in ipairs(self.world) do
		for j = i + 1, #self.world do
			self:checkCollision(bodyA, self.world[j])
		end
	end
end

--- Checks for a collision between two bodies and creates events if a collision is detected.
-- @param bodyA The first body.
-- @param bodyB The second body.
function WorldManager:checkCollision(bodyA, bodyB)
	-- Simple circle-circle collision detection
	local dist = bodyA.pos:distance_to(bodyB.pos)
	if dist < (bodyA.r + bodyB.r) then
		-- Collision detected
		bodyA:createEvent("collision", { with = bodyB })
		bodyB:createEvent("collision", { with = bodyA })
	end
end

function WorldManager:debugDraw()
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

return WorldManager
