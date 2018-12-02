local Class = require("lib.class")
local Vector = require("lib.vector")

local Quad = Class("quad")

function Quad:initialize(x, y, w, h, sw, sh)
   self.quad = love.graphics.newQuad(x, y, w, h, sw, sh)
   self.size = Vector(w, h)
end

return Quad
