local Concord = require("lib.concord")
local Vector  = require("lib.vector")
local HC      = require("lib.hc")
local Map     = require("lib.gpgploader")

local Batch   = require("src.classes.batch")

local C = require("src.components")
local S = require("src.systems")
local A = require("src.assemblages")

local Game = Concord.world()

Game.target = nil

Game.batches = {
   ["background"] = Batch(love.graphics.newImage("assets/tiles.png"), 1000, "dynamic"),
}

Game.worlds = {
   ["game"] = HC.new(100),
}

Game.project = Map.loadProject('map')
Game.layers  = Map.loadLevel('level', Game.project, Game.worlds["game"], Game)

Game.order = {
   "New tile layer",
   "foreground",
}

local camera = S.camera()
local playerController = S.playerController()
local particleRenderer = S.particleRenderer()
local enemySpawner = S.enemySpawner()

Game:addSystem(playerController, "wheelmoved")
Game:addSystem(playerController, "fixedUpdate")
Game:addSystem(S.enemyController(), "fixedUpdate")
Game:addSystem(S.physics(), "fixedUpdate")
Game:addSystem(particleRenderer, "fixedUpdate")
Game:addSystem(S.animationController(), "update")
Game:addSystem(enemySpawner, "update")
Game:addSystem(camera, "update")
Game:addSystem(camera, "draw", "start")
Game:addSystem(S.tilesRenderer(), "draw")
Game:addSystem(particleRenderer, "draw")
Game:addSystem(S.entityRenderer(), "draw")
Game:addSystem(S.healthRenderer(), "draw")
Game:addSystem(camera, "draw", "finish")
Game:addSystem(S.scoreRenderer(), "draw")

local Player = Concord.entity()
   :assemble(A.player, Vector(120, 100))

Game.target = Player
enemySpawner.target = Player

Game:addEntity(Player)

return Game
