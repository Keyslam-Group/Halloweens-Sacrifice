love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

local W = require("src.worlds")

local currentWorld = W.game

function love.draw()
	currentWorld:emit("draw")
end