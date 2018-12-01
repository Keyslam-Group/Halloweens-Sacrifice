local Concord = require("lib.concord")
local Push    = require("lib.push")

local C = require("src.components")

local Camera = Concord.system({C.empty})

--TODO: Actually implement camera
function Camera:start ()
   Push:start()
end

function Camera:finish ()
   Push:finish()
end

return Camera
