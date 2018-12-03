love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
love.graphics.setDefaultFilter("nearest", "nearest")

require("lib.steady")

local W = require("src.worlds")

local currentWorld = W.game

local music = love.audio.newSource("music/main.wav", "static")
music:setLooping(true)
music:setVolume(0.6)

function love.load()
   currentWorld:emit("load")
   music:play()
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
