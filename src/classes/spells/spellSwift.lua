local Concord = require("lib.concord")
local Class = require("lib.class")
local Vector = require("lib.vector")

local Camera = require("src.camera")

local SpellBase = require("src.classes.spells.spellBase")

local C = require("src.components")
local A = require("src.assemblages")

local SpellSwift = Class("SpellSwift", SpellBase)

function SpellSwift:initialize()
   SpellBase.initialize(self, 0.8)

   self.projectileSpeed = 300
end

function SpellSwift:cast(e, target, world)
   SpellBase.cast(self, e, target, world)

   local transform = e[C.transform]
   local collider = e[C.collider]

   if transform then
      local delta = target - transform.position
      local velocity = delta:normalized() * self.projectileSpeed

      local position = transform.position:clone()
      world:addEntity(Concord.entity()
         :assemble(A.bullet, position, velocity, 70, collider.isFriendly)
      )
   end
end

return SpellSwift
