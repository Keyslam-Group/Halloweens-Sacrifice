local Concord = require("lib.concord")

return Concord.component(function(e, isFriendly)
   e.isFriendly = isFriendly or false
end)
