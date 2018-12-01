local Concord = require("lib.concord")
local Vector  = require("lib.vector")

return Concord.component(function(e, velocity, friction)
   e.velocity = velocity or Vector(0, 0)
   e.friction = friction or 0
end)