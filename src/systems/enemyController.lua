local Concord = require("lib.concord")

local C = require("src.components")

local EnemyController = Concord.system({C.transform, C.enemyControls})

function EnemyController:fixedUpdate(dt)
   for _, e in ipairs(self.pool) do
      local transform     = e[C.transform]
      local enemyControls = e[C.enemyControls]

      local target = enemyControls.target
      if target then
         local targetTransform = target[C.transform]

         if targetTransform then
            local distance = targetTransform.position - transform.position
            local heading = distance:normalizeInplace()
            heading = heading * enemyControls.speed

            transform.position.x = transform.position.x + heading.x * dt
            transform.position.y = transform.position.y + heading.y * dt
         end
      end
   end
end

return EnemyController
