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
      local health         = e[C.health]
      local animation = e[C.animation]

      local controller = playerControls.controller

      controller:update()

      local x, y = controller:get("move")
      transform.position.x = transform.position.x + x * 160 * dt
      transform.position.y = transform.position.y + y * 160 * dt

      local anim
      if x == 0 and y == 0 then
         anim = "idle"
      elseif x > y then
         anim = "walk_right"
      elseif x < -y then
         anim = "walk_left"
      else
         anim = "walk_down"
      end

      if animation.current ~= anim then
         animation:switch(anim)
      end

      local currentSpell = spells.spells[spells.currentSpellIndex]

      local mx, my = love.mouse.getPosition()
      mx = mx / (love.graphics.getWidth()  / Camera.w) - Camera.w/2 + Camera.x
      my = my / (love.graphics.getHeight() / Camera.h) - Camera.h/2 + Camera.y
      local target = Vector(mx, my)

      health.health = math.min(health.health + 45 * dt, health.maxHealth)

      if controller:down("shoot") and currentSpell:canCast() then
         if health.health > 35 then
            currentSpell:cast(e, target, world)
            health.health = health.health - 100
         end
      end

      currentSpell:update(e, target, world, dt)
   end
end

function PlayerController:wheelmoved(_, y)
   --[[
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
   ]]
end

return PlayerController
