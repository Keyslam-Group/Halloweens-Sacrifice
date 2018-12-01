local Concord = require("lib.concord")

return Concord.component(function(e, shape, tag)
   e.shape = shape
   e.tag   = tag
end)
