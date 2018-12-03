local Concord = require("lib.concord")

local GameOver = Concord.world()
local font_big = love.graphics.newFont("assets/font.ttf", 100)
local font_small = love.graphics.newFont("assets/font.ttf", 30)

local canvas = love.graphics.newCanvas(640, 360)

function GameOver:draw()
   love.graphics.setCanvas(canvas)
   love.graphics.clear()

   love.graphics.setFont(font_big)
   love.graphics.printf("Game over", 0, 0, 320, "center")

   love.graphics.setFont(font_small)
   love.graphics.printf("You couldn't stop christmas...", 0, 100, 320, "center")
   love.graphics.setCanvas()

   love.graphics.draw(canvas, nil, nil, nil, 4, 4)
end

return GameOver
