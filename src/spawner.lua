local Spawner = { next_bullet_time = 0, lowest_interval = 0.2, change_rate = 30 }
Spawner.__index = Spawner

-- if next_bullet_time <= 0 then
-- 	local x_pos = math.random(20, ww - 20)
-- 	print("Spawning bullet at x: " .. x_pos)
-- 	local b = Bullet:new(x_pos)
-- 	bullets[#bullets + 1] = b
-- 	next_bullet_time = math.max(0.05, 1.0 - ellapsed_time / 30)
-- end
--
-- for i, b in ipairs(bullets) do
-- 	b:move(dt)
-- 	if b.pos.y > wh + 50 then
-- 		table.remove(bullets, i)
-- 		points = points + 5
-- 	elseif b:checkCollision(player) then
-- 		game_running = false
-- 	end
-- end

-- player:move(direction:normalize(), dt, ww)
-- ellapsed_time = ellapsed_time + dt
-- next_bullet_time = next_bullet_time - dt

function Spawner:new(lowest_interval, change_rate)
	local obj = {
		next_bullet_time = 0,
		lowest_interval = lowest_interval or Spawner.lowest_interval,
		change_rate = change_rate or Spawner.change_rate,
	}
	setmetatable(obj, Spawner)
	return obj
end

function Spawner:update(dt, ellapsed_time)
	self.next_bullet_time = self.next_bullet_time - dt
	if self.next_bullet_time <= 0 then
		local interval = math.max(self.lowest_interval, 1.0 - ellapsed_time / self.change_rate)
		self.next_bullet_time = interval
		return true
	end
	return false
end

return Spawner
