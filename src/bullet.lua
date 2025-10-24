local Vector = require("src.vector")

local debug = true
local Bullet = { speed = 400, pos = Vector:new(200, 50), angle = 0, r = 5, mv = Vector:zero(), scale = 1.4 }
Bullet.__index = Bullet

function Bullet.load()
	if Bullet.image == nil then
		Bullet.image = love.graphics.newImage("assets/images/bullet.png")
		Bullet.r = math.min(Bullet.image:getWidth(), Bullet.image:getHeight()) * 0.8
		Bullet.imageOrigin =
			Vector:new(Bullet.image:getWidth() / 2, Bullet.image:getHeight() - Bullet.image:getWidth() / 2)
	end
end

function Bullet:new(start, direction)
	local speed_variation = math.random(-100, 100)
	local obj = {
		pos = start,
		angle = direction:angle(),
		mv = direction:scale(Bullet.speed + speed_variation),
	}
	setmetatable(obj, Bullet)
	return obj
end

function Bullet:move(dt)
	self.pos = self.pos:add(self.mv:scale(dt))
end

function Bullet:draw()
	if Bullet.image ~= nil then
		love.graphics.draw(
			Bullet.image,
			self.pos.x,
			self.pos.y,
			self.angle, -- angle
			-- 0, -- angle
			Bullet.scale,
			Bullet.scale,
			Bullet.imageOrigin.x,
			Bullet.imageOrigin.y
		)
		-- debug
		if debug then
			local tmp = self.pos:add(self.mv:normalize():scale(50))
			love.graphics.setColor(1, 0, 0)
			love.graphics.setLineWidth(2)
			love.graphics.line(self.pos.x, self.pos.y, tmp.x, tmp.y)
			love.graphics.circle("line", self.pos.x, self.pos.y, Bullet.r)
			love.graphics.setColor(1, 1, 1)
		end
	end
end

function Bullet:checkCollision(player)
	-- radius collision detection
	local distance = math.sqrt((self.pos.x - player.pos.x) ^ 2 + (self.pos.y - player.pos.y) ^ 2)
	if distance < Bullet.r + player.r then
		return true
	end
	return false
end

return Bullet
