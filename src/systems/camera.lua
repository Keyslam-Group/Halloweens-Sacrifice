local Concord = require("lib.concord")

local Camera_ = require("src.camera")

local C = require("src.components")

local Camera = Concord.system({C.empty})

function Camera:init()
   self.buffer = love.graphics.newCanvas(Camera_.w, Camera_.h)
end

function Camera:update(dt)
   local world = self:getWorld()

   Camera_:update(dt)

   if world.target then
      local transform = world.target[C.transform]

      if transform then
         Camera_:follow(transform.position.x, transform.position.y)
      end
   end
end

function Camera:start()
   love.graphics.setCanvas(self.buffer)
   love.graphics.clear()

   Camera_:attach()
end

function Camera:finish()
   Camera_:detach()
   --Camera_:draw()

   love.graphics.setCanvas()

   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.setBlendMode("alpha", "premultiplied")
   love.graphics.draw(self.buffer, 0, 0, 0, love.graphics.getWidth() / Camera_.w, love.graphics.getHeight() / Camera_.h)
   love.graphics.setBlendMode("alpha")
end

return Camera
