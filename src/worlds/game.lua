local Concord = require("lib.concord")
local Vector  = require("lib.vector")
local HC      = require("lib.hc")
local Push    = require("lib.push")
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

function Game:load()

end

function Game:draw()
	Push:start()
	
	self.batches.background:draw()

	self.worlds.game._hash:draw("line", false, false)

	local shapes = self.worlds.game._hash:shapes()
	for _, shape in pairs(shapes) do
		shape:draw("line")
	end

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
	:assemble(A.player, Vector(10, 100))
	:remove(C.playerControls)
	:apply()
)

return Game