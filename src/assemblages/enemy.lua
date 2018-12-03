local Concord = require("lib.concord")
local Shapes  = require("lib.hc.shapes")
local Vector = require("lib.vector")
local Quad = require("src.classes.quad")
local Animation = require("src.classes.animation")

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
      local shouldPlay = love.math.random(0, 3) == 0
      if shouldPlay then
         local line = love.math.random(1, #voicelines)
         voicelines[line]:setVolume(1)
         voicelines[line]:play()

         lastVoicelineTime = love.timer.getTime()
      end
   end
end

return Concord.assemblage(function(e, position, target)
   e:give(C.transform, position, 0)
    :give(C.sprite, Quad(0, 128, 16, 16, 320, 384), "enemy")
    :give(C.collider, Shapes.CircleShape(position.x, position.y, 20), "game", true, false, collisionCallback)
    :give(C.health, 100, onDeath)
    :give(C.animation, {
      idle = Animation({
         Quad(  0, 0, 64, 64, 768, 64),
      }, 1),
      walk_down = Animation({
        Quad(  0, 0, 64, 64, 768, 64),
        Quad( 64, 0, 64, 64, 768, 64),
        Quad(128, 0, 64, 64, 768, 64),
        Quad(192, 0, 64, 64, 768, 64),
      }, 0.25),
      walk_right = Animation({
       Quad(256, 0, 64, 64, 768, 64),
       Quad(320, 0, 64, 64, 768, 64),
       Quad(384, 0, 64, 64, 768, 64),
       Quad(448, 0, 64, 64, 768, 64),
       }, 0.25),
      walk_left = Animation({
       Quad(512, 0, 64, 64, 768, 64),
       Quad(576, 0, 64, 64, 768, 64),
       Quad(640, 0, 64, 64, 768, 64),
       Quad(704, 0, 64, 64, 768, 64),
      }, 0.25)
   }, "idle")
    :give(C.enemyControls, target)
    :give(C.speed, Vector(0, 0))
    :give(C.spells, 2)
end)
