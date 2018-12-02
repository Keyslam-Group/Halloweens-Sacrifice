local Concord = require("lib.concord")
local Vector  = require("lib.vector")

return Concord.component(function(e, velocity)
   e.velocity = velocity or Vector(0, 0)
end)
