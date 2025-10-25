local Vector = require("src.vector")
local wm = require("src.world_manager")

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
		angle = direction:angle() - math.pi / 2, -- image from bottom to top so subtract 1/4 of a circle
		mv = direction:scale(Bullet.speed + speed_variation),
		body = wm:addBody(start, Bullet.r, "bullet", {}),
	}
	setmetatable(obj, Bullet)
	return obj
end

function Bullet:move(dt)
	self.pos = self.pos:add(self.mv:scale(dt))
	self.body:update(self.pos)
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
	end
end

function Bullet:checkCollision()
	for _, collision in ipairs(self.body.events) do
		if collision.type == "collision" and collision.data.with.class == "player" then
			return true
		end
	end
	return false
end

return Bullet
