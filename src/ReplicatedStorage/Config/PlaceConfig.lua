-- src/ReplicatedStorage/Config/PlaceConfig.lua
--[[
    PlaceConfig - Multi-place detection system
    
    This module helps determine which place the code is running in:
    - Lobby (main hub)
    - Raid (boss instance)
    
    Usage:
        local PlaceConfig = require(ReplicatedStorage.Config.PlaceConfig)
        
        if PlaceConfig.IsLobby() then
            -- Load lobby-specific code
        elseif PlaceConfig.IsRaid() then
            -- Load raid-specific code
        end
]]

local PlaceConfig = {}

-- ⚠️ IMPORTANT: Replace these with your actual Place IDs after publishing
local PLACE_IDS = {
    -- Main lobby place
    Lobby = 110466149608687, -- TODO: Replace with actual Place ID
    
    -- Raid instance places (one per boss)
    Raids = {
        [114153096995810] = "Slick's Seven",    -- TODO: Replace with actual Place ID
        [0] = "LichKing",      -- TODO: Replace with actual Place ID
        [0] = "PhoenixLord",   -- TODO: Replace with actual Place ID
    }
}

-- Cache the current place type for performance
local currentPlaceType = nil

--[[
    Determines if the current place is the lobby
    
    Returns:
        boolean - True if in lobby, false otherwise
]]
function PlaceConfig.IsLobby()
    if currentPlaceType == "Lobby" then
        return true
    elseif currentPlaceType == "Raid" then
        return false
    end
    
    -- First time check
    local placeId = game.PlaceId
    if placeId == PLACE_IDS.Lobby then
        currentPlaceType = "Lobby"
        return true
    end
    
    currentPlaceType = "Unknown"
    return false
end

--[[
    Determines if the current place is a raid instance
    
    Returns:
        boolean - True if in raid, false otherwise
]]
function PlaceConfig.IsRaid()
    if currentPlaceType == "Raid" then
        return true
    elseif currentPlaceType == "Lobby" then
        return false
    end
    
    -- First time check
    local placeId = game.PlaceId
    if PLACE_IDS.Raids[placeId] then
        currentPlaceType = "Raid"
        return true
    end
    
    currentPlaceType = "Unknown"
    return false
end

--[[
    Gets the name of the current raid
    
    Returns:
        string | nil - Raid name (e.g. "DragonBoss") or nil if not in raid
]]
function PlaceConfig.GetRaidName()
    local placeId = game.PlaceId
    return PLACE_IDS.Raids[placeId]
end

--[[
    Gets the Place ID of the lobby
    
    Returns:
        number - Lobby Place ID
]]
function PlaceConfig.GetLobbyPlaceId()
    return PLACE_IDS.Lobby
end

--[[
    Gets the Place ID for a specific raid
    
    Parameters:
        raidName (string) - Name of the raid (e.g. "DragonBoss")
    
    Returns:
        number | nil - Place ID of the raid, or nil if not found
]]
function PlaceConfig.GetRaidPlaceId(raidName)
    for placeId, name in pairs(PLACE_IDS.Raids) do
        if name == raidName then
            return placeId
        end
    end
    return nil
end

--[[
    Gets a human-readable name for the current place
    
    Returns:
        string - Place name (e.g. "Lobby", "DragonBoss Raid", "Unknown")
]]
function PlaceConfig.GetPlaceName()
    if PlaceConfig.IsLobby() then
        return "Lobby"
    elseif PlaceConfig.IsRaid() then
        return PlaceConfig.GetRaidName() .. " Raid"
    else
        return "Unknown Place"
    end
end

-- Warn developers if Place IDs aren't configured
if game.PlaceId ~= 0 and PLACE_IDS.Lobby == 0 then
    warn("[PlaceConfig] Place IDs not configured! Please update PLACE_IDS in PlaceConfig.lua")
end

return PlaceConfig
