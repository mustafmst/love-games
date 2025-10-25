local Vector = require("src.vector")
local wm = require("src.world_manager")
local ww, wh = love.graphics.getDimensions()

local Player = {
	pos = Vector:zero(),
	speed = 100,
	r = 10,
	start = Vector:zero(),
	velocity = Vector:zero(),
	friction = 0.91,
	hp = 3,
}
Player.__index = Player

function Player:new(start)
	local obj = {
		pos = start or Player.pos,
		speed = Player.speed,
		start = start or Player.start,
		velocity = Player.velocity,
		friction = Player.friction,
		body = wm:addBody(start or Player.pos, Player.r, "player", {}),
		hp = Player.hp,
	}
	setmetatable(obj, Player)
	return obj
end

function Player:load()
	Player.image = love.graphics.newImage("assets/images/player.png")
	Player.imageOffset =
		Vector:new(self.image:getWidth() / 2, self.image:getHeight() / 2 + self.image:getHeight() * 0.1)
	Player.r = math.min(self.imageOffset.x, self.imageOffset.y) * 0.7
end

function Player:handleCollisions()
	local events = self.body.events
	for _, event in ipairs(events) do
		if event.type == "collision" then
			if event.data.with.class == "bullet" then
				self.hp = self.hp - 1
			end
		end
	end
	self.body:clearEvents()
end

function Player:move(direction, dt)
	local acceleration = direction:scale(self.speed * dt)
	self.velocity = self.velocity:add(acceleration):scale(self.friction)
	self.pos = self.pos:add(self.velocity)

	if self.pos.x < self.imageOffset.x then
		self.pos.x = self.imageOffset.x
	end
	if self.pos.x > ww - self.imageOffset.x then
		self.pos.x = ww - self.imageOffset.x
	end
	if self.pos.y < self.imageOffset.y then
		self.pos.y = self.imageOffset.y
	end
	if self.pos.y > wh - self.imageOffset.y then
		self.pos.y = wh - self.imageOffset.y
	end
	self.body:update(self.pos)
end

function Player:reset()
	self.pos = Vector:new(self.start.x, self.start.y)
	self.speed = Player.speed
	self.body = wm:addBody(self.pos, Player.r, "player", {})
	self.hp = Player.hp
end

function Player:draw()
	if self.image ~= nil then
		love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 1, 1, self.imageOffset.x, self.imageOffset.y)
	end
end

return Player
