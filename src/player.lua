local size, half_size = 22, 11
local Player = { x = 400, speed = 500 }
Player.__index = Player

function Player:new(start_pos)
	local obj = { x = start_pos or 0 }
	setmetatable(obj, Player)
	return obj
end

function Player:load()
	self.image = love.graphics.newImage("assets/images/player.jpg")
end

function Player:move(direction, dt, ww)
	if direction > 0 then
		self.x = self.x - self.speed * dt
		if self.x < half_size then
			self.x = half_size
		end
	elseif direction < 0 then
		self.x = self.x + self.speed * dt
		if self.x > ww - half_size then
			self.x = ww - half_size
		end
	end
end

function Player:reset()
	self.x = Player.x
	self.speed = Player.speed
end

function Player:draw(wh)
	if self.image ~= nil then
		love.graphics.draw(self.image, self.x - half_size, wh - size - half_size, 0, 1, 1, 0, 0)
	end
end

return Player
