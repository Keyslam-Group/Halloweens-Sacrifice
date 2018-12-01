local Concord = require("lib.concord")

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

      if controller:pressed("shoot") then
         currentSpell:cast(e, world)
      end

      currentSpell:update(e, world, dt)
   end
end

return PlayerController
