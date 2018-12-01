local Concord = require("lib.concord")

local function none(e, other, sepX, sepY) end -- luacheck: ignore

return Concord.component(function(e, shape, tag, callback)
   e.shape = shape
   e.tag   = tag

   e.callback = callback or none
end)
