local Concord = require("lib.concord")

local C = require("src.components")

local Physics = Concord.system({C.transform, C.speed})

function Physics:fixedUpdate(dt)
   for _, e in ipairs(self.pool) do
      local transform = e[C.transform]
      local speed     = e[C.speed]

      transform.position = transform.position + speed.velocity * dt
   end
end

return Physics

