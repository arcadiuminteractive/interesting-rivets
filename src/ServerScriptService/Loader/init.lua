-- src/ServerScriptService/Loader/init.lua
--[[
    Loader - Server-side service loader with two-phase initialization
    
    Loads services in two phases:
    1. Init() - Set up internal state, no cross-service calls
    2. Start() - Begin operations, cross-service communication is safe
    
    This pattern prevents race conditions and ensures all services
    are initialized before any service tries to communicate with another.
    
    Usage:
        local Loader = require(ServerScriptService.Loader)
        
        Loader:LoadServices({
            "DataService",
            "CombatService",
            "MobService"
        })
        
        -- Later, get a loaded service
        local DataService = Loader:GetService("DataService")
]]

local ServerScriptService = game:GetService("ServerScriptService")

local Loader = {}
local loadedServices = {}

--[[
    Loads services by name using two-phase initialization
    
    Parameters:
        serviceNames (table) - Array of service names to load
    
    Example:
        Loader:LoadServices({"DataService", "CombatService"})
]]
function Loader:LoadServices(serviceNames)
    local Services = ServerScriptService.Services
    
    -- PHASE 1: Require all services and call Init()
    print("[Loader] ========================================")
    print("[Loader] Phase 1: Initializing services...")
    print("[Loader] ========================================")
    
    for _, serviceName in ipairs(serviceNames) do
        local service = self:_requireService(Services, serviceName)
        
        if service then
            loadedServices[serviceName] = service
            
            if service.Init then
                local success, err = pcall(service.Init, service)
                if success then
                    print(`[Loader] ✓ {serviceName} initialized`)
                else
                    warn(`[Loader] ✗ Failed to init {serviceName}: {err}`)
                end
            else
                print(`[Loader] ⚠ {serviceName} has no Init() method`)
            end
        end
    end
    
    -- Small delay to ensure all Init() calls complete
    task.wait(0.1)
    
    -- PHASE 2: Call Start() on all services
    print("[Loader] ========================================")
    print("[Loader] Phase 2: Starting services...")
    print("[Loader] ========================================")
    
    for serviceName, service in pairs(loadedServices) do
        if service.Start then
            task.spawn(function()
                local success, err = pcall(service.Start, service)
                if success then
                    print(`[Loader] ✓ {serviceName} started`)
                else
                    warn(`[Loader] ✗ Failed to start {serviceName}: {err}`)
                end
            end)
        else
            print(`[Loader] ⚠ {serviceName} has no Start() method`)
        end
    end
    
    print("[Loader] ========================================")
    print(`[Loader] ✓ Successfully loaded {#serviceNames} services`)
    print("[Loader] ========================================")
end

--[[
    Recursively searches for a service module by name
    
    Parameters:
        folder (Instance) - Folder to search in
        serviceName (string) - Name of the service to find
    
    Returns:
        table | nil - The required service module, or nil if not found
]]
function Loader:_requireService(folder, serviceName)
    -- Check direct children first
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
    
    -- Search subfolders (_Core, _Lobby, _Raid)
    for _, subfolder in folder:GetChildren() do
        if subfolder:IsA("Folder") then
            local result = self:_requireService(subfolder, serviceName)
            if result then
                return result
            end
        end
    end
    
    -- Not found
    warn(`[Loader] ✗ Service not found: {serviceName}`)
    return nil
end

--[[
    Gets a loaded service by name
    
    Parameters:
        serviceName (string) - Name of the service
    
    Returns:
        table | nil - The service module, or nil if not loaded
    
    Example:
        local DataService = Loader:GetService("DataService")
]]
function Loader:GetService(serviceName)
    local service = loadedServices[serviceName]
    if not service then
        warn(`[Loader] Service not loaded: {serviceName}`)
    end
    return service
end

--[[
    Checks if a service is loaded
    
    Parameters:
        serviceName (string) - Name of the service
    
    Returns:
        boolean - True if loaded, false otherwise
]]
function Loader:IsServiceLoaded(serviceName)
    return loadedServices[serviceName] ~= nil
end

--[[
    Gets all loaded service names
    
    Returns:
        table - Array of loaded service names
]]
function Loader:GetLoadedServices()
    local names = {}
    for serviceName in pairs(loadedServices) do
        table.insert(names, serviceName)
    end
    return names
end

return Loader