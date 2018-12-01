--[[
Copyright (c) 2011 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local path   = ...
local class  = require(path .. '.class' )
local pool   = require(path .. '.pool'  )
local shash  = require(path .. '.shash' )
local Shapes = require(path .. '.shapes')

local newPolygonShape   = Shapes.newPolygonShape
local newCircleShape    = Shapes.newCircleShape
local newPointShape     = Shapes.newPointShape
local newRectangleShape = Shapes.newRectangleShape

local noop = function () end

local HC = class("HC")
function HC:initialize(cell_size)
  self:resetHash(cell_size)
end

function HC:hash() return self._hash end -- consistent interface with global HC instance

-- spatial hash management
function HC:resetHash(cellsize, hard)
  if self._hash and self._hash.cellsize == cellsize then
    shash:clear(hard)
  end
  self._hash = shash(cellsize or 100)
  return self
end

local new = {'move', 'rotate', 'scale'}
local old = {'__old_move', '__old_rotate', '__old_scale'}

function HC:register(shape)
  self._hash:register(shape, shape:bbox())

  -- keep track of where/how big the shape is
  for k, f in ipairs(new) do
    local old_function = shape[f]
    shape[f] = function(this, ...)
      old_function(this, ...)
      self._hash:update(this, this:bbox())
      return this
    end
    shape[old[k]] = old_function
  end

  return shape
end

function HC:remove(shape)
  self._hash:remove(shape)
  for k, f in ipairs(new) do
    shape[f] = shape[old[k]]
  end
  return self
end

-- shape constructors
function HC:polygon(...)
  return self:register(newPolygonShape(...))
end

function HC:rectangle(...)
  return self:register(newRectangleShape(...))
end

function HC:circle(x,y,r)
  return self:register(newCircleShape(x,y,r))
end

function HC:point(x,y)
  return self:register(newPointShape(x,y))
end

-- collision detection
function HC:neighbors(shape, fn, ...)
  local neighbors = self._hash:inSameCells(shape, fn, ...)
  return neighbors
end

local function collider (shape, other, set, fn, ...)
  local collides, dx, dy = shape[5]:collidesWith(other[5])

  if collides then
    if fn then
      fn(shape, other, dx, dy, ...)
    else
      local t = pool:pop()
      t.entity, t.x, t.y = other[5], dx, dy

      table.insert(set, t)
    end
  end
end

function HC:collisions(shape, fn, ...)
  local set = (not fn) and pool:pop() or nil

  self._hash:overlapping(shape, collider, set, fn, ...)

  return set
end

function HC:shapesAt(x, y)
  local candidates = pool:pop()
  local cell = self._hash:cellAt(x, y)

  if cell then
    for _, c in ipairs(cell) do
      if c[5]:contains(x, y) then
        table.insert(candidates, c[5])
      end
    end
  end

  return candidates
end

-- the class and the instance
local instance = HC()

-- the module
return setmetatable({
  new       = function(...) return HC(...) end,
  resetHash = function(...) return instance:resetHash(...) end,
  register  = function(...) return instance:register(...) end,
  remove    = function(...) return instance:remove(...) end,

  polygon   = function(...) return instance:polygon(...) end,
  rectangle = function(...) return instance:rectangle(...) end,
  circle    = function(...) return instance:circle(...) end,
  point     = function(...) return instance:point(...) end,

  neighbors  = function(...) return instance:neighbors(...) end,
  collisions = function(...) return instance:collisions(...) end,
  shapesAt   = function(...) return instance:shapesAt(...) end,
  hash       = function() return instance.hash() end,
}, {__call = function(self, ...) return self.new(...) end})
