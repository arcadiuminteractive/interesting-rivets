# Roblox PvE Raid Game - Rojo Project Structure

This document outlines the complete Rojo-compatible file structure for syncing your local codebase to Roblox Studio.

## 🎯 Rojo File Naming Conventions

**Critical Rules:**
- `init.lua` = ModuleScript (parent folder becomes the module)
- `init.server.lua` = Script (parent folder becomes the script)
- `init.client.lua` = LocalScript (parent folder becomes the script)
- `*.lua` = ModuleScript
- `*.server.lua` = Script
- `*.client.lua` = LocalScript

**Example:**
```
Services/
├── DataService/
│   └── init.lua          # Creates ModuleScript named "DataService"
└── MatchmakingService/
    └── init.lua          # Creates ModuleScript named "MatchmakingService"
```

---

## 📁 Complete Local File Structure

```
roblox-raid-game/                      # Root project directory
├── default.project.json               # Rojo project configuration
├── .gitignore                         # Git ignore file
├── README.md                          # Project documentation
│
├── src/                               # All Lua source code
│   ├── ServerScriptService/
│   │   ├── init.server.lua           # Bootstrap script
│   │   │
│   │   ├── Loader/
│   │   │   └── init.lua              # Service loader module
│   │   │
│   │   ├── Services/
│   │   │   ├── _Core/
│   │   │   │   ├── DataService/
│   │   │   │   │   └── init.lua
│   │   │   │   ├── AnalyticsService/
│   │   │   │   │   └── init.lua
│   │   │   │   ├── NetworkService/
│   │   │   │   │   └── init.lua
│   │   │   │   └── AntiCheatService/
│   │   │   │       └── init.lua
│   │   │   │
│   │   │   ├── _Lobby/
│   │   │   │   ├── MatchmakingService/
│   │   │   │   │   └── init.lua
│   │   │   │   ├── TradingService/
│   │   │   │   │   └── init.lua
│   │   │   │   ├── LeaderboardService/
│   │   │   │   │   └── init.lua
│   │   │   │   ├── LobbyTeleportService/
│   │   │   │   │   └── init.lua
│   │   │   │   ├── ShopService/
│   │   │   │   │   └── init.lua
│   │   │   │   ├── BattlePassService/
│   │   │   │   │   └── init.lua
│   │   │   │   └── MonetizationService/
│   │   │   │       └── init.lua
│   │   │   │
│   │   │   └── _Raid/
│   │   │       ├── RaidService/
│   │   │       │   └── init.lua
│   │   │       ├── CombatService/
│   │   │       │   └── init.lua
│   │   │       ├── AbilityService/
│   │   │       │   └── init.lua
│   │   │       ├── MobService/
│   │   │       │   └── init.lua
│   │   │       ├── BossService/
│   │   │       │   └── init.lua
│   │   │       ├── LootService/
│   │   │       │   └── init.lua
│   │   │       ├── XPService/
│   │   │       │   └── init.lua
│   │   │       └── InventoryService/
│   │   │           └── init.lua
│   │   │
│   │   └── Testing/
│   │       └── TestService.lua
│   │
│   ├── StarterPlayer/
│   │   ├── StarterCharacterScripts/
│   │   │   ├── AnimationController.client.lua
│   │   │   └── CosmeticAttacher.client.lua
│   │   │
│   │   └── StarterPlayerScripts/
│   │       ├── init.client.lua       # Bootstrap client
│   │       │
│   │       ├── Loader/
│   │       │   └── init.lua          # Controller loader module
│   │       │
│   │       ├── Controllers/
│   │       │   ├── _Core/
│   │       │   │   ├── UIController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── TopbarController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── InputController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── SoundController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── NetworkController/
│   │       │   │   │   └── init.lua
│   │       │   │   └── DataController/
│   │       │   │       └── init.lua
│   │       │   │
│   │       │   ├── _Lobby/
│   │       │   │   ├── InventoryController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── TradeController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── LeaderboardController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── RaidSelectionController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── ShopController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── BattlePassController/
│   │       │   │   │   └── init.lua
│   │       │   │   ├── CosmeticController/
│   │       │   │   │   └── init.lua
│   │       │   │   └── LobbyMusicController/
│   │       │   │       └── init.lua
│   │       │   │
│   │       │   └── _Raid/
│   │       │       ├── CombatController/
│   │       │       │   └── init.lua
│   │       │       ├── AbilityController/
│   │       │       │   └── init.lua
│   │       │       ├── VFXController/
│   │       │       │   └── init.lua
│   │       │       ├── CameraController/
│   │       │       │   └── init.lua
│   │       │       ├── DraftController/
│   │       │       │   └── init.lua
│   │       │       ├── MindStateController/
│   │       │       │   └── init.lua
│   │       │       ├── BossUIController/
│   │       │       │   └── init.lua
│   │       │       └── RaidMusicController/
│   │       │           └── init.lua
│   │       │
│   │       └── Modules/
│   │           ├── HitDetection.lua
│   │           ├── AbilityPredictor.lua
│   │           ├── InterpolationManager.lua
│   │           └── EffectPool.lua
│   │
│   ├── ReplicatedStorage/
│   │   ├── Packages/
│   │   │   └── _Index/                # Wally packages (if using)
│   │   │
│   │   ├── Shared/
│   │   │   ├── Modules/
│   │   │   │   ├── AbilityData.lua
│   │   │   │   ├── MobData.lua
│   │   │   │   ├── BossData.lua
│   │   │   │   ├── FormData.lua
│   │   │   │   ├── ItemData.lua
│   │   │   │   ├── CosmeticData.lua
│   │   │   │   ├── BattlePassData.lua
│   │   │   │   ├── ShopData.lua
│   │   │   │   ├── LootTables.lua
│   │   │   │   ├── XPCurve.lua
│   │   │   │   └── GameConstants.lua
│   │   │   │
│   │   │   ├── Utilities/
│   │   │   │   ├── TableUtil.lua
│   │   │   │   ├── MathUtil.lua
│   │   │   │   ├── StringUtil.lua
│   │   │   │   ├── UUIDGenerator.lua
│   │   │   │   └── AssetLoader.lua
│   │   │   │
│   │   │   └── Types.lua
│   │   │
│   │   ├── Network/
│   │   │   ├── Server/
│   │   │   │   └── init.lua          # Creates Server folder with RemoteEvents
│   │   │   └── Client/
│   │   │       └── init.lua          # Creates Client folder with RemoteEvents
│   │   │
│   │   └── Config/
│   │       ├── PlaceConfig.lua
│   │       ├── DifficultySettings.lua
│   │       ├── MonetizationConfig.lua
│   │       ├── SoundConfig.lua
│   │       └── DebugFlags.lua
│   │
│   ├── ServerStorage/
│   │   └── Configuration/
│   │       └── ServerConfig.lua
│   │
│   └── ReplicatedFirst/
│       └── LoadingManager.client.lua
│
├── assets/                            # Non-code assets (models, images, etc)
│   ├── models/                        # .rbxm or .fbx files
│   │   ├── weapons/
│   │   ├── cosmetics/
│   │   ├── mobs/
│   │   └── bosses/
│   │
│   ├── audio/                         # .mp3 or .ogg files
│   │   ├── music/
│   │   ├── sfx/
│   │   └── ui/
│   │
│   └── images/                        # .png files
│       ├── icons/
│       ├── ui/
│       └── thumbnails/
│
└── studio/                            # Studio-only content (not synced)
    └── StarterGui.rbxm                # UI built in Studio, exported for backup
```

