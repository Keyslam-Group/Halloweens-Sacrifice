love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
love.graphics.setDefaultFilter("nearest", "nearest")

require("lib.steady")

local W = require("src.worlds")

local currentWorld = W.game

function love.load()
   currentWorld:emit("load")
end

function love.update(dt)
   currentWorld:emit("update", dt)
end

function love.fixedUpdate(dt) -- luacheck: ignore
   currentWorld:emit("fixedUpdate", dt)
end

function love.draw()
   currentWorld:emit("draw")
end

function love.wheelmoved(x, y)
   currentWorld:emit("wheelmoved", x, y)
end
