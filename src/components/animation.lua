local Concord = require("lib.concord")

local Animation = Concord.component(function(e, animations, initialState)
   e.animations = animations
   e.current = initialState
end)

function Animation:switch(newState)
   local animation = self.animations[newState]
   animation.currentTime = 0
   animation.currentFrame = 1
end

return Animation
