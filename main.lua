local player = require("src.player"):new(0)
local Bullet = require("src.bullet")
local ww, wh = love.graphics.getDimensions()
local title = love.graphics.newText(love.graphics.newFont(32), "Dodge The Bullets!")
local points = 0
local next_bullet_time = 0
local bullets = {}
local game_running = true

function love.load()
	-- Load resources here
	player:load()
	player:reset()
	Bullet.load()
end

function love.update(dt)
	-- Game loop logic here
	if not game_running then
		return
	end
	local direction = 0
	if love.keyboard.isDown("right", "d") then
		direction = direction - 1
	end

	if love.keyboard.isDown("left", "a") then
		direction = direction + 1
	end

	if next_bullet_time <= 0 then
		local x_pos = math.random(20, ww - 20)
		print("Spawning bullet at x: " .. x_pos)
		local b = Bullet:new(x_pos)
		bullets[#bullets + 1] = b
		next_bullet_time = math.max(0.2, 1.0 - points / 100)
	end

	for i, b in ipairs(bullets) do
		b:move(dt)
		if b.y > wh then
			table.remove(bullets, i)
		elseif b:checkCollision(player, wh) then
			game_running = false
		end
	end

	player:move(direction, dt, ww)
	points = points + dt * 10
	next_bullet_time = next_bullet_time - dt
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "r" then
		-- Reset the game
		game_running = true
		points = 0
		bullets = {}
		player:reset()
	end
end

function love.draw()
	love.graphics.clear(0.1, 0.1, 0.1)
	-- love.graphics.print("Hello, World! dim: " .. ww .. " x " .. wh, 400, 300)
	love.graphics.draw(title, ww / 2 - title:getWidth() / 2, 10)
	local points_text = love.graphics.newText(love.graphics.newFont(24), "Points: " .. math.floor(points))
	love.graphics.draw(points_text, ww - points_text:getWidth() - 10, 10)
	for _, b in ipairs(bullets) do
		b:draw()
	end
	player:draw(wh)
	if not game_running then
		local game_over_text = love.graphics.newText(love.graphics.newFont(48), "Game Over! Press 'R' to Restart")
		love.graphics.draw(
			game_over_text,
			ww / 2 - game_over_text:getWidth() / 2,
			wh / 2 - game_over_text:getHeight() / 2
		)
	end
end