---

## 📄 default.project.json

```json
{
  "name": "RaidGame",
  "tree": {
    "$className": "DataModel",

    "ReplicatedFirst": {
      "$className": "ReplicatedFirst",
      "$path": "src/ReplicatedFirst"
    },

    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      
      "Packages": {
        "$className": "Folder",
        "$path": "src/ReplicatedStorage/Packages"
      },

      "Shared": {
        "$className": "Folder",
        "$path": "src/ReplicatedStorage/Shared"
      },

      "Network": {
        "$className": "Folder",
        "$ignoreUnknownInstances": true,
        
        "Server": {
          "$className": "Folder",
          "$properties": {
            "Name": "Server"
          },
          "$ignoreUnknownInstances": true
        },
        
        "Client": {
          "$className": "Folder",
          "$properties": {
            "Name": "Client"
          },
          "$ignoreUnknownInstances": true
        }
      },

      "Config": {
        "$className": "Folder",
        "$path": "src/ReplicatedStorage/Config"
      },

      "Assets": {
        "$className": "Folder",
        "$ignoreUnknownInstances": true,
        "$properties": {
          "Name": "Assets"
        }
      }
    },

    "ServerScriptService": {
      "$className": "ServerScriptService",
      "$path": "src/ServerScriptService"
    },

    "ServerStorage": {
      "$className": "ServerStorage",
      "$path": "src/ServerStorage",
      
      "Templates": {
        "$className": "Folder",
        "$ignoreUnknownInstances": true,
        "$properties": {
          "Name": "Templates"
        }
      }
    },

    "StarterPlayer": {
      "$className": "StarterPlayer",
      
      "StarterCharacterScripts": {
        "$className": "StarterCharacterScripts",
        "$path": "src/StarterPlayer/StarterCharacterScripts"
      },
      
      "StarterPlayerScripts": {
        "$className": "StarterPlayerScripts",
        "$path": "src/StarterPlayer/StarterPlayerScripts"
      }
    },

    "StarterGui": {
      "$className": "StarterGui",
      "$ignoreUnknownInstances": true,
      "$properties": {
        "Name": "StarterGui"
      }
    },

    "Workspace": {
      "$className": "Workspace",
      "$properties": {
        "FilteringEnabled": true,
        "StreamingEnabled": true,
        "StreamingMinRadius": 64,
        "StreamingTargetRadius": 256
      },
      
      "Lobby": {
        "$className": "Folder",
        "$ignoreUnknownInstances": true,
        "$properties": {
          "Name": "Lobby"
        }
      },
      
      "Raid": {
        "$className": "Folder",
        "$ignoreUnknownInstances": true,
        "$properties": {
          "Name": "Raid"
        }
      },

      "MobSpawners": {
        "$className": "Folder",
        "$ignoreUnknownInstances": true,
        "$properties": {
          "Name": "MobSpawners"
        }
      }
    },

    "SoundService": {
      "$className": "SoundService",
      "$properties": {
        "AmbientReverb": "NoReverb",
        "DistanceFactor": 3.33,
        "DopplerScale": 1,
        "RolloffScale": 1
      },
      "$ignoreUnknownInstances": true
    },

    "Lighting": {
      "$className": "Lighting",
      "$properties": {
        "Ambient": [0, 0, 0],
        "Brightness": 2,
        "ColorShift_Bottom": [0, 0, 0],
        "ColorShift_Top": [0, 0, 0],
        "EnvironmentDiffuseScale": 0.5,
        "EnvironmentSpecularScale": 0.5,
        "GlobalShadows": true,
        "OutdoorAmbient": [70, 70, 70],
        "Technology": "ShadowMap"
      },
      "$ignoreUnknownInstances": true
    }
  }
}
```

