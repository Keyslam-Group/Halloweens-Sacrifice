local Concord = require("lib.concord")
local Shapes  = require("lib.hc.shapes")

local C = require("src.components")

local function collisionCallback(eShape, otherShape)
    local e = eShape.entity
    local other = otherShape.entity

    if other then
        local eDamage = e[C.damage]
        local otherHealth = other[C.health]

        if eDamage and otherHealth then
            local eTeam = e[C.team]
            local otherTeam = other[C.team]

            if eTeam and otherTeam then
                if eTeam.isFriendly ~= otherTeam.isFriendly then
                    otherHealth.health = otherHealth.health - eDamage.damage

                    if otherHealth.health <= 0 then
                        other:destroy()
                    end

                    e:destroy()
                end
            end
        end
    else
        e:destroy()
    end
end

return Concord.assemblage(function(e, position, velocity, friendly)
   e:give(C.transform, position, 0)
    :give(C.sprite, love.graphics.newQuad(5, 243, 6, 10, 320, 384), "main")
    :give(C.speed, velocity, 0.99)
    :give(C.collider, Shapes.CircleShape(position.x, position.y, 2), "game", collisionCallback)
    :give(C.team, friendly)
    :give(C.damage, 10)
end)
