local Concord = require("lib.concord")
local Class = require("lib.class")
local Vector = require("lib.vector")

local Camera = require("src.camera")

local SpellBase = require("src.classes.spells.spellBase")

local C = require("src.components")
local A = require("src.assemblages")

local SpellBurst = Class("SpellBurst", SpellBase)

function SpellBurst:initialize()
    self.projectileSpeed = 400
end

function SpellBurst:cast(e, world)
   local transform = e[C.transform]

   if transform then
      local mx, my = love.mouse.getPosition()

      mx = mx / (love.graphics.getWidth()  / Camera.w) - Camera.w/2 + Camera.x
      my = my / (love.graphics.getHeight() / Camera.h) - Camera.h/2 + Camera.y

      local target = Vector(mx, my)

      local delta = target - transform.position
      local direction = math.atan2(delta.y, delta.x)

      for offset = -1, 1 do
         local newDirection = direction + offset * 0.3

         local velocity = Vector(math.cos(newDirection), math.sin(newDirection))
         velocity = velocity * self.projectileSpeed

         local position = transform.position:clone()
         world:addEntity(Concord.entity()
            :assemble(A.bullet, position, velocity, true)
         )
      end
   end
end

return SpellBurst
