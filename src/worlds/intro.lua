local Concord = require("lib.concord")

local intro = Concord.world()

local font = love.graphics.newFont("assets/pressStart2P.ttf", 30)

local introAudio = love.audio.newSource("sounds/intro.wav", "static")
introAudio:play()

function intro:update(dt)
   if not introAudio:isPlaying() then
      currentWorld = require("src.worlds.game")
      music:play()
   end
end

function intro:draw()
   love.graphics.setFont(font)
   love.graphics.printf("WASD to move", 0, 100, 1280, "center")
   love.graphics.printf("Space / Left mouse to cast", 0, 150, 1280, "center")
   love.graphics.printf("Mouse to steer projectiles", 0, 200, 1280, "center")

   love.graphics.printf("Casting drains health", 0, 300, 1280, "center")
   love.graphics.printf("SACRIFICE 150 GNOMES\n to bring back\n HALLOWEEN", 0, 370, 1280, "center")

   love.graphics.printf("Press Space to skip", 0, 600, 1280, "center")
end

function intro:keypressed(key)
   if key == "space" then
      introAudio:stop()
   end
end

return intro
