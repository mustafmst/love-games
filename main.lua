local Game = require("src.game")

local game_state = Game:new()

function love.load()
	-- Load resources here
	game_state:load()
end

function love.update(dt)
	-- Game loop logic here
	game_state:update(dt)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "r" then
		-- Restart the game
		game_state:reset()
	end
end

function love.draw()
	game_state:draw()
end
