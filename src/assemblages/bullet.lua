local Concord = require('lib.concord')
local Shapes = require('lib.hc.shapes')

local Camera = require("src.camera")

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

               local intensity = otherCollider.isFriendly and 7 or 4
               Camera:shake(intensity, 0.2, 30)

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
ps_unfriendly:setColors(0.91, 0.43, 0.43, 1, 0.91, 0.43, 0.43, 1, 0.5, 0.2, 0.2, 0)
ps_unfriendly:setParticleLifetime(0.4)
ps_unfriendly:setEmissionRate(80)
ps_unfriendly:setSpin(-4, 4)

local sounds = {
   love.audio.newSource("sounds/sfx/projectile_1.wav", "static"),
   love.audio.newSource("sounds/sfx/projectile_2.wav", "static"),
   love.audio.newSource("sounds/sfx/projectile_3.wav", "static"),
   love.audio.newSource("sounds/sfx/projectile_4.wav", "static"),
   love.audio.newSource("sounds/sfx/projectile_5.wav", "static"),
}

local function playSound(isFriendly)
   local sound = sounds[love.math.random(1, #sounds)]

   sound:setVolume(isFriendly and 0.1 or 0.05)

   sound:stop()
   sound:play()
end

return Concord.assemblage(
   function(e, position, velocity, damage, isFriendly)
      e:give(C.transform, position, 0)
       :give(C.speed, velocity)
       :give(C.collider, Shapes.CircleShape(position.x, position.y, 2), 'game', false, isFriendly, collisionCallback)
       :give(C.damage, damage)
       :give(C.particle, (isFriendly and ps_friendly or ps_unfriendly):clone())

       playSound(isFriendly)
    end
)
