local Concord = require("lib.concord")
local Baton   = require("lib.baton")

return Concord.component(function(e, up, down, left, right, shoot)
   local controls = {
      up    = up,
      down  = down,
      left  = left,
      right = right,

      shoot = shoot,
   }

   local pairs = {
      move = {
         "left", "right", "up", "down",
      }
   }

   e.controller = Baton.new({
      controls = controls,
      pairs    = pairs,
      joystick = love.joystick.getJoysticks()[1],
   })
end)