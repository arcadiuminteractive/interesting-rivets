-- src/StarterPlayer/StarterPlayerScripts/init.client.lua
--[[
    Client Bootstrap Script
    
    This is the entry point for all client-side code.
    It determines which place we're in (Lobby or Raid) and loads
    the appropriate controllers.
    
    Controller Loading Strategy:
    - _Core controllers: Always loaded (UIController, InputController, etc.)
    - _Lobby controllers: Only loaded in lobby (ShopController, TradeController, etc.)
    - _Raid controllers: Only loaded in raids (CombatController, VFXController, etc.)
    
    This conditional loading improves client performance and memory usage.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Wait for essential content
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if not playerGui then
    error("[Bootstrap] Failed to load PlayerGui")
end

-- Wait for ReplicatedStorage to be ready
if not ReplicatedStorage:FindFirstChild("Config") then
    ReplicatedStorage:WaitForChild("Config", 10)
end

-- Load the controller loader
local Loader = require(script.Parent.Loader)

print("╔════════════════════════════════════════╗")
print("║     CLIENT STARTING                    ║")
print("╚════════════════════════════════════════╝")

-- Determine which place we're in
local PlaceConfig = require(ReplicatedStorage.Config.PlaceConfig)
local placeName = PlaceConfig.GetPlaceName()
local isLobby = PlaceConfig.IsLobby()
local isRaid = PlaceConfig.IsRaid()

print(`[Bootstrap] Player: {player.Name}`)
print(`[Bootstrap] Place: {placeName}`)
print(`[Bootstrap] Place ID: {game.PlaceId}`)
print(`[Bootstrap] Is Lobby: {isLobby}`)
print(`[Bootstrap] Is Raid: {isRaid}`)

-- Define core controllers (always loaded in both places)
local coreControllers = {
    "UIController",         -- Main UI management
    "InputController",      -- Input binding & context
    "SoundController",      -- Sound pooling & playback
    "NetworkController",    -- Client-side network management
    "DataController",       -- Client-side data caching
}

-- Define place-specific controllers
local placeControllers = {}

if isLobby then
    -- Lobby-only controllers (shop, trading, inventory)
    placeControllers = {
        "InventoryController",         -- Inventory UI
        "TradeController",             -- Trading UI
        "LeaderboardController",       -- Leaderboard UI
        "RaidSelectionController",     -- Boss/difficulty selection
        "ShopController",              -- Cosmetic shop
        "BattlePassController",        -- Battle pass UI
        "CosmeticController",          -- Cosmetic preview/equip
        "LobbyMusicController",        -- Lobby ambient music
    }
    print("[Bootstrap] Loading LOBBY controllers...")
    
elseif isRaid then
    -- Raid-only controllers (combat, abilities, VFX)
    placeControllers = {
        "CombatController",            -- Client-side hit detection
        "AbilityController",           -- Ability input & prediction
        "VFXController",               -- VFX pooling & playback
        "CameraController",            -- Camera effects & shake
        "DraftController",             -- Ability draft UI
        "MindStateController",         -- MindState visual feedback
        "BossUIController",            -- Boss health bars & mechanics
        "RaidMusicController",         -- Dynamic raid music
    }
    print("[Bootstrap] Loading RAID controllers...")
    
else
    warn("[Bootstrap] ⚠️ Unknown place type! Only loading core controllers.")
end

-- Combine core + place-specific controllers
local allControllers = {}

-- Add core controllers
for _, controllerName in ipairs(coreControllers) do
    table.insert(allControllers, controllerName)
end

-- Add place-specific controllers
for _, controllerName in ipairs(placeControllers) do
    table.insert(allControllers, controllerName)
end

print(`[Bootstrap] Total controllers to load: {#allControllers}`)
print(`[Bootstrap] Core: {#coreControllers}, Place-specific: {#placeControllers}`)

-- Load all controllers using the Loader
Loader:LoadControllers(allControllers)

-- Print summary
print("╔════════════════════════════════════════╗")
print("║     CLIENT READY                       ║")
print("╚════════════════════════════════════════╝")
print(`[Bootstrap] ✓ Loaded {#allControllers} controllers`)
print(`[Bootstrap] ✓ Place: {placeName}`)
print(`[Bootstrap] ✓ Player: {player.Name}`)

-- Optional: Set up client analytics
if Loader:IsControllerLoaded("NetworkController") then
    local NetworkController = Loader:GetController("NetworkController")
    if NetworkController and NetworkController.SendClientReady then
        NetworkController:SendClientReady({
            PlaceName = placeName,
            PlaceId = game.PlaceId,
            ControllersLoaded = #allControllers,
            IsLobby = isLobby,
            IsRaid = isRaid,
        })
    end
end
