local Vector = require("src.vector")
local Bullet = require("src.bullet")
local Player = require("src.player")
local wm = require("src.world_manager")
-- local Spawner = require("src.spawner")

local Game = {}
Game.__index = Game

function Game:new()
	-- init collision world
	wm:init()
	local instance = setmetatable({}, Game)
	instance.ww, instance.wh = love.graphics.getDimensions()
	instance.player = Player:new(Vector:new(instance.ww / 2, instance.wh - 50))
	instance.title = love.graphics.newText(love.graphics.newFont(32), "Spaceship One")
	instance.points = 0
	instance.ellapsed_time = 0
	instance.next_bullet_time = 0
	instance.bullets = {}
	instance.game_running = true
	return instance
end

function Game:load()
	-- load assets
	wm:resetWorld()
	self.player:load()
	self.player:reset()
	Bullet.load()
end

function Game:reset()
	-- reset all thisng for new game
	wm:resetWorld()
	self.points = 0
	self.ellapsed_time = 0
	self.next_bullet_time = 0
	self.bullets = {}
	self.game_running = true
	self.player:reset()
end

function Game:update(dt)
	if not self.game_running then
		return
	end
	local direction = Vector:zero()
	if love.keyboard.isDown("right", "d") then
		direction.x = direction.x + 1
	end

	if love.keyboard.isDown("left", "a") then
		direction.x = direction.x - 1
	end

	if love.keyboard.isDown("up", "w") then
		direction.y = direction.y - 1
	end

	if love.keyboard.isDown("down", "s") then
		direction.y = direction.y + 1
	end

	-- bullet creation
	if self.next_bullet_time <= 0 then
		local x_pos = math.random(-20, self.ww + 20)
		local b_pos = Vector:new(x_pos, 0)
		local b = Bullet:new(
			b_pos, -- start pos
			b_pos:direction_to(Vector:new(math.random(-20, self.ww + 20), self.wh)) -- direction
			-- Vector:new(math.random(-20, self.ww + 20), self.wh):direction_to(b_pos) -- direction
		)
		self.bullets[#self.bullets + 1] = b
		self.next_bullet_time = math.max(0.05, 1.0 - self.ellapsed_time / 30)
	end

	-- bullets move and collition events check
	for i, b in ipairs(self.bullets) do
		b:move(dt)
		if b.pos.y > self.wh + 50 then
			wm:removeBody(b.body)
			table.remove(self.bullets, i)
			self.points = self.points + 5
		elseif b:checkCollision() then
			wm:removeBody(b.body)
			table.remove(self.bullets, i)
		end
	end

	-- stop game when HP is 0
	if self.player.hp <= 0 then
		self.game_running = false
	end

	-- player collision handling and movement
	self.player:handleCollisions()
	self.player:move(direction:normalize(), dt, self.ww)

	-- bullet generation timers update
	self.ellapsed_time = self.ellapsed_time + dt
	self.next_bullet_time = self.next_bullet_time - dt
end

function Game:draw()
	love.graphics.clear(0.1, 0.1, 0.1)
	for _, b in ipairs(self.bullets) do
		b:draw()
	end
	self.player:draw()
	self:draw_ui()
end

function Game:draw_ui()
	-- Points, Health, Title, Game Over
	love.graphics.draw(self.title, self.ww / 2 - self.title:getWidth() / 2, 10)
	local points_text = love.graphics.newText(love.graphics.newFont(24), "Points: " .. math.floor(self.points))
	love.graphics.draw(points_text, self.ww - points_text:getWidth() - 10, 10)
	local health_text = love.graphics.newText(love.graphics.newFont(24), "Health: " .. self.player.hp)
	love.graphics.draw(health_text, 10, 10)
	if not self.game_running then
		local game_over_text = love.graphics.newText(love.graphics.newFont(48), "Game Over! Press 'R' to Restart")
		love.graphics.draw(
			game_over_text,
			self.ww / 2 - game_over_text:getWidth() / 2,
			self.wh / 2 - game_over_text:getHeight() / 2
		)
	end
end

return Game
