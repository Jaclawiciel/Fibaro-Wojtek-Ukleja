----
-- Fibaro - Wojciech Ukleja
-- Presence - VD - Presence button
-- Date: 07/01/2020
-- Time: 19:35
--
-- Created by: Jacek Gałka | http://jacekgalka.pl/en
----

-- ************ BEGIN configuration block ************
local USER_NAME = "Wojtek"
-- ************ END configuration block ************

-- ************ BEGIN helper functions ************
function getGlobalValue(varName)
    local value = fibaro:getGlobalValue(varName)
    if value == "true" then
        return true
    elseif value == "false" then
        return false
    elseif type(tonumber(value)) == "number" then
        return tonumber(value)
    else
        return value
    end
end
-- ************ END helper functions ************

-- ************ BEGIN code block ************
fibaro:debug("START")

local userVarName = "is"..USER_NAME.."Home"
local isUserHome = getGlobalValue(userVarName)
fibaro:debug("Obecna wartosc "..userVarName..": "..tostring(isUserHome))
if isUserHome then
    fibaro:debug("Ustawiam "..userVarName..": na false")
    fibaro:setGlobal(userVarName, false)
else
    fibaro:debug("Ustawiam "..userVarName..": na true")
    fibaro:setGlobal(userVarName, true)
end
fibaro:debug("Nowa wartosc "..userVarName..": "..tostring(getGlobalValue(userVarName)))

fibaro:debug("END")
-- ************ END code block ************
