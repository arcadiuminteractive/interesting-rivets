# Roblox PvE Raid Game Architecture Guide (2024-2025)

Building a multi-place PvE raid experience requires a careful balance of server authority, client-side responsiveness, and data persistence across places. **The most critical decisions are using ProfileStore over the deprecated ProfileService, implementing client-side VFX with server triggers, and adopting vanilla ModuleScripts over frameworks like Knit** which is no longer actively maintained. For your 30-player lobby scaling to 5-player raids, success hinges on proper RemoteEvent batching, object pooling, and strategic use of reserved servers for raid instances.

This architecture guide synthesizes current best practices from Roblox's official documentation and established community patterns, providing concrete implementation patterns for each major system your game requires.

---

## Client vs server responsibilities define your game's feel and security

The foundational rule for Roblox architecture is straightforward: **the server is authoritative for all game state, while the client handles visuals and input**. Getting this split wrong creates either exploitable games or laggy, unresponsive experiences.

**VFX and visual effects must run client-side**. The DevForum community consensus explicitly labels server-sided VFX as a "crime" due to dramatic server load increases, significant latency spikes, and poor visual smoothness. The correct pattern involves the server firing a RemoteEvent with position data, then each client locally instantiating and animating effects. Never create VFX instances on the server—only replicate the trigger data. However, hitboxes must remain server-authoritative regardless of VFX placement.

**Combat calculations require a hybrid approach** optimized for PvE. Client-side hit detection with server validation provides the best feel for players while maintaining security. The client detects hits and sends hit data (target, timestamp, attacker position) to the server. The server then performs sanity checks including distance validation with generous latency compensation (typically 1.5× the maximum attack range), cooldown verification, and action feasibility. Damage application happens exclusively on the server.

**Mob AI logic runs entirely server-side** but benefits from optimization techniques. AI decision-making, pathfinding computation, and movement commands stay on the server for authority. For visual smoothness with many mobs, client-side interpolation can enhance the appearance of movement without compromising security. When running 50+ mobs simultaneously, consider Parallel Lua with the Actor model for computationally intensive AI calculations.

| System | Location | Implementation Notes |
|--------|----------|---------------------|
| VFX | Client | Server triggers via RemoteEvent |
| UI | Client | Server sends data, client renders |
| Sound | Client | Use UnreliableRemoteEvent for triggers |
| Mob AI | Server | Parallel Lua for 100+ mobs |
| Hit Detection | Client + Server | Client detects, server validates |
| Damage/Cooldowns | Server | Authoritative, client can predict for UI |
| Boss Mechanics | Server | All state server-authoritative |

---

## RemoteEvents and network optimization for responsive gameplay

**UnreliableRemoteEvents, released March 2025, are ideal for your VFX and sound triggers**. They have lower overhead than standard RemoteEvents and are appropriate for non-critical visual feedback, particle effects, sound triggers, and continuous position updates. The tradeoff is a 900-byte maximum payload and no delivery guarantee under load—perfect for cosmetic effects where dropped packets are acceptable.

Rate limiting prevents exploiters from overwhelming your server. Implement server-side cooldowns using a simple pattern: store the last request time per player per remote, reject requests within the cooldown window, and use `task.spawn` to process valid requests in new threads preventing queue exhaustion. A **0.2-second cooldown** is reasonable for most combat actions.

Security validation must be comprehensive. Check data types explicitly (`typeof(arg1) ~= "number"`), validate string arguments against expected value lists, verify table sizes before iteration, and always confirm the player can actually perform the requested action. Never trust distance, damage, or inventory claims from the client.

**Network bandwidth management** becomes critical with 30 players. Roblox imposes a soft limit of **50 KB/s per player**, and exceeding this causes compounding latency. Self-limit to 25 KB/s to leave headroom for Roblox's internal replication. Batch property changes by unparenting models before bulk modifications and reparenting afterward for single replication events. Client-side properties like color changes, transparency animations, and rotating parts should never replicate.

