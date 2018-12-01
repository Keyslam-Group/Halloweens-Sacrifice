--
-- shash.lua
--
-- Copyright (c) 2017 rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
local path = (...):gsub('%.[^%.]+$', '')
local pool  = require(path .. '.pool')
local class = require(path .. '.class')

local shash = class("Shash")

shash._version = '0.1.1'
local noop = function () end

function shash:initialize(cellsize)
  cellsize = cellsize or 64
  self.cellsize = cellsize
  self.cells = {}
  self.entities = {}

  return self
end

function shash:shapes ()
  local set = pool:pop()

  for obj in pairs(self.entities) do
    table.insert(set, obj)
  end

  return set
end

function shash:cellToKey(x, y) --luacheck: ignore unused self
  return x + y * 1e7
end

function shash:coordToCell(x, y)
  return math.floor(x / self.cellsize), math.floor(y / self.cellsize)
end

function shash:coordToKey(x, y)
  return self:cellToKey(self:coordToCell(x, y))
end

function shash:cellAt(x, y)
  return self.cells[self:coordToKey(x, y)]
end

local function each_overlapping_cell(self, e, fn, ...)
  local sx, sy = self:coordToCell(e[1], e[2])
  local ex, ey = self:coordToCell(e[3], e[4])
  for y = sy, ey do
    for x = sx, ex do
      local idx = self:cellToKey(x, y)
      fn(self, idx, ...)
    end
  end
end

local function add_entity_to_cell(self, idx, e)
  if not self.cells[idx] then
    self.cells[idx] = { e }
  else
    table.insert(self.cells[idx], e)
  end
end

local function remove_entity_from_cell(self, idx, e)
  local t = self.cells[idx]
  local n = #t
  -- Only one entity? Remove entity from cell and remove cell
  if n == 1 then
    self.cells[idx] = nil
    return
  end
  -- Find and swap-remove entity
  for i, v in ipairs(t) do
    if v == e then
      t[i] = t[n]
      t[n] = nil
      return
    end
  end
end

function shash:register(obj, x1, y1, x2, y2)
  -- Create entity. The table is used as an array as this offers a noticable
  -- performance increase on LuaJIT; the indices are as follows:
  -- [1] = left, [2] = top, [3] = right, [4] = bottom, [5] = object
  local e = { x1, y1, x2, y2, obj }
  -- Add to main entities table
  self.entities[obj] = e
  -- Add to cells
  each_overlapping_cell(self, e, add_entity_to_cell, e)
end

function shash:remove(obj)
  -- Get entity of obj
  local e = self.entities[obj]
  -- Remove from main entities table
  self.entities[obj] = nil
  -- Remove from cells
  each_overlapping_cell(self, e, remove_entity_from_cell, e)
end

function shash:update(obj, x1, y1, x2, y2)
  -- Get entity from obj
  local e = self.entities[obj]
  -- No width/height specified? Get width/height from existing bounding box
  x2 = x2 or x1 + e[3] - e[1]
  y2 = y2 or y1 + e[4] - e[2]
  -- Check the entity has actually changed cell-position, if it hasn't we don't
  -- need to touch the cells at all
  local ax1, ay1 = self:coordToCell(e[1], e[2])
  local ax2, ay2 = self:coordToCell(e[3], e[4])
  local bx1, by1 = self:coordToCell(x1, y1)
  local bx2, by2 = self:coordToCell(x2, y2)
  local dirty = ax1 ~= bx1 or ay1 ~= by1 or ax2 ~= bx2 or ay2 ~= by2
  -- Remove from old cells
  if dirty then
    each_overlapping_cell(self, e, remove_entity_from_cell, e)
  end
  -- Update entity
  e[1], e[2], e[3], e[4] = x1, y1, x2, y2
  -- Add to new cells
  if dirty then
    each_overlapping_cell(self, e, add_entity_to_cell, e)
  end
end

function shash:clear(hard)
  -- Clear all cells and entities
  if hard then
    self.cells = {}
    self.entities = {}
  else
    for k in pairs(self.cells) do
      self.cells[k] = nil
    end
    for k in pairs(self.entities) do
      self.entities[k] = nil
    end
  end
end

local function overlaps(e1, e2)
  return e1[3] > e2[1] and e1[1] < e2[3] and e1[4] > e2[2] and e1[2] < e2[4]
end

local function each_overlapping_in_cell(self, idx, e, set, fn, ...)
  fn = fn or noop
  local t = self.cells[idx]
  if not t then
    return
  end
  for _, v in ipairs(t) do
    if e ~= v and overlaps(e, v) and not set[v] then
      fn(e, v, ...)
      set[v] = true
    end
  end
end

local function each_in_same_cell(self, idx, e, set, fn, ...)
  fn = fn or noop
  local t = self.cells[idx]
  if not t then
    return
  end
  for _, v in ipairs(t) do
    if e ~= v and not set[v] then
      fn(e, v, ...)
      set[v] = true
    end
  end
end

function shash:overlapping(x, y, w, h, fn, ...)
  local e = self.entities[x]
  -- Init set for keeping track of which entities have already been handled
  local set = pool:pop()

  if e then
    -- Got object, use its entity
    each_overlapping_cell(self, e, each_overlapping_in_cell, e, set, y, w, h, fn, ...)
  else
    if type(x) == 'table' then print(x, unpack(x)) end
    -- Got bounding box, make temporary entity
    local temp = pool:pop()
    temp[1], temp[2], temp[3], temp[4] = x, y, x + w, y + h

    -- Do overlap checks
    each_overlapping_cell(self, temp, each_overlapping_in_cell, temp, set, fn, ...)

    -- Clear temp and return to pool
    pool:pushArray(temp, 4)
  end
end

function shash:inSameCell(x, y, w, h, fn, ...)
  -- Init set for keeping track of which entities have already been handled
  local set = pool:pop()
  local e = self.entities[x]

  if e then
    -- Got object, use its entity
    each_overlapping_cell(self, e, each_in_same_cell, e, set, y, w, h, fn, ...)
  else
    -- Got bounding box, make temporary entity
    local temp = pool:pop()
    temp[1], temp[2], temp[3], temp[4] = x, y, x + w, y + h

    each_overlapping_cell(self, temp, each_in_same_cell, e, set, fn, ...)

    -- Clear temp and return to pool
    pool:pushArray(temp, 4)
  end

  return set
end

function shash:info(opt, ...)
  if opt == 'cells' or opt == 'entities' then
    local n = 0
    for _ in pairs(self[opt]) do
      n = n + 1
    end
    return n
  end
  if opt == 'cell' then
    local t = self:cellAt(...)
    return t and #t or 0
  end
  error( string.format('invalid option "%s"', opt) )
end

return shash
