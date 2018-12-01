local Class = require("lib.class")

local Batch = Class("Batch")

function Batch:initialize(texture, maxSprites, usage)
	self.batch = love.graphics.newSpriteBatch(texture, maxSprites, usage)
	self.open  = {}

	for i = 1, maxSprites do
		self.open[i] = i
		self.batch:add(nil, nil, nil, 0, 0)
	end
end

function Batch:add(...)
	local id = self.open[#self.open]
	self.open[id] = nil

	self.batch:set(id, ...)

	return id
end

function Batch:set(id, ...)
	self.batch:set(id, ...)
end

function Batch:remove(id)
	self.open[#self.open + 1] = id
	self.batch:set(id, nil, nil, nil, 0, 0)
end

function Batch:draw(...)
	love.graphics.draw(self.batch, ...)
end

return Batch