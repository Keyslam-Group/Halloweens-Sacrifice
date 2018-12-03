local Concord = require("lib.concord")
local Shapes  = require("lib.hc.shapes")
local Vector = require("lib.vector")
local Quad = require("src.classes.quad")

local C = require("src.components")

local function collisionCallback(eShape, otherShape, sepX, sepY)
   local e = eShape.entity
   local eTransform = e[C.transform]

   local shouldResolve = false
   local other = otherShape.entity

   if not other then
      shouldResolve = true
   else
      local otherCollider = other[C.collider]
      if otherCollider.isSolid then
         shouldResolve = true
      end
   end

   if shouldResolve then
      eShape:move(sepX, sepY)

      eTransform.position.x = eTransform.position.x + sepX
      eTransform.position.y = eTransform.position.y + sepY
   end
end

local voicelines = {
   love.audio.newSource("sounds/voicelines/gnome_more.wav", "static"),
   love.audio.newSource("sounds/voicelines/gnomes_candy.wav", "static"),
   love.audio.newSource("sounds/voicelines/meow_meow.wav", "static"),
   love.audio.newSource("sounds/voicelines/nyeay.wav", "static"),
   love.audio.newSource("sounds/voicelines/owo.wav", "static"),
   love.audio.newSource("sounds/voicelines/purrfect_execution.wav", "static"),
   love.audio.newSource("sounds/voicelines/theme_song.wav", "static"),
   love.audio.newSource("sounds/voicelines/trick_or_treat.wav", "static"),
}

local lastVoicelineTime = love.timer.getTime()
local function onDeath()
   if love.timer.getTime() - lastVoicelineTime > 4 then
      local shouldPlay = love.math.random(0, 0) == 0
      if shouldPlay then
         local line = love.math.random(1, #voicelines)
         voicelines[line]:play()
      end
   end
end

return Concord.assemblage(function(e, position, target)
   e:give(C.transform, position, 0)
    :give(C.sprite, Quad(0, 128, 16, 16, 320, 384), "main")
    :give(C.collider, Shapes.CircleShape(position.x, position.y, 5), "game", true, false, collisionCallback)
    :give(C.health, 100, onDeath)
    :give(C.enemyControls, target)
    :give(C.speed, Vector(0, 0))
    :give(C.spells, 1)
end)
