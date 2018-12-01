local Concord = require("lib.concord")
local Vector  = require("lib.vector")
local HC      = require("lib.hc")
local Push    = require("lib.push")
local Map     = require("lib.gpgploader")
local Batch = require("src.classes.batch")

local C = require("src.components")
local S = require("src.systems")
local A = require("src.assemblages")

local Game = Concord.world()

Game.batches = {
   ["background"] = Batch(love.graphics.newImage("assets/tiles.png"), 1000, "dynamic"),
}

Game.worlds = {
   ["game"] = HC.new(100),
}

Game.project = Map.loadProject('map')
Game.level   = Map.loadLevel('level', Game.project, Game.worlds["game"])

Game.order = {
   "New tile layer",
   "foreground",
}

function Game:load()
   --print("Hey")
end

local function render (_, item, image)
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.draw(image, item[5], item[1], item[2])
end

function Game:draw()
   Push:start()

   local w, h = Push:getDimensions()
   for _,name in ipairs(self.order) do
      local layer = self.level.layers[name]
      if layer then
         local image = self.project.tilesets[layer.tilesetName].image
         layer.spatialhash:inSameCell(0, 0, w, h, render, image)
      else
         --print("Wrong layer", name)
      end
   end
   self.batches.background:draw()

   --[[
   self.worlds.game._hash:draw("line", false, false)

   local shapes = self.worlds.game._hash:shapes()
   for _, shape in pairs(shapes) do
      shape:draw("line")
   end

   ]]
   Push:finish()
end

Game:addSystem(S.playerController(), "fixedUpdate")
Game:addSystem(S.physics(), "fixedUpdate")
Game:addSystem(S.collisions(), "fixedUpdate")
Game:addSystem(S.spriteRenderer(), "draw")

Game:addEntity(Concord.entity()
   :assemble(A.player, Vector(100, 100))
)

Game:addEntity(Concord.entity()
   :assemble(A.player, Vector(20, 100))
   :remove(C.playerControls)
   :apply()
)

return Game
