local Concord = require("lib.concord")

local C = require("src.components")

local AnimationController = Concord.system({C.sprite, C.animation})

function AnimationController:update(dt)
   for _, e in ipairs(self.pool) do
      local sprite = e[C.sprite]
      local animation = e[C.animation]

      local anim = animation.animations[animation.current]
      anim.currentTime = anim.currentTime + dt

      if anim.currentTime >= anim.frameTime then
         anim.currentTime = anim.currentTime - anim.frameTime
         anim.currentFrame = anim.currentFrame + 1

         if anim.currentFrame > #anim.frames then
            anim.currentFrame = 1
         end
      end

      sprite.quad = anim.frames[anim.currentFrame]
   end
end

return AnimationController
