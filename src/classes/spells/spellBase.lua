local Class = require("lib.class")

local SpellBase = Class("SpellBase")

function SpellBase:initialize(maxCooldown) -- luacheck: ignore
   self.maxCooldown = maxCooldown
   self.currentCooldown = 0
end

function SpellBase:canCast()
   return self.currentCooldown == 0
end

function SpellBase:cast(e, target, world) -- luacheck: ignore
   self.currentCooldown = self.maxCooldown
end

function SpellBase:update(e, target, world, dt) -- luacheck: ignore
   if self.currentCooldown > 0 then
      self.currentCooldown = math.max(0, self.currentCooldown - dt)
   end
end

return SpellBase
