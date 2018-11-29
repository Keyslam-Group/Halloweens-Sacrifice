local _require = require
local function require(relativePath)
    return _require("src.assemblages."..relativePath)
end

return {

}