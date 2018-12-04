local Concord = require("lib.concord")

local GameWin = Concord.world()
local font_big = love.graphics.newFont("assets/halo.ttf", 100)
local font_small = love.graphics.newFont("assets/halo.ttf", 30)

function GameWin:draw()
   music:stop()

   love.graphics.setFont(font_big)
   love.graphics.printf("You brought back halloween!!!", 0, 150, 1280, "center")

   love.graphics.setFont(font_small)
   love.graphics.printf("Press R to restart", 0, 600, 1280, "center")
   love.graphics.setCanvas()
end

function GameWin:keypressed(key)
   if key == "r" then
      love.event.quit("restart")
   end
end

return GameWin
