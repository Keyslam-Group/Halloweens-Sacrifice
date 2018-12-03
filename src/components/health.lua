local Concord = require("lib.concord")

local function none() end

return Concord.component(function(e, health, onDeath)
   e.health    = health or 100
   e.maxHealth = e.health

   e.onDeath = onDeath or none
end)
