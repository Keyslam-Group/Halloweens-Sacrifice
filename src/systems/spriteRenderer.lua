local Concord = require("lib.concord")

local C = require("src.components")

local SpriteRenderer = Concord.system({C.transform, C.sprite})

function SpriteRenderer:flush()
   local world   = self:getWorld()
   local batches = world.batches

   for _, e in ipairs(self.pool.removed) do
      local sprite = e[C.sprite]

      if sprite.id and sprite.tag then
         batches[sprite.tag]:remove(sprite.id)
      end
   end

   for _, e in ipairs(self.pool.added) do
      local transform = e[C.transform]
      local sprite    = e[C.sprite]

      local id  = batches[sprite.tag]:add(sprite.quad, transform.position.x, transform.position.y, transform.rotation)
      sprite.id = id
   end
end

function SpriteRenderer:draw()
   local world   = self:getWorld()
   local batches = world.batches

   for _, e in ipairs(self.pool) do
      local transform = e[C.transform]
      local sprite    = e[C.sprite]

      batches[sprite.tag]:set(sprite.id, sprite.quad, transform.position.x, transform.position.y, transform.rotation)
   end
end

return SpriteRenderer