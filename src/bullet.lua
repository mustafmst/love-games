local Bullet = { speed = 400, y = 50, x = 200, angle = 0, dx = 0, dy = 0 }
Bullet.__index = Bullet

function Bullet.load()
	if Bullet.image == nil then
		Bullet.image = love.graphics.newImage("assets/images/bullet.jpg")
	end
end

function Bullet:new(x)
	local angle = math.rad(math.random(-23, 23))
	local speed_variation = math.random(-100, 100)
	local obj = {
		x = x or Bullet.x,
		y = Bullet.y,
		speed = Bullet.speed + speed_variation,
		angle = angle,
		dx = math.sin(angle),
		dy = math.cos(angle),
	}
	setmetatable(obj, Bullet)
	return obj
end

-- function Bullet.load()
-- 	self.image = love.graphics.newImage("assets/images/bullet.jpg")
-- end

function Bullet:move(dt)
	self.x = self.x - self.dx * self.speed * dt
	self.y = self.y + self.dy * self.speed * dt
end

function Bullet:draw()
	if Bullet.image ~= nil then
		love.graphics.draw(Bullet.image, self.x - 2.5, self.y - 11, self.angle, 1, 1, 0, 0)
	end
end

function Bullet:checkCollision(player, wh)
	-- Simple AABB collision detection
	local bullet_left = self.x - 2.5
	local bullet_right = self.x + 2.5
	local bullet_top = self.y - 11
	local bullet_bottom = self.y + 11

	local player_left = player.x - 11
	local player_right = player.x + 11
	local player_top = wh - 22 - 11
	local player_bottom = wh - 11

	if
		bullet_right > player_left
		and bullet_left < player_right
		and bullet_bottom > player_top
		and bullet_top < player_bottom
	then
		return true
	end
	return false
end

return Bullet