---

## Parallel Lua enables massive mob counts when used correctly

Parallel Luau Version 2 provides Actor-based parallelism suitable for your raid's mob AI. The server has access to **2 usable worker threads**, while clients can leverage up to 8 depending on hardware. SharedTable enables data sharing between Actors without copying overhead.

**Actors benefit mob AI computation significantly** when you have 50+ enemies requiring pathfinding, targeting decisions, or complex behavior evaluation. Create Actor instances containing scripts that bind to parallel messages, perform heavy computation in the parallel context via `task.desynchronize()`, then return to serial context with `task.synchronize()` before modifying the DataModel.

The critical gotcha is overhead—splitting a 1ms task across 4 workers may actually take longer due to coordination costs. Reserve Parallel Lua for genuinely expensive operations like simultaneous pathfinding for dozens of mobs or complex targeting calculations. Simple state machine transitions don't benefit from parallelization.

Race conditions require careful handling. SharedTable modifications aren't atomic, so use `SharedTable:update("Value", function(v) return v + 1 end)` rather than direct assignment for increment operations. Modules required inside Actors return separate table instances, preventing data sharing via module-level variables.

---

## ProfileStore is the correct choice for new projects

**ProfileService is stable but explicitly deprecated—use ProfileStore for all new development**. The library's creator states unambiguously: "USE ProfileStore FOR NEW PROJECTS." ProfileStore reduces DataStore API calls by 10× (300-second auto-save versus 30-second) and uses MessagingService for faster session conflict resolution.

Your profile structure for a PvE raid game should separate concerns cleanly. Include a `DataVersion` field for migrations, group currencies in a dedicated table, use **UUID-based unique items** for anything tradeable, and maintain separate tables for stackable versus non-stackable inventory items. The UUID pattern is essential for trading—generate GUIDs via `HttpService:GenerateGUID(false)` and use these as keys in your inventory tables.

```lua
-- Recommended profile template structure
local PROFILE_TEMPLATE = {
    DataVersion = 1,
    Level = 1,
    XP = 0,
    Currencies = { Gold = 0, PremiumGems = 0, RaidTokens = 0 },
    Inventory = {
        Weapons = {},      -- {[UUID] = {ItemId, Level, Rarity, ...}}
        Consumables = {},  -- {[ItemId] = quantity} for stackables
    },
    Equipment = { Weapon = nil, Helmet = nil },
    RaidProgress = { CompletedRaids = {}, CurrentRaid = nil },
    TradeLog = {},  -- Keep last 50-100 for audit/rollback
}
```

**Trading requires atomic execution without yielding**. After confirming both profiles are active via `profile:IsActive()`, perform all inventory modifications immediately without any `task.wait()` calls between them. This prevents race conditions where one player disconnects mid-trade. Log every trade with timestamp, partner ID, items given, and items received for rollback capability.

Multi-place persistence works automatically because ProfileStore uses the same DataStore across all places in your universe. When teleporting from lobby to raid, call `profile:EndSession()` before initiating the teleport, wait briefly (0.5 seconds) for the save to complete, then execute the teleport. The raid server calls `StartSessionAsync` on player arrival and receives the same profile data.

---

## R6 vs R15 performance is a myth, but Humanoid optimization matters

**There is no meaningful performance difference between R6 and R15 at the Humanoid level**. Multiple DevForum benchmarks confirm the Humanoid instance performs identically regardless of rig type—R6 and R15 are purely aesthetic differences in body part count and joint configuration. Choose based on your art style, not performance expectations.

What actually matters is Humanoid optimization and whether to use Humanoids at all. For mobs under 100 count, standard Humanoids with disabled unused states work acceptably. Setting `humanoid.EvaluateStateMachine = false` eliminates internal state calculations while preserving clothing functionality. For 100-300 mobs, hybrid approaches using AnimationController without Humanoid become beneficial. Beyond 300 mobs, eliminate Humanoids entirely and use custom movement systems with server-side invisible parts and client-side visual models.

