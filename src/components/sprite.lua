local Concord = require("lib.concord")

return Concord.component(function(e, quad, tag)
   e.quad = quad
   e.tag  = tag
   e.id   = nil
end)