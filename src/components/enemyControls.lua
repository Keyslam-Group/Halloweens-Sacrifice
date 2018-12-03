local Concord = require("lib.concord")

return Concord.component(function(e, target)
   e.target = target
   e.speed = 100
   e.fleeSpeed = 80
   e.range = 150
end)
