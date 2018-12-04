love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
love.graphics.setDefaultFilter("nearest", "nearest")

require("lib.steady")

score = 0

local W = require("src.worlds")

currentWorld = W.intro

music = love.audio.newSource("music/main.ogg", "static")
music:setLooping(true)
music:setVolume(0.08)

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

function love.keypressed(key)
   currentWorld:emit("keypressed", key)
end
