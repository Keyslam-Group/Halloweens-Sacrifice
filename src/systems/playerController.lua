local Concord = require("lib.concord")
local Vector = require("lib.vector")
local Camera = require("src.camera")

local C = require("src.components")

local PlayerController = Concord.system({C.transform, C.playerControls, C.spells})

function PlayerController:fixedUpdate(dt)
   local world = self:getWorld()

   for _, e in ipairs(self.pool) do
      local transform      = e[C.transform]
      local playerControls = e[C.playerControls]
      local spells         = e[C.spells]

      local controller = playerControls.controller

      controller:update()

      local x, y = controller:get("move")
      transform.position.x = transform.position.x + x * 100 * dt
      transform.position.y = transform.position.y + y * 100 * dt

      local currentSpell = spells.spells[spells.currentSpellIndex]

      local mx, my = love.mouse.getPosition()
      mx = mx / (love.graphics.getWidth()  / Camera.w) - Camera.w/2 + Camera.x
      my = my / (love.graphics.getHeight() / Camera.h) - Camera.h/2 + Camera.y
      local target = Vector(mx, my)

      if controller:down("shoot") and currentSpell:canCast() then
         currentSpell:cast(e, target, world)
      end

      currentSpell:update(e, target, world, dt)
   end
end

function PlayerController:wheelmoved(_, y)
   for _, e in ipairs(self.pool) do
      local spells = e[C.spells]

      spells.currentSpellIndex = spells.currentSpellIndex + y

      if spells.currentSpellIndex > #spells.spells then
         spells.currentSpellIndex = 1
      end

      if spells.currentSpellIndex <= 0 then
         spells.currentSpellIndex = #spells.spells
      end
   end
end

return PlayerController
