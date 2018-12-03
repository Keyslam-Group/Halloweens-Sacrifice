local Concord = require('lib.concord')
local Shapes = require('lib.hc.shapes')
local Quad = require('src.classes.quad')

local C = require('src.components')

local function collisionCallback(eShape, otherShape)
   local e = eShape.entity
   local other = otherShape.entity

   local shouldResolve = false

   if not other then
      shouldResolve = true
   else
      local otherCollider = other[C.collider]
      if otherCollider.isSolid then
         shouldResolve = true
      end
   end

   if shouldResolve then
      if other then
         local eCollider = e[C.collider]
         local otherCollider = other[C.collider]

         local eDamage = e[C.damage]
         local otherHealth = other[C.health]

         if eDamage and otherHealth then
            if eCollider.isFriendly ~= otherCollider.isFriendly then
               otherHealth.health = otherHealth.health - eDamage.damage

               if otherHealth.health <= 0 then
                  otherHealth:onDeath()
                  other:destroy()
               end

               e:destroy()
            end
         end
      else
         e:destroy()
      end
   end
end

local ps_friendly = love.graphics.newParticleSystem(love.graphics.newImage("assets/particle_1.png"), 100)
ps_friendly:setColors(0.43, 0.64, 0.91, 1,  0.2, 0.3, 0.5, 0)
ps_friendly:setParticleLifetime(0.4)
ps_friendly:setEmissionRate(80)
ps_friendly:setSpin(-4, 4)

local ps_unfriendly = love.graphics.newParticleSystem(love.graphics.newImage("assets/particle_1.png"), 100)
ps_unfriendly:setColors(0.91, 0.43, 0.43, 1,  0.5, 0.2, 0.2, 0)
ps_unfriendly:setParticleLifetime(0.4)
ps_unfriendly:setEmissionRate(80)
ps_unfriendly:setSpin(-4, 4)

return Concord.assemblage(
   function(e, position, velocity, damage, isFriendly)
      e:give(C.transform, position, 0)
       :give(C.speed, velocity)
       :give(C.collider, Shapes.CircleShape(position.x, position.y, 2), 'game', false, isFriendly, collisionCallback)
       :give(C.damage, damage)
       :give(C.particle, (isFriendly and ps_friendly or ps_unfriendly):clone())
    end
)
