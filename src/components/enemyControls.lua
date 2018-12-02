local Concord = require("lib.concord")

return Concord.component(function(e, target)
   e.target = target
   e.speed = 50
end)
