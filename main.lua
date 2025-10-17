vector = require("src.vector")

local player = { pos = vector.new(200, 200), r = 20, speed = 0, direction = vector.new(0, 0) }
player.normalize = function(self)
	self.direction = vector.normalize(self.direction)
	if self.speed > 200 then
		self.speed = 200
	end
end

player.slowdown = function(self, factor, dt)
	self.speed = self.speed - (factor * dt)
end

function love.load()
	love.graphics.setBackgroundColor(0.1, 0.1, 0.12)
end

local function handleInputAndMove(player, dt)
	if player.speed <= 0 then
		player.speed = 0
		player.direction = vector.new(0, 0)
	end
	-- Check input for movement
	local input = vector.new(0, 0)
	if love.keyboard.isDown("w", "up") then
		input.y = input.y - 1
	end
	if love.keyboard.isDown("s", "down") then
		input.y = input.y + 1
	end
	if love.keyboard.isDown("a", "left") then
		input.x = input.x - 1
	end
	if love.keyboard.isDown("d", "right") then
		input.x = input.x + 1
	end

	if vector.length(input) > 0 then
		player.speed = 200
	end

	-- scale direction change
	input = vector.scale(input, 0.2)

	-- Normalize direction vector
	player.direction = vector.add(player.direction, input)
	player:normalize()
	player:slowdown(20, dt)
	-- player.direction = vector.normalize(vertor.subtract(player.direction, vector.scale(player.direction, 0.1)))
	-- Update position based on speed and direction
	player.pos.x = player.pos.x + player.direction.x * player.speed * dt
	player.pos.y = player.pos.y + player.direction.y * player.speed * dt
end

function love.update(dt)
	handleInputAndMove(player, dt)
end

function love.draw()
	love.graphics.setColor(0.2, 0.8, 0.9)
	love.graphics.circle("fill", player.pos.x, player.pos.y, player.r)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Arrows/WASD to move. Esc to quit.", 10, 10)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