**PathfindingService is the primary performance bottleneck**, not animation or movement. After approximately 10-20 mobs with constant pathfinding, stuttering and stopping issues emerge. Mitigate this by recomputing paths only when targets move significantly (more than 5-10 studs), implementing path caching for common routes, increasing `WaypointSpacing` to reduce waypoint count, and using raycasts for line-of-sight checks to skip pathfinding when direct movement is viable.

| Optimization Level | Expected Mob Count | Implementation |
|-------------------|-------------------|----------------|
| Unoptimized | 50-100 | Default Humanoids with MoveTo |
| Basic | 150-200 | Disabled states, single controller script |
| Advanced | 300-500 | Client-side rendering, LOD system |
| Maximum | 1000-1500 | No humanoids, server attachments only |

Object pooling is mandatory for any game with frequent spawn/despawn cycles. Maintain pools of pre-created mob instances, reset their state when returning to the pool, and avoid `Instance.new()` and `:Destroy()` during active gameplay. Distance-based LOD should disable animations for mobs beyond 50 studs and potentially hide or despawn mobs beyond 150 studs.

---

## Multi-place architecture requires reserved servers and careful data handling

**TeleportAsync is the unified teleportation method**—all legacy methods are deprecated. For raid instances, use `TeleportOptions.ShouldReserveServer = true` to create isolated servers where only players with the access code can join. Store the access code for latecomer support and reconnection scenarios.

The critical pattern for lobby-to-raid teleportation involves saving data before initiating the teleport. **PlayerRemoving does NOT fire before teleport completion**, so you must explicitly call your data save function, wait for confirmation, then execute `TeleportAsync`. Wrap teleport calls in pcall and implement retry logic with exponential backoff for transient failures.

```lua
-- Teleport pattern with data safety
local function teleportToRaid(players, raidPlaceId)
    for _, player in players do
        local profile = Profiles[player]
        if profile and profile:IsActive() then
            profile:EndSession()  -- Triggers save
        end
    end
    task.wait(0.5)  -- Allow save completion
    
    local options = Instance.new("TeleportOptions")
    options.ShouldReserveServer = true
    options:SetTeleportData({raidId = raidId, partyLeader = players[1].UserId})
    
    TeleportService:TeleportAsync(raidPlaceId, players, options)
end
```

**Matchmaking across servers requires MemoryStoreService and MessagingService coordination**. Use a MemoryStoreService SortedMap as your queue, storing player data with 5-minute expiration. One server acts as the matchmaking host, polling the queue and reserving servers when complete matches form. Use MessagingService to broadcast teleport instructions to all lobby servers when a match is ready, ensuring party members on different servers receive their access codes simultaneously.

TeleportData has a critical security limitation: **it can be spoofed by exploiters**. Never include currency, inventory data, or authentication information in TeleportData. Use it only for non-sensitive context like raid ID or difficulty selection, and always verify critical information via DataStore on the destination server.

---

## Vanilla ModuleScripts outperform frameworks for modern development

**Knit is no longer recommended for new projects** despite its widespread adoption. The framework's creator, Sleitnick, explicitly states: "I do not see a future where the current version of Knit should be recommended." The primary issues are lack of IntelliSense support (services retrieved from generic tables lose type information), incompatibility with Parallel Luau's requirements, conflicts with modern UI frameworks like React-lua and Fusion, and the framework has stopped receiving updates.

The recommended approach is vanilla ModuleScripts with RbxUtil's utility modules. Use Sleitnick's `Loader` module for bootstrapping with lifecycle methods, `Net` or `Comm` for networking abstractions, `Signal` for custom events, and `Trove` for cleanup patterns. This provides full IntelliSense support, maximum flexibility, and no framework lock-in.

