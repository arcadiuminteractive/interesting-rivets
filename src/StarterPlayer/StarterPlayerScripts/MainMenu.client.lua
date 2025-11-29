local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
if not Packages then
    warn("Packages not found!")
    return
end

local Icon = require(Packages.Icon)
local menuIcon = Icon.new()
    :setLabel("Menu")
    :setOrder(1)

    -- Use the .toggled event instead of bindToggleItem
menuIcon.toggled:Connect(function(isSelected)
    menuGui.Visible = true
end)

local menuIcon = Icon.new()
    :setLabel("Inventory")
    :setOrder(2)