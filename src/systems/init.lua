local _require = require
local function require(relativePath)
    return _require("src.systems."..relativePath)
end

return {

}