Organize your codebase with clear separation: ReplicatedStorage holds shared modules and assets accessible to both client and server, ServerScriptService contains server-only services and modules, StarterPlayerScripts houses client controllers, and ServerStorage stores server-only assets and templates. Implement a two-phase initialization pattern where `Init()` sets up internal references without cross-service calls, followed by `Start()` where inter-service communication is safe.

**Event-driven architecture using custom Signal classes** enables clean system communication. Your combat system fires `OnDamageDealt` and `OnEntityDeath` events that other systems subscribe to—the loot system spawns drops, the quest system checks kill objectives, and the statistics system records data, all without tight coupling between modules.

---

## Performance optimization for 30-player lobbies

**StreamingEnabled is essential** for any game with significant world content. Configure `StreamingMinRadius` to 64-128 studs for guaranteed content and `StreamingTargetRadius` to 256-512 studs for the loading target. Use `ModelStreamingMode.Persistent` sparingly—only for truly critical objects—as overuse negates streaming benefits. Client code must use `WaitForChild()` with timeouts for any potentially streamed instances.

Object pooling for VFX prevents garbage collection spikes during intense combat. Maintain pools of pre-instantiated effect prefabs, disable and reposition them off-screen when returning to pool, and enable/emit when spawning. The same pattern applies to sounds—pool Sound instances, reattach to new positions via Attachments, and return to pool on `Ended` events.

**ParticleEmitter optimization** focuses on minimizing active particle count. The performance cost equals emission rate multiplied by lifetime, so prefer lower emission rates with burst spawns via `:Emit(count)`. Disable emitters before destruction to prevent lingering particles, and remember that particles beyond approximately 500 studs don't render regardless of settings.

Network traffic management in high-player-count scenarios requires batching updates, using UnreliableRemoteEvents for cosmetic synchronization, and client-side rendering for non-authoritative elements. Set server network ownership explicitly for NPCs and physics objects that shouldn't be client-controlled. Target frame times under **16.67ms** for 60 FPS, server heartbeat under **12ms**, and ping under **100ms** for responsive gameplay.

---

## TopbarPlus v3.4.0 provides robust custom UI integration

TopbarPlus received a complete rewrite in v3 (April 2024) with continued updates through 2025. The library provides full PC, mobile, tablet, and gamepad support with automatic overflow handling and state management.

Implementation uses method chaining for clean configuration. Create icons with `Icon.new()`, chain `:setImage()`, `:setLabel()`, and `:setOrder()` for appearance, bind events for `selected` and `deselected` states to toggle UI visibility, and use `:setDropdown()` for menu hierarchies. The library handles topbar style changes automatically, supporting both legacy and modern Roblox topbar appearances.

For your raid game, create icons for Shop, Inventory, Party, and Settings. Bind the Party icon to your matchmaking queue interface, toggle raid-specific icons based on current place (lobby vs raid instance), and use dropdown menus for organized access to subsystems.

---

## Conclusion

The architecture decisions with highest impact for your PvE raid game are choosing **ProfileStore over ProfileService** for data persistence with proper UUID-based item tracking, implementing **client-side VFX with server triggers** for responsive visual feedback, using **vanilla ModuleScripts over Knit** for maintainability and IntelliSense support, and deploying **reserved servers for raid instances** with MessagingService-coordinated matchmaking.

Mob AI scales effectively to 150-200 enemies with basic optimization (disabled Humanoid states, single controller script, staggered pathfinding), and to 500+ with aggressive optimization eliminating Humanoids entirely. The R6 vs R15 debate is settled—choose based on aesthetics, as performance is identical.

For your 30-player lobbies, enable StreamingEnabled, implement object pooling for all frequently spawned content, batch network updates, and leverage UnreliableRemoteEvents for cosmetic synchronization. Monitor performance via MicroProfiler with frame time targets under 16.67ms and server heartbeat under 12ms.

The multi-place architecture pattern of lobby → reserved raid server with ProfileStore session management provides clean data continuity. Save profiles before teleport initiation, use MessagingService to coordinate cross-server party teleports, and never trust TeleportData for sensitive information.