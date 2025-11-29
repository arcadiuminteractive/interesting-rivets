local Icon = require(ReplicatedStorage.Packages.Icon)
local menuIcon = Icon.new()
    :setLabel("Menu")
    :setOrder(1)

-- Use the .toggled event instead of bindToggleItem
menuIcon.toggled:Connect(function(isSelected)
    menuGui.Enabled = isSelected
end)