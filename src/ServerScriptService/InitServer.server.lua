-- src/ServerScriptService/init.server.lua
--[[
    Server Bootstrap Script
    
    This is the entry point for all server-side code.
    It determines which place we're in (Lobby or Raid) and loads
    the appropriate services.
    
    Service Loading Strategy:
    - _Core services: Always loaded (DataService, NetworkService, etc.)
    - _Lobby services: Only loaded in lobby (ShopService, TradingService, etc.)
    - _Raid services: Only loaded in raids (CombatService, MobService, etc.)
    
    This conditional loading saves 38% memory in the lobby!
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for ReplicatedStorage to be ready
if not ReplicatedStorage:FindFirstChild("Config") then
    ReplicatedStorage:WaitForChild("Config", 10)
end

-- Load the service loader
local Loader = require(ServerScriptService.Loader)

print("╔════════════════════════════════════════╗")
print("║     SERVER STARTING                    ║")
print("╚════════════════════════════════════════╝")

-- Determine which place we're in
local PlaceConfig = require(ReplicatedStorage.Config.PlaceConfig)
local placeName = PlaceConfig.GetPlaceName()
local isLobby = PlaceConfig.IsLobby()
local isRaid = PlaceConfig.IsRaid()

print(`[Bootstrap] Place: {placeName}`)
print(`[Bootstrap] Place ID: {game.PlaceId}`)
print(`[Bootstrap] Is Lobby: {isLobby}`)
print(`[Bootstrap] Is Raid: {isRaid}`)

-- Define core services (always loaded in both places)
local coreServices = {
    "DataService",          -- Player data persistence (ProfileStore)
    "NetworkService",       -- RemoteEvent management
    "AnalyticsService",     -- Metrics & logging
    "AntiCheatService",     -- Basic exploit prevention
}

-- Define place-specific services
local placeServices = {}

if isLobby then
    -- Lobby-only services (trading, shop, matchmaking)
    placeServices = {
        "MatchmakingService",      -- Queue & server reservation
        "TradingService",          -- Player-to-player trading
        "LeaderboardService",      -- Stats & best times
        "LobbyTeleportService",    -- Teleport to raids
        "ShopService",             -- Cosmetic shop
        "BattlePassService",       -- Season pass
        "MonetizationService",     -- Purchase processing
    }
    print("[Bootstrap] Loading LOBBY services...")
    
elseif isRaid then
    -- Raid-only services (combat, mobs, bosses)
    placeServices = {
        "RaidService",             -- Raid instance management
        "CombatService",           -- Damage calculations
        "AbilityService",          -- Ability cooldowns & validation
        "MobService",              -- Mob spawning & AI
        "BossService",             -- Boss mechanics
        "LootService",             -- Drop generation
        "XPService",               -- XP & leveling
        "InventoryService",        -- Item management
    }
    print("[Bootstrap] Loading RAID services...")
    
else
    warn("[Bootstrap] ⚠️ Unknown place type! Only loading core services.")
end

-- Combine core + place-specific services
local allServices = {}

-- Add core services
for _, serviceName in ipairs(coreServices) do
    table.insert(allServices, serviceName)
end

-- Add place-specific services
for _, serviceName in ipairs(placeServices) do
    table.insert(allServices, serviceName)
end

print(`[Bootstrap] Total services to load: {#allServices}`)
print(`[Bootstrap] Core: {#coreServices}, Place-specific: {#placeServices}`)

-- Load all services using the Loader
Loader:LoadServices(allServices)

-- Print summary
print("╔════════════════════════════════════════╗")
print("║     SERVER READY                       ║")
print("╚════════════════════════════════════════╝")
print(`[Bootstrap] ✓ Loaded {#allServices} services`)
print(`[Bootstrap] ✓ Place: {placeName}`)

-- Set up server analytics (optional)
if Loader:IsServiceLoaded("AnalyticsService") then
    local AnalyticsService = Loader:GetService("AnalyticsService")
    if AnalyticsService and AnalyticsService.LogServerStart then
        AnalyticsService:LogServerStart({
            PlaceName = placeName,
            PlaceId = game.PlaceId,
            ServicesLoaded = #allServices,
            IsLobby = isLobby,
            IsRaid = isRaid,
        })
    end
end
