local debug = true

local Vector = require("src.vector")
local ww, wh = love.graphics.getDimensions()

local Player =
	{ pos = Vector:zero(), speed = 100, r = 12, start = Vector:zero(), velocity = Vector:zero(), friction = 0.91 }
Player.__index = Player

function Player:new(start)
	local obj = {
		pos = start or Player.pos,
		speed = Player.speed,
		start = start or Player.start,
		velocity = Player.velocity,
		friction = Player.friction,
	}
	setmetatable(obj, Player)
	return obj
end

function Player:load()
	self.image = love.graphics.newImage("assets/images/player.png")
	self.imageOffset = Vector:new(self.image:getWidth() / 2, self.image:getHeight() / 2 + self.image:getHeight() * 0.1)
	self.r = math.min(self.imageOffset.x, self.imageOffset.y) * 0.7
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
end

function Player:reset()
	self.pos = Vector:new(self.start.x, self.start.y)
	self.speed = Player.speed
end

function Player:draw()
	if self.image ~= nil then
		love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 1, 1, self.imageOffset.x, self.imageOffset.y)

		-- debug
		if debug then
			love.graphics.setColor(1, 0, 0)
			love.graphics.circle("line", self.pos.x, self.pos.y, self.r)
			love.graphics.setColor(1, 1, 1)
		end
	end
end

return Player
