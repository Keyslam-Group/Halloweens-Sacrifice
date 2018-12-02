local Concord = require("lib.concord")
local Class = require("lib.class")
local Vector = require("lib.vector")

local Camera = require("src.camera")

local SpellBase = require("src.classes.spells.spellBase")

local C = require("src.components")
local A = require("src.assemblages")

local SpellRing = Class("SpellRing", SpellBase)

function SpellRing:initialize()
   SpellBase.initialize(self, 0.2)

   self.emitSpeed = 80
   self.followSpeed = 900
   self.maxSpeed = 200

   self.projectiles = {}
end

function SpellRing:cast(e, target, world)
   SpellBase.cast(self, e, target, world)

   local transform = e[C.transform]
   local collider  = e[C.collider]

   if transform then
      local delta = target - transform.position
      local direction = math.atan2(delta.y, delta.x)

      local amount = 8
      local step = math.pi * 2 / amount
      for i = 1, amount do
         local newDirection = direction + (i * step)

         local velocity = Vector(math.cos(newDirection), math.sin(newDirection))
         velocity = velocity * self.emitSpeed

         local projectile = Concord.entity()
            :assemble(A.bullet, transform.position:clone(), velocity, 2, collider.isFriendly)

         world:addEntity(projectile)
         table.insert(self.projectiles, projectile)
      end
   end
end

function SpellRing:update(e, target, world, dt)
   SpellBase.update(self, e, target, world, dt)

   for _, projectile in ipairs(self.projectiles) do
      local transform = projectile[C.transform]
      local speed = projectile[C.speed]

      local distance = target - transform.position
      local heading = distance:normalizeInplace()
      heading = heading * self.followSpeed

      speed.velocity = speed.velocity + heading * dt
      speed.velocity:trimInplace(self.maxSpeed)
   end
end

return SpellRing
