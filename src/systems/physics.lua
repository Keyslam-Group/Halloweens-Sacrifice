local Concord = require("lib.concord")

local C = require("src.components")
local TablePool = require("lib.hc.pool") --To reuse tables!

local Physics = Concord.system({C.transform, C.speed})

function Physics:flush()
   local world = self:getWorld()

   for _, e in ipairs(self.pool.removed) do
      local collider  = e[C.collider]

      if collider then
         local collisionWorld = world.worlds[collider.tag]

         collisionWorld:remove(collider.shape)
      end
   end

   for _, e in ipairs(self.pool.added) do
      local transform = e[C.transform]
      local collider  = e[C.collider]

      if collider then
         local collisionWorld = world.worlds[collider.tag]

         collider.shape.entity = e

         collider.shape:moveTo(transform.position.x, transform.position.y)
         collider.shape:setRotation(transform.rotation)

         collisionWorld:register(collider.shape)
      end
   end
end

function Physics:fixedUpdate(dt)
   local world = self:getWorld()

   for _, e in ipairs(self.pool) do
      local transform = e[C.transform]
      local speed     = e[C.speed]

      transform.position = transform.position + speed.velocity * dt

      local collider  = e[C.collider]

      if collider then
         local collisionWorld = world.worlds[collider.tag]

         collider.shape:moveTo(transform.position.x, transform.position.y)
         collider.shape:setRotation(transform.rotation)

         if collider.shape.entity then --FIXME: If this is false the entity wasn't properly flushed
            local collisions = collisionWorld:collisions(collider.shape)

            local col
            for i = #collisions, 1, -1 do
               if not e.destroyed then
                  col, collisions[i] = collisions[i], nil

                  --col.entity is the entity you are colliding with
                  --col.x and col.y define the separating vector

                  collider.callback(collider.shape, col.entity, col.x, col.y)
                  --[[
                  collider.shape:move(col.x, col.y)

                  local x, y = collider.shape:center()
                  transform.position.x = x
                  transform.position.y = y
                  ]]

                  --Free col
                  col.entity, col.x, col.y = nil, nil, nil
                  TablePool:pushEmpty(col)
               end
            end

            TablePool:pushEmpty(collisions) --Free collisions
         end
      end
   end
end

return Physics

