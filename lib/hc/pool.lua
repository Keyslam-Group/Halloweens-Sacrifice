local Pool = {}

function Pool:pop ()
  return table.remove(self) or {}
end

function Pool:pushEmpty (empty)
  table.insert(self, empty)
end

function Pool:pushArray (t, n)
  for i = n or #t, 1, -1 do
    t[i] = nil
  end

  self:pushEmpty(t)
end

function Pool:pushTable (t)
  for k in pairs(t) do
    t[k] = nil
  end

  self:pushEmpty(t)
end

return setmetatable({}, {__mode = "v", __index = Pool})

