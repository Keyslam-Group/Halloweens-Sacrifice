local Concord = require("lib.concord")

local GameOver = Concord.world()
local font_big = love.graphics.newFont("assets/font.ttf", 120)
local font_small = love.graphics.newFont("assets/font.ttf", 50)

function GameOver:draw()
   music:stop()

   love.graphics.setFont(font_big)
   love.graphics.printf("You couldn't stop christmas...", 0, 150, 1280, "center")

   love.graphics.setFont(font_small)
   love.graphics.printf("Press R to restart", 0, 600, 1280, "center")
   love.graphics.setCanvas()
end

function GameOver:keypressed(key)
   if key == "r" then
      love.event.quit("restart")
   end
end

return GameOver
