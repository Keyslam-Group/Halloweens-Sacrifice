local Concord = require("lib.concord")
local Class = require("lib.class")
local Vector = require("lib.vector")

local Camera = require("src.camera")

local SpellBase = require("src.classes.spells.spellBase")

local C = require("src.components")
local A = require("src.assemblages")

local SpellBurst = Class("SpellBurst", SpellBase)

function SpellBurst:initialize()
   SpellBase.initialize(self, 0.8)

   self.projectileSpeed = 300
end

function SpellBurst:cast(e, target, world)
   SpellBase.cast(self, e, target, world)

   local transform = e[C.transform]
   local collider = e[C.collider]

   if transform then
      local delta = target - transform.position
      local direction = math.atan2(delta.y, delta.x)

      for offset = -1, 1 do
         local newDirection = direction + offset * 0.2

         local velocity = Vector(math.cos(newDirection), math.sin(newDirection))
         velocity = velocity * self.projectileSpeed

         local position = transform.position:clone()
         world:addEntity(Concord.entity()
            :assemble(A.bullet, position, velocity, 10, collider.isFriendly)
         )
      end
   end
end

return SpellBurst
