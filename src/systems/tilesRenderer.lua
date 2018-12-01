local Concord = require("lib.concord")
local Push    = require("lib.push")

local C = require("src.components")

local TilesRenderer = Concord.system({C.empty})

local function render (_, item, image)
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.draw(image, item[5], item[1], item[2])
end

function TilesRenderer:draw()
   local world = self:getWorld()

   local tilesets = world.project.tilesets
   local x, y, w, h = 0, 0, Push:getDimensions() --TODO: Get the visible area (from the Camera)

   for _,name in ipairs(world.order) do --Iterate over the order of the layers
      local layer = world.layers[name] --Get the layer

      --Only render if the layer exists
      if layer then
         --Get the tileset image for the layer
         local image = tilesets[layer.tilesetName].image
         --Query the spatialhash for the visible area
         layer.spatialhash:inSameCell(x, y, w, h, render, image)
      end
   end
end

return TilesRenderer
