local Concord = require("lib.concord")

local C = require("src.components")

local EnemyController = Concord.system({C.transform, C.enemyControls})

function EnemyController:fixedUpdate(dt)
   local world = self:getWorld()

   for _, e in ipairs(self.pool) do
      local transform     = e[C.transform]
      local enemyControls = e[C.enemyControls]
      local spells        = e[C.spells]

      local target = enemyControls.target
      if target then
         local targetTransform = target[C.transform]

         if targetTransform then
            local distance = targetTransform.position - transform.position

            local currentSpell = spells.spells[spells.currentSpellIndex]

            if distance:len() > enemyControls.range then
               local heading = distance:normalizeInplace()
               heading = heading * enemyControls.speed

               transform.position.x = transform.position.x + heading.x * dt
               transform.position.y = transform.position.y + heading.y * dt
            else
               if currentSpell:canCast() then
                  currentSpell:cast(e, targetTransform.position, world)
               end
            end

            currentSpell:update(e, targetTransform.position, world, dt)
         end
      end
   end
end

return EnemyController