---

## 🔧 Network Folder Setup

Since RemoteEvents/Functions can't be created from code in Rojo, you need to create them in Studio then mark them as ignored.

### Network/Server/init.lua
```lua
-- src/ReplicatedStorage/Network/Server/init.lua
-- This file is just a placeholder
-- Create your RemoteEvents in Studio under this folder:
--   - ReplicateDamage (RemoteEvent)
--   - ReplicateVFX (UnreliableRemoteEvent)
--   - ReplicateSound (UnreliableRemoteEvent)
--   - UpdateMobState (RemoteEvent)
--   - BossPhaseChange (RemoteEvent)
--   - InventoryUpdate (RemoteEvent)
--   - XPGained (RemoteEvent)
--   - TradeResponse (RemoteEvent)
--   - BattlePassUpdate (RemoteEvent)
--   - ShopUpdate (RemoteEvent)
--   - PurchaseSuccess (RemoteEvent)
--   - CosmeticEquipped (RemoteEvent)

return {}
```

### Network/Client/init.lua
```lua
-- src/ReplicatedStorage/Network/Client/init.lua
-- This file is just a placeholder
-- Create your RemoteEvents in Studio under this folder:
--   - CastAbility (RemoteEvent)
--   - SelectForm (RemoteEvent)
--   - RequestTrade (RemoteEvent)
--   - AcceptTrade (RemoteEvent)
--   - JoinRaidQueue (RemoteEvent)
--   - CreatePrivateRaid (RemoteEvent)
--   - InteractWithNPC (RemoteEvent)
--   - PurchaseCosmetic (RemoteEvent)
--   - EquipCosmetic (RemoteEvent)
--   - PurchaseBattlePass (RemoteEvent)
--   - ClaimBattlePassReward (RemoteEvent)
--   - PurchaseGoldPack (RemoteEvent)

return {}
```

