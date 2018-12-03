local Concord = require("lib.concord")

local C = require("src.components")

local Vector = require("lib.vector")
local EnemyController = Concord.system({C.transform, C.enemyControls})

function EnemyController:fixedUpdate(dt)
   local world = self:getWorld()

   for _, e in ipairs(self.pool) do
      local transform     = e[C.transform]
      local enemyControls = e[C.enemyControls]
      local spells        = e[C.spells]
      local animation     = e[C.animation]

      local target = enemyControls.target
      if target then
         local targetTransform = target[C.transform]

         if targetTransform then
            local distance = targetTransform.position - transform.position

            local currentSpell = spells.spells[spells.currentSpellIndex]

            local steering = Vector(0, 0)

            if distance:len() > enemyControls.range then
               local heading = distance:normalizeInplace()
               heading = heading * enemyControls.speed

               steering = steering + heading

               for _, o in ipairs(self.pool) do
                  if e ~= o then
                     local otherTransform = o[C.transform]
                     local dist = otherTransform.position - transform.position

                     if dist:len() < 50 then
                        local flee = dist:normalizeInplace()
                        flee = flee * -enemyControls.fleeSpeed

                        steering = steering + flee
                     end
                  end
               end
            else
               if currentSpell:canCast() then
                  currentSpell:cast(e, targetTransform.position, world)
               end
            end

            local anim
            if steering.x == 0 and steering.y == 0 then
               anim = "idle"
            elseif steering.x > steering.y then
               anim = "walk_right"
            elseif steering.x < -steering.y then
               anim = "walk_left"
            else
               anim = "walk_down"
            end

            if animation.current ~= anim then
               animation:switch(anim)
            end

            transform.position.x = transform.position.x + steering.x * dt
            transform.position.y = transform.position.y + steering.y * dt

            currentSpell:update(e, targetTransform.position, world, dt)
         end
      end
   end
end

return EnemyController
