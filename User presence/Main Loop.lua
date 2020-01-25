----
-- Fibaro - Wojciech Ukleja
-- Presence - VD - Main Loop
-- Date: 07/01/2020
-- Time: 19:35
--
-- Created by: Jacek Gałka | http://jacekgalka.pl/en
----

-- ************ BEGIN configuration block ************
local USER_NAME = "Wojtek" -- imię usera
local ICON_IDS = {
    home = 1011, -- USTAW TUTAJ SWOJE ID IKONY W DOMU
    away = 1012 -- USTAW TUTAJ SWOJE ID IKONY POZA DOMEM
}
local LABELS = {
    home = "w domu 🏠",
    away = "poza domem"
}
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
if isUserHome then
    fibaro:debug("Ustawiam etykietę i ikonę pod wartość true")
    fibaro:call(fibaro:getSelfId(), "setProperty", "ui.presenceStateLabel.value", LABELS.home)
    fibaro:call(fibaro:getSelfId(), "setProperty", "currentIcon", ICON_IDS.home)
else
    fibaro:debug("Ustawiam etykietę i ikonę pod wartość false")
    fibaro:call(fibaro:getSelfId(), "setProperty", "ui.presenceStateLabel.value", LABELS.away)
    fibaro:call(fibaro:getSelfId(), "setProperty", "currentIcon", ICON_IDS.away)
end

fibaro:debug("END")
-- ************ END code block ************
