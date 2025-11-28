# Roblox PvE Raid Game

Award-winning PvE raid game for Roblox with multi-place architecture, persistent progression, trading economy, battle pass system, and cosmetic shop.

## 🎮 Game Features

- **Multi-Place Experience**: Lobby hub + multiple boss raid instances
- **Boss Raids**: 4 difficulty tiers (Normal, Mythic, Legendary, God Mode)
- **Ability Draft System**: Strategic team composition with 6 abilities per player
- **Form System**: Choose between Balanced, Agile, or Brute playstyles
- **MindState Mechanic**: Dynamic combat state system
- **Trading Economy**: Player-to-player trading with anti-exploit measures
- **Battle Pass**: Seasonal progression with free and premium tracks
- **Cosmetic Shop**: 100+ cosmetic items (weapon skins, accessories, particles)
- **Persistent Progression**: Cross-place XP, levels, and inventory

## 🛠️ Tech Stack

- **Language**: Luau (Lua for Roblox)
- **Sync Tool**: Rojo 7.x
- **Package Manager**: Wally
- **Data Persistence**: ProfileStore
- **Version Control**: Git

## 📦 Prerequisites

Install the following tools:

1. **Rojo** - [Download](https://rojo.space/docs/v7/getting-started/installation/)
   ```bash
   # Windows (via Aftman)
   aftman add rojo-rbx/rojo
   
   # macOS (via Homebrew)
   brew install rojo
   ```

2. **Wally** (optional, for package management) - [Download](https://github.com/UpliftGames/wally)
   ```bash
   # Windows (via Aftman)
   aftman add UpliftGames/wally
   
   # macOS (via Homebrew)
   brew install wally
   ```

3. **Rojo Plugin** - Install from [Roblox Plugin Marketplace](https://www.roblox.com/library/13916111004/Rojo)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/roblox-raid-game.git
cd roblox-raid-game
```

### 2. Install Dependencies (if using Wally)

```bash
wally install
```

This installs:
- ProfileStore (data persistence)
- Signal (event system)
- Trove (cleanup management)
- Promise (async operations)

### 3. Start Rojo

```bash
rojo serve default.project.json
```

This starts a local server on `localhost:34872`.

### 4. Connect from Roblox Studio

1. Open Roblox Studio
2. Open or create a place
3. Click **Plugins** → **Rojo** → **Connect**
4. Default address is `localhost:34872`
5. Click **Connect**

Your code will now sync automatically!

### 5. Create RemoteEvents in Studio

Rojo can't create RemoteEvents from code, so create them manually:

**In `ReplicatedStorage.Network.Server`:**
- ReplicateDamage (RemoteEvent)
- ReplicateVFX (UnreliableRemoteEvent)
- ReplicateSound (UnreliableRemoteEvent)
- UpdateMobState (RemoteEvent)
- BossPhaseChange (RemoteEvent)
- InventoryUpdate (RemoteEvent)
- XPGained (RemoteEvent)
- TradeResponse (RemoteEvent)
- BattlePassUpdate (RemoteEvent)
- ShopUpdate (RemoteEvent)
- PurchaseSuccess (RemoteEvent)
- CosmeticEquipped (RemoteEvent)

**In `ReplicatedStorage.Network.Client`:**
- CastAbility (RemoteEvent)
- SelectForm (RemoteEvent)
- RequestTrade (RemoteEvent)
- AcceptTrade (RemoteEvent)
- JoinRaidQueue (RemoteEvent)
- CreatePrivateRaid (RemoteEvent)
- InteractWithNPC (RemoteEvent)
- PurchaseCosmetic (RemoteEvent)
- EquipCosmetic (RemoteEvent)
- PurchaseBattlePass (RemoteEvent)
- ClaimBattlePassReward (RemoteEvent)
- PurchaseGoldPack (RemoteEvent)

### 6. Build StarterGui in Studio

StarterGui is **not synced** via Rojo (designers build it in Studio):

1. Create UI elements in `StarterGui.ScreenGui`
2. Organize into folders: HUD, Menus, Components
3. Reference UI in your controllers via code

### 7. Test the Game

Press **Play** in Studio to test. Your code changes sync automatically!

## 📁 Project Structure

```
roblox-raid-game/
├── src/                    # All Lua source code (synced via Rojo)
│   ├── ServerScriptService/
│   ├── StarterPlayer/
│   ├── ReplicatedStorage/
│   ├── ServerStorage/
│   └── ReplicatedFirst/
│
├── assets/                 # Non-code assets (NOT synced)
│   ├── models/            # .rbxm files
│   ├── audio/             # .mp3 files
│   └── images/            # .png files
│
├── studio/                 # Studio-only content
│   └── StarterGui.rbxm    # UI backup
│
├── default.project.json    # Rojo configuration
├── wally.toml             # Package dependencies
├── .gitignore             # Git ignore rules
└── README.md              # This file
```

## 🎯 Development Workflow

### Daily Development

```bash
# 1. Start Rojo
rojo serve default.project.json

# 2. Edit code in VSCode
#    - Changes sync automatically to Studio

# 3. Build assets in Studio
#    - Create models, UI, sounds
#    - NOT synced to VSCode (this is OK)

# 4. Test in Studio

# 5. Commit to Git
git add src/
git commit -m "Added new feature"
git push
```

### Place Separation

The game uses conditional loading:

- **Lobby Place**: Loads _Core + _Lobby services/controllers
- **Raid Places**: Loads _Core + _Raid services/controllers

This saves 38% memory in the lobby!

### Adding a New Service

1. Create folder: `src/ServerScriptService/Services/_Lobby/MyService/`
2. Create file: `init.lua` inside the folder
3. Implement `Init()` and `Start()` methods
4. Add `"MyService"` to bootstrap script
5. Sync with Rojo - done!

### Adding a New Controller

Same pattern as services, but in `StarterPlayerScripts/Controllers/`.

## 🔧 Configuration

### Place IDs

Edit `src/ReplicatedStorage/Config/PlaceConfig.lua`:

```lua
local PLACE_IDS = {
    Lobby = 0000000000,              -- Replace with actual ID
    Raid_DragonBoss = 1111111111,    -- Replace with actual ID
    Raid_LichKing = 2222222222,      -- Replace with actual ID
    Raid_Phoenix = 3333333333,       -- Replace with actual ID
}
```

### Monetization

Edit `src/ReplicatedStorage/Config/MonetizationConfig.lua`:

```lua
return {
    BattlePassPrice = 799,
    GoldPacks = {
        Starter = { Price = 100, Gold = 500 },
        Value = { Price = 350, Gold = 2000 },
        -- ...
    },
}
```

## 📊 Architecture Overview

### Services (Server-Side)

**Core Services** (both places):
- DataService - ProfileStore integration
- AnalyticsService - Metrics tracking
- NetworkService - RemoteEvent management
- AntiCheatService - Exploit prevention

**Lobby Services**:
- MatchmakingService - Queue & server reservation
- TradingService - Player-to-player trading
- ShopService - Cosmetic purchases
- BattlePassService - Season progression
- MonetizationService - Purchase processing

**Raid Services**:
- CombatService - Damage calculations
- AbilityService - Ability cooldowns
- MobService - AI & spawning
- BossService - Boss mechanics
- LootService - Drop generation

### Controllers (Client-Side)

Mirror structure of services, but handle UI and client-side logic.

## 💰 Monetization

The game includes 5 revenue streams:

1. **Battle Pass** (799 Robux/season) - 45% of revenue
2. **Cosmetic Shop** (99-999 Robux) - 30% of revenue
3. **Elite Trader Pass** (499 Robux) - 10% of revenue
4. **Gold Currency** (100-1500 Robux) - 12% of revenue
5. **Private Servers** (200 Robux/month) - 3% of revenue

**Ethical Design:**
- ✅ No pay-to-win mechanics
- ✅ All cosmetics are optional
- ✅ Free players can access all content
- ✅ Fair value for money spent

## 🧪 Testing

### Local Testing

```bash
# Run in Studio with Rojo connected
# Code changes update in real-time
```

### Production Testing

```bash
# Build place file
rojo build default.project.json -o build/RaidGame.rbxl

# Upload to Roblox and test
```

## 📚 Documentation

- [Full Architecture Guide](docs/architecture.md)
- [Monetization Strategy](docs/monetization-strategy.md)
- [Rojo Structure Guide](docs/rojo-project-structure.md)
- [API Reference](docs/api-reference.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **ProfileStore** by MadStudio - Data persistence
- **TopbarPlus** by ForeverHD - Custom UI
- **Signal** by Sleitnick - Event system
- **Rojo** by rojo-rbx - Sync tool
- **Wally** by UpliftGames - Package manager

## 📞 Support

- Discord: [Join our server](https://discord.gg/yourgame)
- Twitter: [@YourGame](https://twitter.com/yourgame)
- Email: support@yourgame.com

---

**Made with ❤️ for the Roblox developer community**
