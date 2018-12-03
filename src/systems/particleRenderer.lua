local Concord = require("lib.concord")

local C = require("src.components")

local ParticleRenderer = Concord.system({C.transform, C.particle})

function ParticleRenderer:flush()
   for _, e in ipairs(self.pool.added) do
      local particle  = e[C.particle]
      particle.system:start()
   end
end

function ParticleRenderer:fixedUpdate(dt)
   for _, e in ipairs(self.pool) do
      local transform = e[C.transform]
      local particle  = e[C.particle]

      particle.system:moveTo(transform.position.x, transform.position.y)
      particle.system:update(dt)
   end
end

function ParticleRenderer:draw()
   for _, e in ipairs(self.pool) do
      local particle  = e[C.particle]

      love.graphics.draw(particle.system)
   end
end

return ParticleRenderer
