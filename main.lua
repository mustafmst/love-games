local Bullet = require("src.bullet")
local Vector = require("src.vector")
local ww, wh = love.graphics.getDimensions()
local player = require("src.player"):new(Vector:new(ww / 2, wh - 50))
local title = love.graphics.newText(love.graphics.newFont(32), "Dodge The Bullets!")
local points = 0
local ellapsed_time = 0
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

	if next_bullet_time <= 0 then
		local x_pos = math.random(20, ww - 20)
		print("Spawning bullet at x: " .. x_pos)
		local b_pos = Vector:new(x_pos, -50)
		local b = Bullet:new(
			b_pos,
			b_pos:direction_to(player.pos:add(Vector:new(math.random(-20, 20), math.random(-20, 20))))
		)
		bullets[#bullets + 1] = b
		next_bullet_time = math.max(0.05, 1.0 - ellapsed_time / 30)
	end

	for i, b in ipairs(bullets) do
		b:move(dt)
		if b.pos.y > wh + 50 then
			table.remove(bullets, i)
			points = points + 5
		elseif b:checkCollision(player) then
			game_running = false
		end
	end

	player:move(direction:normalize(), dt, ww)
	ellapsed_time = ellapsed_time + dt
	next_bullet_time = next_bullet_time - dt
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "r" then
		-- Reset the game
		game_running = true
		ellapsed_time = 0
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
	player:draw()
	if not game_running then
		local game_over_text = love.graphics.newText(love.graphics.newFont(48), "Game Over! Press 'R' to Restart")
		love.graphics.draw(
			game_over_text,
			ww / 2 - game_over_text:getWidth() / 2,
			wh / 2 - game_over_text:getHeight() / 2
		)
	end
end
