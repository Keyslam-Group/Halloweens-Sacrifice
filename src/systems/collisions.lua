local Concord = require('lib.concord')
local TablePool = require("lib.newhc.pool") --To reuse tables!

local C = require("src.components")

local Collisions = Concord.system({C.transform, C.collider})

function Collisions:flush()
   local world = self:getWorld()

   for _, e in ipairs(self.pool.removed) do
      local collider  = e[C.collider]

      local collisionWorld = world.worlds[collider.tag]

      collisionWorld.remove(collider.shape)
   end

   for _, e in ipairs(self.pool.added) do
      local transform = e[C.transform]
      local collider  = e[C.collider]

      local collisionWorld = world.worlds[collider.tag]

      collider.shape.entity = e

      collider.shape:moveTo(transform.position.x, transform.position.y)
      collider.shape:setRotation(transform.rotation)

      collisionWorld:register(collider.shape)
   end
end

function Collisions:fixedUpdate()
   local world = self:getWorld()

   for _, e in ipairs(self.pool) do
      local transform = e[C.transform]
      local collider  = e[C.collider]

      local collisionWorld = world.worlds[collider.tag]

      collider.shape:moveTo(transform.position.x, transform.position.y)
      collider.shape:setRotation(transform.rotation)

      if collider.shape.entity then --FIXME: If this is false the entity wasn't properly flushed
         local collisions = collisionWorld:collisions(collider.shape)

         local col
         for i=#collisions, 1, -1 do
            col, collisions[i] = collisions[i], nil

            --col.entity is the entity you are colliding with
            --col.x and col.y define the separating vector

            collider.shape:move(col.x, col.y)

            local x, y = collider.shape:center()
            transform.position.x = x
            transform.position.y = y

            --Free col
            col.entity, col.x, col.y = nil, nil, nil
            TablePool:pushEmpty(col)
         end

         TablePool:pushEmpty(collisions) --Free collisions
      end
   end
end

return Collisions
