local Concord = require("lib.concord")
local Class = require("lib.class")
local Push = require("lib.push")
local Vector = require("lib.vector")

local SpellBase = require("src.classes.spells.spellBase")

local C = require("src.components")
local A = require("src.assemblages")

local SpellBurst = Class("SpellBurst", SpellBase)

function SpellBurst:initialize()
    self.projectileSpeed = 300
end

function SpellBurst:cast(e, world)
   local transform = e[C.transform]

   if transform then
      local mx, my = love.mouse.getPosition()
      local rmx, rmy = Push:toGame(mx, my)

      local target = Vector(rmx, rmy)
      local direction = target:angleTo(transform.position)

      for offset = -6, 6 do
         local newDirection = direction + offset * 0.05

         local velocity = Vector(math.cos(newDirection), math.sin(newDirection))
         velocity = velocity * self.projectileSpeed

         world:addEntity(Concord.entity()
            :assemble(A.bullet, transform.position:clone(), velocity)
         )
      end
   end
end

return SpellBurst
