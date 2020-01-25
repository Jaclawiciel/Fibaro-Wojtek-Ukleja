--[[
%% autostart
%% properties
%% events
%% globals
isWojtekHome
--]]

-- ************ BEGIN configuration block ************
local USER_VAR_NAME = "isWojekHome"
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

local trigger = fibaro:getSourceTrigger()
local triggerType = trigger["type"]
local triggerDeviceId = trigger["deviceID"]
local triggerProperty = trigger["propertyName"]
local triggerVarName = trigger["varName"]
fibaro:debug("Scene started by "..triggerType)

local isUserHome = getGlobalValue(USER_VAR_NAME)

if isUserHome then
    fibaro:debug("User is home")
--    TUTAJ WSTAW IF, KTÓRY SPRAWDZI CZY ŚWIATŁO NIE JEST ZAPALONE
--    JEŚLI NIE JEST ZAPALONE TO ZAPAL
--    JEŚLO JEST ZAPALONE TO NIC NIE RÓB
else
    fibaro:debug("User is away")
--    TUTAJ WSTAW IF, KTÓRY SPRAWDZI CZY ŚWIATŁO JEST ZAPALONE
--    JEŚLI JEST ZAPALONE TO ZGAŚ
--    JEŚLI NIE JEST ZAPALONE TO NIC NIE RÓB
end

fibaro:debug("END")
-- ************ END code block ************
