local Concord = require("lib.concord")

local none = Concord.component()

local ScoreRenderer = Concord.system({none})

local font = love.graphics.newFont("assets/PressStart2P.ttf", 24)

function ScoreRenderer:draw()
   love.graphics.setColor(0, 0, 0, 0.7)
   love.graphics.rectangle("fill", 0, 0, 1280, 50)

   love.graphics.setFont(font)
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.printf(score.." / 150 gnomes sacrificed", 0, 10, 1280, "center")

   love.graphics.setColor(1, 1, 1)
end

return ScoreRenderer
