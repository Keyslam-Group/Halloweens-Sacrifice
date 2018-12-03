local Concord = require("lib.concord")

local C = require("src.components")
local A = require("src.assemblages")

local EnemySpawner = Concord.system({C.transform, C.enemySpawner})

function EnemySpawner:init()
   self.target = nil
end

function EnemySpawner:update(dt)
   local world = self:getWorld()

   for _, e in ipairs(self.pool) do
      local transform = e[C.transform]
      local enemySpawner = e[C.enemySpawner]

      enemySpawner.timeLeft = enemySpawner.timeLeft - dt
      if enemySpawner.timeLeft <= 0 then
         enemySpawner.timeLeft = enemySpawner.timeLeft + enemySpawner.timeMax

         world:addEntity(Concord.entity()
            :assemble(A.enemy, transform.position:clone(), self.target)
         )
      end
   end
end

return EnemySpawner
