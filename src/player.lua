local Vector = require("src.vector")
local ww, wh = love.graphics.getDimensions()

local half_size = 11
local Player = { pos = Vector:zero(), speed = 500, r = 12, start = Vector:zero() }
Player.__index = Player

function Player:new(start)
	local obj = { pos = start or Player.pos, speed = Player.speed, start = start or Player.start }
	setmetatable(obj, Player)
	return obj
end

function Player:load()
	self.image = love.graphics.newImage("assets/images/player.png")
end

function Player:move(direction, dt)
	self.pos = self.pos:add(direction:scale(self.speed * dt))
	if self.pos.x < half_size then
		self.pos.x = half_size
	end
	if self.pos.x > ww - half_size then
		self.pos.x = ww - half_size
	end
	if self.pos.y < half_size then
		self.pos.y = half_size
	end
	if self.pos.y > wh - half_size then
		self.pos.y = wh - half_size
	end
end

function Player:reset()
	self.pos = Vector:new(self.start.x, self.start.y)
	self.speed = Player.speed
end

function Player:draw()
	if self.image ~= nil then
		love.graphics.draw(self.image, self.pos.x - half_size, self.pos.y - half_size, 0, 1, 1, 0, 0)
	end
end

return Player
