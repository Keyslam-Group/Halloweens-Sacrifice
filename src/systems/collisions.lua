local Concord = require('lib.concord')

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

      local collisions = collisionWorld:collisions(collider.shape)
      for _, separatingVector in pairs(collisions) do
         collider.shape:move(separatingVector.x, separatingVector.y)

         local x, y = collider.shape:center()

         transform.position.x = x
         transform.position.y = y
      end
   end
end

return Collisions