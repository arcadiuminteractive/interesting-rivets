-- src/StarterPlayer/StarterPlayerScripts/Loader/init.lua
--[[
    Loader - Client-side controller loader with two-phase initialization
    
    Loads controllers in two phases:
    1. Init() - Set up internal state, UI references, no cross-controller calls
    2. Start() - Begin operations, bind events, cross-controller communication is safe
    
    This pattern prevents race conditions and ensures all controllers
    are initialized before any controller tries to communicate with another.
    
    Usage:
        local Loader = require(script.Parent.Loader)
        
        Loader:LoadControllers({
            "UIController",
            "CombatController",
            "VFXController"
        })
        
        -- Later, get a loaded controller
        local UIController = Loader:GetController("UIController")
]]

local Loader = {}
local loadedControllers = {}

--[[
    Loads controllers by name using two-phase initialization
    
    Parameters:
        controllerNames (table) - Array of controller names to load
    
    Example:
        Loader:LoadControllers({"UIController", "CombatController"})
]]
function Loader:LoadControllers(controllerNames)
    local Controllers = script.Parent.Controllers
    
    -- PHASE 1: Require all controllers and call Init()
    print("[Loader] ========================================")
    print("[Loader] Phase 1: Initializing controllers...")
    print("[Loader] ========================================")
    
    for _, controllerName in ipairs(controllerNames) do
        local controller = self:_requireController(Controllers, controllerName)
        
        if controller then
            loadedControllers[controllerName] = controller
            
            if controller.Init then
                local success, err = pcall(controller.Init, controller)
                if success then
                    print(`[Loader] ✓ {controllerName} initialized`)
                else
                    warn(`[Loader] ✗ Failed to init {controllerName}: {err}`)
                end
            else
                print(`[Loader] ⚠ {controllerName} has no Init() method`)
            end
        end
    end
    
    -- Small delay to ensure all Init() calls complete
    task.wait(0.1)
    
    -- PHASE 2: Call Start() on all controllers
    print("[Loader] ========================================")
    print("[Loader] Phase 2: Starting controllers...")
    print("[Loader] ========================================")
    
    for controllerName, controller in pairs(loadedControllers) do
        if controller.Start then
            task.spawn(function()
                local success, err = pcall(controller.Start, controller)
                if success then
                    print(`[Loader] ✓ {controllerName} started`)
                else
                    warn(`[Loader] ✗ Failed to start {controllerName}: {err}`)
                end
            end)
        else
            print(`[Loader] ⚠ {controllerName} has no Start() method`)
        end
    end
    
    print("[Loader] ========================================")
    print(`[Loader] ✓ Successfully loaded {#controllerNames} controllers`)
    print("[Loader] ========================================")
end

--[[
    Recursively searches for a controller module by name
    
    Parameters:
        folder (Instance) - Folder to search in
        controllerName (string) - Name of the controller to find
    
    Returns:
        table | nil - The required controller module, or nil if not found
]]
function Loader:_requireController(folder, controllerName)
    -- Check direct children first
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
    
    -- Search subfolders (_Core, _Lobby, _Raid)
    for _, subfolder in folder:GetChildren() do
        if subfolder:IsA("Folder") then
            local result = self:_requireController(subfolder, controllerName)
            if result then
                return result
            end
        end
    end
    
    -- Not found
    warn(`[Loader] ✗ Controller not found: {controllerName}`)
    return nil
end

--[[
    Gets a loaded controller by name
    
    Parameters:
        controllerName (string) - Name of the controller
    
    Returns:
        table | nil - The controller module, or nil if not loaded
    
    Example:
        local UIController = Loader:GetController("UIController")
]]
function Loader:GetController(controllerName)
    local controller = loadedControllers[controllerName]
    if not controller then
        warn(`[Loader] Controller not loaded: {controllerName}`)
    end
    return controller
end

--[[
    Checks if a controller is loaded
    
    Parameters:
        controllerName (string) - Name of the controller
    
    Returns:
        boolean - True if loaded, false otherwise
]]
function Loader:IsControllerLoaded(controllerName)
    return loadedControllers[controllerName] ~= nil
end

--[[
    Gets all loaded controller names
    
    Returns:
        table - Array of loaded controller names
]]
function Loader:GetLoadedControllers()
    local names = {}
    for controllerName in pairs(loadedControllers) do
        table.insert(names, controllerName)
    end
    return names
end

return Loader
