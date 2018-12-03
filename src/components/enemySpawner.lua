local Concord = require("lib.concord")

return Concord.component(function(e, spawnDelay)
   e.timeLeft = spawnDelay
   e.timeMax = spawnDelay
end)
