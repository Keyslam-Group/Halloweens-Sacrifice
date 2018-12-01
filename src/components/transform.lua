local Concord = require("lib.concord")
local Vector  = require("lib.vector")

return Concord.component(function(e, position, rotation)
   e.position = position or Vector(0, 0)
   e.rotation = rotation or 0
end)
