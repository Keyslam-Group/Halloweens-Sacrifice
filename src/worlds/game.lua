local Concord = require("lib.concord")
local Vector  = require("lib.vector")

local Batch = require("src.classes.batch")

local C = require("src.components")
local S = require("src.systems")

local Game = Concord.world()

Game.batches = {
	["background"] = Batch(love.graphics.newImage("assets/tiles.png"), 1000, "dynamic"),
}

function Game.batches.draw()
	Game.batches.background:draw()
end


Game:addSystem(S.spriteRenderer(), "draw")

local entity = Concord.entity()
entity:give(C.transform, Vector(100, 100), 0)
entity:give(C.sprite, love.graphics.newQuad(16, 16, 16, 16, 32, 32), "background")

Game:addEntity(entity)

return Game