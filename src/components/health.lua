local Concord = require("lib.concord")

return Concord.component(function(e, health, maxHealth)
	e.health    = health or 100
	e.maxHealth = maxHealth or e.health
end)