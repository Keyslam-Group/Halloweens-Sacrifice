local Stalker = require("lib.stalker")

local width, height = 320, 180
local deadzoneWidth, deadzoneHeight = 20, 20

local Camera = Stalker(0, 0, width, height)
Camera:setFollowLerp(0.03)
Camera:setDeadzone(width/2 - deadzoneWidth/2, height/2 - deadzoneHeight/2, deadzoneWidth, deadzoneHeight)
Camera.draw_deadzone = true

return Camera
