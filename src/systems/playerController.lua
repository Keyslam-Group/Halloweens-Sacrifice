local Concord = require("lib.concord")
local Vector  = require("lib.vector")

local C = require("src.components")
local A = require("src.assemblages")

local PlayerController = Concord.system({C.transform, C.playerControls})

function PlayerController:fixedUpdate(dt)
	local world = self:getWorld()

	for _, e in ipairs(self.pool) do
		local transform      = e[C.transform]
		local playerControls = e[C.playerControls]

		local controller = playerControls.controller

		controller:update()

		local x, y = controller:get("move")
		transform.position.x = transform.position.x + x * 100 * dt
		transform.position.y = transform.position.y + y * 100 * dt

		if controller:pressed("shoot") then
			local target = Vector(love.mouse.getX(), love.mouse.getY())
			local direction = target - transform.position
			direction:normalizeInplace()

			world:addEntity(Concord.entity()
				:assemble(A.bullet, transform.position:clone(), direction * 300)
			)
		end
	end
end

return PlayerController