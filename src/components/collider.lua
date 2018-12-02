local Concord = require("lib.concord")

local function none(e, other, sepX, sepY) end -- luacheck: ignore

return Concord.component(function(e, shape, tag, isSolid, isFriendly, callback)
   e.shape = shape
   e.tag   = tag

   e.isSolid = isSolid
   e.isFriendly = isFriendly

   e.callback = callback or none
end)
