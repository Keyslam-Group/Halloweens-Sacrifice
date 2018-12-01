local Concord = require("lib.concord")
local Vector  = require("lib.vector")
local HC      = require("lib.newhc")
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
Game.layers  = Map.loadLevel('level', Game.project, Game.worlds["game"])

Game.order = {
   "New tile layer",
   "foreground",
}

function Game:load()
   --print("Hey")
end

function Game:draw()
   --[[
   self.worlds.game._hash:draw("line", false, false)

   local shapes = self.worlds.game._hash:shapes()
   for _, shape in pairs(shapes) do
      shape:draw("line")
   end

   ]]
end

Game:addSystem(S.playerController(), "fixedUpdate")
Game:addSystem(S.physics(), "fixedUpdate")
Game:addSystem(S.collisions(), "fixedUpdate")
Game:addSystem(S.camera(), "draw", "start")
Game:addSystem(S.tilesRenderer(), "draw")
Game:addSystem(S.entityRenderer(), "draw")
Game:addSystem(S.camera(), "draw", "finish")

Game:addEntity(Concord.entity()
   :assemble(A.player, Vector(100, 100))
)

Game:addEntity(Concord.entity()
   :assemble(A.player, Vector(20, 100))
   :remove(C.playerControls)
   :apply()
)

return Game
