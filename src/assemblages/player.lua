local Concord = require("lib.concord")
local Shapes  = require("lib.hc.shapes")
local Vector = require("lib.vector")
local Quad = require("src.classes.quad")
local Animation = require("src.classes.animation")

local C = require("src.components")
local gameOver = require("src.worlds.gameOver")

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

function onDeath()
   currentWorld = gameOver
end

return Concord.assemblage(function(e, position)
   e:give(C.transform, position, 0)
    :give(C.sprite, Quad(0, 0, 64, 64, 519, 64), "player")
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
    :give(C.collider, Shapes.CircleShape(position.x, position.y, 15), "game", true, true, collisionCallback)
    :give(C.playerControls,
      {"key:up",    "key:w", "axis:lefty-", "button:dpup"},
      {"key:down",  "key:s", "axis:lefty+", "button:dpdown"},
      {"key:left",  "key:a", "axis:leftx-", "button:dpleft"},
      {"key:right", "key:d", "axis:leftx+", "button:dpright"},
      {"key:space", "button:a"})
    :give(C.spells, 3)
    :give(C.health, 1000, onDeath)
    :give(C.speed, Vector(0, 0))
end)
