-- src/ReplicatedStorage/Shared/Modules/CooldownManager.lua
local CooldownManager = {}
CooldownManager.__index = CooldownManager

function CooldownManager.new()
    local self = setmetatable({}, CooldownManager)
    self._cooldowns = {} -- [key] = readyTime
    return self
end

function CooldownManager:IsReady(key)
    local readyTime = self._cooldowns[key] or 0
    return tick() >= readyTime
end

function CooldownManager:SetCooldown(key, duration)
    self._cooldowns[key] = tick() + duration
end

function CooldownManager:GetRemaining(key)
    local readyTime = self._cooldowns[key] or 0
    return math.max(0, readyTime - tick())
end

function CooldownManager:Clear(key)
    self._cooldowns[key] = nil
end

return CooldownManager