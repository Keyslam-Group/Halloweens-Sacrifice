local shash = require("lib.hc.shash")
local json  = require("lib.json")

local Map = {}

local projectFile, levelFile, imageFile = 'assets/%s.gpgpproj', 'assets/%s.gpgp', 'assets/%s'

local errorNoFile      = 'couldn\'t locate the file %s'
local errorTileset     = 'tileset at index %i isn\'t a table'
local errorTilesetName = 'name of tileset at index %i isn\'t a string'
local errorImagePath   = 'imagePath of tileset %s isn\'t a string'
local errorImage       = 'couldn\'t locate image for tileset %s at path %s'

local info = {}
function Map.loadProject (file)
  file = projectFile:format(file)

  if not love.filesystem.getInfo(file, 'file', info) then
    error(errorNoFile:format(file), 2)
  end

  local project = json.decode(love.filesystem.read(file))

  if type(project.tileSize)    ~= 'number' then error('tileSize isn\'t a number',    2) end
  if type(project.maxMapWidth) ~= 'number' then error('maxMapWidth isn\'t a number', 2) end
  if type(project.tilesets)    ~= 'table'  then error('tilesets isn\'t an array',    2) end

  local tiles
  for i=#project.tilesets, 1, -1 do
    tiles, project.tilesets[i] = project.tilesets[i], nil

    if type(tiles) ~= 'table' then
      error(errorTileset:format(i), 2)
    elseif type(tiles.name) ~= 'string' then
      error(errorTilesetName:format(i), 2)
    elseif type(tiles.imagePath) ~= 'string' then
      error(errorImagePath:format(tiles.name), 2)
    elseif not love.filesystem.getInfo(imageFile:format(tiles.imagePath), 'file', info) then
      error(errorImage:format(tiles.name, tiles.imagePath), 2)
    end

    tiles.image = love.graphics.newImage(imageFile:format(tiles.imagePath))
    tiles.quads = {}

    project.tilesets[tiles.name] = tiles
  end

  return project
end

local function getQuad (project, name, x, y)
  local tiles = project.tilesets[name]

  local id = x + project.maxMapWidth * y

  if tiles.quads[id] then
    return tiles.quads[id]
  end

  tiles.quads[id] = love.graphics.newQuad(x * 16, y * 16, 16, 16, tiles.image)

  return tiles.quads[id]
end

local errorLayerName = 'name for layer %i isn\'t a string'
local errorLayerTileset = 'tilesetName for layer %s isn\'t a string'
local errorNoTileset = 'layer %s uses undefined tileset %s'
local errorItems = 'items for layer %s isn\'t a table'
local errorCoordinate = 'coordinate %s for item %i in layer %s isn\'t a number'
local errorTile = '%s tile coordinate for item %i in layer %s isn\'t a number'
local errorType = "the type for layer %s is neither Geometry nor Tile"

local function tileLayer (project, layer, state, item, k)
  if type(item.tileX) ~= 'number' then error(errorTile:format('X', k, layer.name), 2) end
  if type(item.tileY) ~= 'number' then error(errorTile:format('Y', k, layer.name), 2) end

  local quad = getQuad(project, layer.tilesetName, item.tileX, item.tileY)
  local x, y = item.x * 16, item.y * 16
  state.spatialhash:register(quad, x, y, x + 16, y + 16)
end

local function geometryLayer (_, _, state, item)
  state:rectangle(item.x * 16, item.y * 16, 16, 16)
end

function Map.loadLevel (file, project, hc)
  file = levelFile:format(file)

  if not love.filesystem.getInfo(file, 'file', info) then
    error(errorNoFile:format(file), 2)
  end

  local level = json.decode(love.filesystem.read(file))

  if type(level.layers) ~= 'table' then error('layers isn\'t a table', 2) end

  local layer
  for i=#level.layers, 1, -1 do
    layer, level.layers[i] = level.layers[i], nil

    if type(layer.name) ~= 'string' then error(errorLayerName:format(i), 2) end
    if type(layer.items) ~= 'table' then error(errorItems:format(layer.name), 2) end

    local state, layerFunction
    if layer.type == "Geometry" then
      state, layerFunction = hc, geometryLayer
    elseif layer.type == "Tile" then
      if type(layer.tilesetName) ~= 'string' then error(errorLayerTileset:format(layer.name), 2) end
      if not project.tilesets[layer.tilesetName] then error(errorNoTileset:format(layer.name, layer.tilesetName), 2) end

      local spatialhash = shash(project.tileSize)
      layer.spatialhash = spatialhash
      state, layerFunction = layer, tileLayer
    else
      error(errorType:format(layer.name),2)
    end

    for k, item in ipairs(layer.items) do
      if type(item.x) ~= 'number' then error(errorCoordinate:format('X', k, layer.name), 2) end
      if type(item.y) ~= 'number' then error(errorCoordinate:format('Y', k, layer.name), 2) end

      layerFunction(project, layer, state, item)
    end

    if layer.type == "Tile" then level.layers[layer.name] = state end
  end

  return level.layers
end

return Map
