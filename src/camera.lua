local Stalker = require("lib.stalker")

local width, height = 640, 360
local deadzoneWidth, deadzoneHeight = 40, 40

local Camera = Stalker(0, 0, width, height)
Camera:setFollowLerp(0.05)
Camera:setDeadzone(width/2 - deadzoneWidth/2, height/2 - deadzoneHeight/2, deadzoneWidth, deadzoneHeight)
Camera.draw_deadzone = false

return Camera
