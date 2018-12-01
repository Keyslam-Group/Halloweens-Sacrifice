local Concord = require("lib.concord")

return Concord.component(function(e, quad, tileset)
   e.quad = quad
   e.tileset = tileset
end)
