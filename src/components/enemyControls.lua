local Concord = require("lib.concord")

return Concord.component(function(e, target)
   e.target = target
   e.speed = 50
   e.fleeSpeed = 40
   e.range = 100
end)
