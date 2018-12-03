local Class = require("lib.class")

local Animation = Class("Animation")

function Animation:initialize(frames, frameTime)
   self.frames = frames
   self.frameTime = frameTime
   self.currentTime = 0
   self.currentFrame = 1
end

return Animation