**Workflow:**
1. Sync code with Rojo
2. In Studio, manually create RemoteEvents/UnreliableRemoteEvents in Network folders
3. `$ignoreUnknownInstances` prevents Rojo from deleting them
4. Reference them in code: `ReplicatedStorage.Network.Server.ReplicateDamage`

---

## 🎯 Service Template (with init.lua)

Each service should be in its own folder with an `init.lua`:

### Example: DataService/init.lua
```lua
-- src/ServerScriptService/Services/_Core/DataService/init.lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProfileStore = require(ReplicatedStorage.Packages.ProfileStore)

local DataService = {}

-- State
local Profiles = {}

-- Profile template
local PROFILE_TEMPLATE = {
    DataVersion = 1,
    Level = 1,
    XP = 0,
    Currencies = {
        Gold = 0,
        Gems = 0,
        RaidTokens = 0,
    },
    Inventory = {
        Weapons = {},
        Consumables = {},
        Cosmetics = {},
    },
    Equipment = {
        Weapon = nil,
    },
    BattlePass = {
        Season = 1,
        Level = 0,
        XP = 0,
        OwnsPremium = false,
        ClaimedRewards = {},
    },
    EquippedCosmetics = {
        WeaponSkin = nil,
        Cape = nil,
        Wings = nil,
        Pet = nil,
    },
    RaidProgress = {},
    TradeLog = {},
}

local PlayerDataStore = ProfileStore.New("PlayerData_v1", PROFILE_TEMPLATE)

-- PHASE 1: Initialize
function DataService:Init()
    print("[DataService] Initializing...")
    
    -- Set up player connections
    Players.PlayerAdded:Connect(function(player)
        self:_loadProfile(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        self:_unloadProfile(player)
    end)
end

-- PHASE 2: Start
function DataService:Start()
    print("[DataService] Starting...")
end

-- Load player profile
function DataService:_loadProfile(player)
    local profile = PlayerDataStore:StartSessionAsync(`Player_{player.UserId}`, {
        Cancel = function()
            return player:IsDescendantOf(Players) == false
        end
    })
    
    if profile then
        Profiles[player] = profile
        print(`[DataService] Loaded profile for {player.Name}`)
        
        -- Set up leaderstats
        self:_createLeaderstats(player, profile)
    else
        player:Kick("Failed to load data. Please rejoin.")
    end
end

-- Unload player profile
function DataService:_unloadProfile(player)
    local profile = Profiles[player]
    if profile then
        profile:EndSession()
        Profiles[player] = nil
        print(`[DataService] Unloaded profile for {player.Name}`)
    end
end

-- Get player profile
function DataService:GetProfile(player)
    return Profiles[player]
end

-- Create leaderstats
function DataService:_createLeaderstats(player, profile)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    
    local level = Instance.new("IntValue")
    level.Name = "Level"
    level.Value = profile.Data.Level
    level.Parent = leaderstats
    
    local gold = Instance.new("IntValue")
    gold.Name = "Gold"
    gold.Value = profile.Data.Currencies.Gold
    gold.Parent = leaderstats
    
    leaderstats.Parent = player
end

return DataService
```

