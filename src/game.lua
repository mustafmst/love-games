local Vector = require("src.vector")
local Bullet = require("src.bullet")
local Player = require("src.player")
local Spawner = require("src.spawner")

local Game = {}
Game.__index = Game

function Game:new()
	local instance = setmetatable({}, Game)
	instance.ww, instance.wh = love.graphics.getDimensions()
	instance.player = Player:new(Vector:new(instance.ww / 2, instance.wh - 50))
	instance.title = love.graphics.newText(love.graphics.newFont(32), "Dodge Ball(s)!")
	instance.points = 0
	instance.ellapsed_time = 0
	instance.next_bullet_time = 0
	instance.bullets = {}
	instance.game_running = true
	return instance
end

function Game:load()
	self.player:load()
	self.player:reset()
	Bullet.load()
end

function Game:reset()
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

	if self.next_bullet_time <= 0 then
		local x_pos = math.random(-20, self.ww + 20)
		local b_pos = Vector:new(x_pos, 0)
		local b = Bullet:new(b_pos, b_pos:direction_to(Vector:new(math.random(-20, self.ww + 20), self.wh)))
		self.bullets[#self.bullets + 1] = b
		self.next_bullet_time = math.max(0.05, 1.0 - self.ellapsed_time / 30)
	end

	for i, b in ipairs(self.bullets) do
		b:move(dt)
		if b.pos.y > self.wh + 50 then
			table.remove(self.bullets, i)
			self.points = self.points + 5
		elseif b:checkCollision(self.player) then
			self.game_running = false
		end
	end

	self.player:move(direction:normalize(), dt, self.ww)
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
	love.graphics.draw(self.title, self.ww / 2 - self.title:getWidth() / 2, 10)
	local points_text = love.graphics.newText(love.graphics.newFont(24), "Points: " .. math.floor(self.points))
	love.graphics.draw(points_text, self.ww - points_text:getWidth() - 10, 10)
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
