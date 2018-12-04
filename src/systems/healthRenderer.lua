local Concord = require("lib.concord")

local C = require("src.components")

local HealthRenderer = Concord.system({C.transform, C.health})

function HealthRenderer:draw()
   for _, e in ipairs(self.pool) do
      local transform = e[C.transform]
      local health = e[C.health]

      love.graphics.setColor(0, 0, 0, 0.9)
      love.graphics.rectangle("fill", transform.position.x - 20, transform.position.y - 40, 40, 6)

      local percentage = health.health / health.maxHealth
      love.graphics.setColor(1 - percentage, percentage, 0, 0.9)
      love.graphics.rectangle("fill", transform.position.x - 20, transform.position.y - 40, 40 * percentage, 6)
   end

   love.graphics.setColor(1, 1, 1)
end

return HealthRenderer