---

## 🚀 Bootstrap Script Pattern

### ServerScriptService/init.server.lua
```lua
-- src/ServerScriptService/init.server.lua
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load the service loader
local Loader = require(ServerScriptService.Loader)

print("=== SERVER STARTING ===")

-- Determine which place we're in
local PlaceConfig = require(ReplicatedStorage.Config.PlaceConfig)
local placeName = PlaceConfig.GetPlaceName()
print(`Place: {placeName}`)

-- Core services (always loaded)
local coreServices = {
    "DataService",
    "AnalyticsService",
    "NetworkService",
    "AntiCheatService",
}

-- Place-specific services
local placeServices = {}

if PlaceConfig.IsLobby() then
    placeServices = {
        "MatchmakingService",
        "TradingService",
        "LeaderboardService",
        "LobbyTeleportService",
        "ShopService",
        "BattlePassService",
        "MonetizationService",
    }
elseif PlaceConfig.IsRaid() then
    placeServices = {
        "RaidService",
        "CombatService",
        "AbilityService",
        "MobService",
        "BossService",
        "LootService",
        "XPService",
        "InventoryService",
    }
end

-- Combine service lists
local allServices = {}
for _, service in ipairs(coreServices) do
    table.insert(allServices, service)
end
for _, service in ipairs(placeServices) do
    table.insert(allServices, service)
end

-- Load all services
Loader:LoadServices(allServices)

print("=== SERVER READY ===")
print(`Loaded {#allServices} services`)
```

### StarterPlayerScripts/init.client.lua
```lua
-- src/StarterPlayer/StarterPlayerScripts/init.client.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Wait for essential content
local player = Players.LocalPlayer
player:WaitForChild("PlayerGui")

-- Load the controller loader
local Loader = require(script.Loader)

print("=== CLIENT STARTING ===")

-- Determine which place we're in
local PlaceConfig = require(ReplicatedStorage.Config.PlaceConfig)
local placeName = PlaceConfig.GetPlaceName()
print(`Place: {placeName}`)

-- Core controllers (always loaded)
local coreControllers = {
    "UIController",
    "TopbarController",
    "InputController",
    "SoundController",
    "NetworkController",
    "DataController",
}

-- Place-specific controllers
local placeControllers = {}

if PlaceConfig.IsLobby() then
    placeControllers = {
        "InventoryController",
        "TradeController",
        "LeaderboardController",
        "RaidSelectionController",
        "ShopController",
        "BattlePassController",
        "CosmeticController",
        "LobbyMusicController",
    }
elseif PlaceConfig.IsRaid() then
    placeControllers = {
        "CombatController",
        "AbilityController",
        "VFXController",
        "CameraController",
        "DraftController",
        "MindStateController",
        "BossUIController",
        "RaidMusicController",
    }
end

-- Combine controller lists
local allControllers = {}
for _, controller in ipairs(coreControllers) do
    table.insert(allControllers, controller)
end
for _, controller in ipairs(placeControllers) do
    table.insert(allControllers, controller)
end

-- Load all controllers
Loader:LoadControllers(allControllers)

print("=== CLIENT READY ===")
print(`Loaded {#allControllers} controllers`)
```

---

## 🔄 Loader Implementation (with Folder Structure)

### ServerScriptService/Loader/init.lua
```lua
-- src/ServerScriptService/Loader/init.lua
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Loader = {}
local services = {}

-- Load services by name (searches all subfolders)
function Loader:LoadServices(serviceNames)
    local Services = ServerScriptService.Services
    
    -- PHASE 1: Require and Init
    print("[Loader] Phase 1: Initializing services...")
    for _, serviceName in serviceNames do
        local service = self:_requireService(Services, serviceName)
        if service then
            services[serviceName] = service
            if service.Init then
                local success, err = pcall(service.Init, service)
                if not success then
                    warn(`[Loader] Failed to init {serviceName}: {err}`)
                end
            end
        end
    end
    
    -- PHASE 2: Start
    print("[Loader] Phase 2: Starting services...")
    for serviceName, service in pairs(services) do
        if service.Start then
            task.spawn(function()
                local success, err = pcall(service.Start, service)
                if not success then
                    warn(`[Loader] Failed to start {serviceName}: {err}`)
                end
            end)
        end
    end
    
    print(`[Loader] Successfully loaded {#serviceNames} services!`)
end

-- Recursively search for service module
function Loader:_requireService(folder, serviceName)
    -- Check direct children
    local module = folder:FindFirstChild(serviceName)
    if module and module:IsA("ModuleScript") then
        local success, result = pcall(require, module)
        if success then
            return result
        else
            warn(`[Loader] Failed to require {serviceName}: {result}`)
            return nil
        end
    end
    
    -- Search subfolders
    for _, subfolder in folder:GetChildren() do
        if subfolder:IsA("Folder") then
            local result = self:_requireService(subfolder, serviceName)
            if result then
                return result
            end
        end
    end
    
    warn(`[Loader] Service not found: {serviceName}`)
    return nil
end

-- Get loaded service
function Loader:GetService(serviceName)
    return services[serviceName]
end

return Loader
```

### StarterPlayerScripts/Loader/init.lua
```lua
-- src/StarterPlayer/StarterPlayerScripts/Loader/init.lua
local Loader = {}
local controllers = {}

-- Load controllers by name (searches all subfolders)
function Loader:LoadControllers(controllerNames)
    local Controllers = script.Parent.Controllers
    
    -- PHASE 1: Require and Init
    print("[Loader] Phase 1: Initializing controllers...")
    for _, controllerName in controllerNames do
        local controller = self:_requireController(Controllers, controllerName)
        if controller then
            controllers[controllerName] = controller
            if controller.Init then
                local success, err = pcall(controller.Init, controller)
                if not success then
                    warn(`[Loader] Failed to init {controllerName}: {err}`)
                end
            end
        end
    end
    
    -- PHASE 2: Start
    print("[Loader] Phase 2: Starting controllers...")
    for controllerName, controller in pairs(controllers) do
        if controller.Start then
            task.spawn(function()
                local success, err = pcall(controller.Start, controller)
                if not success then
                    warn(`[Loader] Failed to start {controllerName}: {err}`)
                end
            end)
        end
    end
    
    print(`[Loader] Successfully loaded {#controllerNames} controllers!`)
end

-- Recursively search for controller module
function Loader:_requireController(folder, controllerName)
    -- Check direct children
    local module = folder:FindFirstChild(controllerName)
    if module and module:IsA("ModuleScript") then
        local success, result = pcall(require, module)
        if success then
            return result
        else
            warn(`[Loader] Failed to require {controllerName}: {result}`)
            return nil
        end
    end
    
    -- Search subfolders
    for _, subfolder in folder:GetChildren() do
        if subfolder:IsA("Folder") then
            local result = self:_requireController(subfolder, controllerName)
            if result then
                return result
            end
        end
    end
    
    warn(`[Loader] Controller not found: {controllerName}`)
    return nil
end

-- Get loaded controller
function Loader:GetController(controllerName)
    return controllers[controllerName]
end

return Loader
```

---

## 📦 Package Management

### Using Wally (Recommended)

Create `wally.toml` in project root:

```toml
[package]
name = "yourusername/raid-game"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
ProfileStore = "madstudioroblox/profilestore@2.0.7"
Signal = "sleitnick/signal@1.5.0"
Trove = "sleitnick/trove@0.5.0"
Promise = "evaera/promise@4.0.0"

[server-dependencies]

[dev-dependencies]
```

Install packages:
```bash
wally install
```

This creates `Packages/_Index` with all dependencies.

### Manual Package Installation

If not using Wally, place packages in `src/ReplicatedStorage/Packages/`:
- Download from Roblox marketplace or GitHub
- Place `.rbxm` or `.lua` files in Packages folder
- Require normally: `require(ReplicatedStorage.Packages.ProfileStore)`

---

## 🎨 Asset Management Strategy

### Assets in Rojo

**Problem:** Rojo doesn't handle binary assets (models, audio, images) well.

**Solution:** Hybrid approach

1. **Code in Rojo** - All `.lua` files synced
2. **Assets in Studio** - Built by designers, not synced
3. **Asset References in Code** - Use paths like `ReplicatedStorage.Assets.Cosmetics.WeaponSkins.Sword_Obsidian`

### Asset Workflow

```
Designer in Studio:
├── Import .fbx models → Convert to Roblox models
├── Apply textures and materials
├── Save to ReplicatedStorage.Assets
└── Test in-game

Developer in VSCode:
├── Reference assets by path in code
├── Sync code with Rojo
└── Assets remain untouched in Studio

Backup/Version Control:
├── Periodically export Assets folder as .rbxm
├── Store in studio/Assets-backup.rbxm
└── Can restore if needed
```

---

## ⚙️ .gitignore

Create `.gitignore` in project root:

```gitignore
# Roblox Studio files
*.rbxlx.lock
*.rbxl

# Rojo build artifacts
build/

# Wally packages (installed via wally install)
Packages/_Index/
Packages/

# OS files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo

# Temporary files
*.tmp
*.temp

# Logs
*.log
```

---

## 🚀 Workflow

### Daily Development Flow

```bash
# 1. Start Rojo in watch mode
rojo serve default.project.json

# 2. In Studio, connect to Rojo plugin (localhost:34872)

# 3. Edit code in VSCode
#    - Changes sync automatically to Studio
#    - See updates in real-time

# 4. Build assets in Studio
#    - Create models, UI, sounds
#    - Place in proper folders
#    - Not synced to VSCode (this is OK)

# 5. Test in Studio

# 6. Commit code to Git
git add src/
git commit -m "Added ShopService"
git push

# 7. Periodically backup assets
#    - Right-click ReplicatedStorage.Assets
#    - Export Selection
#    - Save to studio/Assets-backup.rbxm
#    - Commit to Git
```

### Building for Production

```bash
# Build place file
rojo build default.project.json -o build/RaidGame.rbxl

# Upload to Roblox
# Use Roblox Studio or Mantle plugin
```

---

## 🎯 Best Practices Summary

### Do's ✅
- Use `init.lua` for ModuleScripts in folders
- Use `init.server.lua` for Scripts in folders
- Use `init.client.lua` for LocalScripts in folders
- Keep all code in `src/` directory
- Use descriptive folder names (`_Core`, `_Lobby`, `_Raid`)
- Use `$ignoreUnknownInstances` for Studio-created content
- Backup assets periodically
- Use Wally for package management

### Don'ts ❌
- Don't sync binary assets through Rojo (use Studio)
- Don't create RemoteEvents in code (create in Studio)
- Don't nest `init.lua` files too deeply
- Don't use `-` or spaces in file/folder names
- Don't commit `Packages/_Index/` to Git
- Don't sync StarterGui (designers build in Studio)

---

## 📊 File Count Summary

**Total Synced Files:** ~120 Lua files
- ServerScriptService: ~25 files
- StarterPlayerScripts: ~30 files
- ReplicatedStorage: ~30 files
- ReplicatedFirst: ~1 file
- ServerStorage: ~5 files

**Studio-Only Content:**
- StarterGui: ~50 UI elements
- Assets: ~200+ models/sounds/images
- RemoteEvents: ~25 events

**Result:** Clean separation between code (synced) and assets (Studio-managed)

---

*Document Version 1.0 - Rojo Structure Guide*  
*Last Updated: November 2025*  
*Compatible with Rojo 7.x*
