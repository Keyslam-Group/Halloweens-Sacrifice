local _require = require
local function require(relativePath)
    return _require("src.components."..relativePath)
end

return {

}