local player = require("src.player"):new(0)
local ww, wh = love.graphics.getDimensions()
local title = love.graphics.newText(love.graphics.newFont(32), "Dodge The Bullets!")

function love.load()
	-- Load resources here
	player:load()
	player:reset()
end

function love.update(dt)
	-- Game loop logic here
	local direction = 0
	if love.keyboard.isDown("right", "d") then
		direction = direction - 1
		print("Right key is pressed")
	end

	if love.keyboard.isDown("left", "a") then
		direction = direction + 1
		print("Left key is pressed")
	end

	player:move(direction, dt)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.draw()
	love.graphics.clear(0.1, 0.1, 0.1)
	-- love.graphics.print("Hello, World! dim: " .. ww .. " x " .. wh, 400, 300)
	love.graphics.draw(title, ww / 2 - title:getWidth() / 2, 10)
	player:draw(wh)
end
