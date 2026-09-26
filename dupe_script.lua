-- Safe inventory item system with nice UI
-- This adds item templates from ReplicatedStorage into a player's inventory/backpack
-- Works as a legitimate game system, not as a bypass

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local templatesFolder = ReplicatedStorage:FindFirstChild("ItemTemplates")
if not templatesFolder then
    templatesFolder = Instance.new("Folder")
    templatesFolder.Name = "ItemTemplates"
    templatesFolder.Parent = ReplicatedStorage
end

local inventoryData = {}

local function ensurePlayerInventory(player)
    if not inventoryData[player] then
        inventoryData[player] = {}
    end
end

local function addItemToInventory(player, itemName, amount)
    ensurePlayerInventory(player)

    if not inventoryData[player][itemName] then
        inventoryData[player][itemName] = 0
    end

    inventoryData[player][itemName] += amount

    local template = templatesFolder:FindFirstChild(itemName)
    if template then
        for i = 1, amount do
            local clone = template:Clone()
            clone.Parent = player.Backpack
        end
    else
        warn("Item template not found: " .. itemName)
    end
end

local function createInventoryUI(player)
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InventoryGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 260)
    frame.Position = UDim2.new(0.5, -170, 0.5, -130)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 120, 255)
    stroke.Thickness = 2
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 35)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Text = "Inventory"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.BackgroundTransparency = 1
    title.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 22)
    status.Position = UDim2.new(0, 10, 0, 42)
    status.Text = "Ready"
    status.TextColor3 = Color3.fromRGB(170, 255, 170)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.BackgroundTransparency = 1
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -20, 1, -90)
    list.Position = UDim2.new(0, 10, 0, 72)
    list.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 8
    list.Parent = frame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = list

    local function refreshList()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                if child.Name ~= "UIListLayout" then
                    child:Destroy()
                end
            end
        end

        local items = inventoryData[player]
        if not items then
            return
        end

        for itemName, amount in pairs(items) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, -10, 0, 36)
            itemLabel.Text = itemName .. "  x" .. amount
            itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            itemLabel.Font = Enum.Font.GothamMedium
            itemLabel.TextSize = 16
            itemLabel.BackgroundTransparency = 0
            itemLabel.Parent = list

            local labelCorner = Instance.new("UICorner")
            labelCorner.CornerRadius = UDim.new(0, 8)
            labelCorner.Parent = itemLabel
        end
    end

    local addButton = Instance.new("TextButton")
    addButton.Size = UDim2.new(0, 120, 0, 34)
    addButton.Position = UDim2.new(1, -135, 1, -38)
    addButton.Text = "Give Sword"
    addButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    addButton.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
    addButton.BorderSizePixel = 0
    addButton.Font = Enum.Font.GothamBold
    addButton.TextSize = 14
    addButton.Parent = frame

    local addCorner = Instance.new("UICorner")
    addCorner.CornerRadius = UDim.new(0, 8)
    addCorner.Parent = addButton

    addButton.MouseButton1Click:Connect(function()
        addItemToInventory(player, "Sword", 1)
        refreshList()
        status.Text = "Sword added"
        status.TextColor3 = Color3.fromRGB(170, 255, 170)
    end)

    local potionButton = Instance.new("TextButton")
    potionButton.Size = UDim2.new(0, 120, 0, 34)
    potionButton.Position = UDim2.new(0, 10, 1, -38)
    potionButton.Text = "Give Potion"
    potionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    potionButton.BackgroundColor3 = Color3.fromRGB(120, 200, 120)
    potionButton.BorderSizePixel = 0
    potionButton.Font = Enum.Font.GothamBold
    potionButton.TextSize = 14
    potionButton.Parent = frame

    local potionCorner = Instance.new("UICorner")
    potionCorner.CornerRadius = UDim.new(0, 8)
    potionCorner.Parent = potionButton

    potionButton.MouseButton1Click:Connect(function()
        addItemToInventory(player, "Potion", 1)
        refreshList()
        status.Text = "Potion added"
        status.TextColor3 = Color3.fromRGB(170, 255, 170)
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 8)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = frame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    refreshList()
end

local function setupItemTemplates()
    local sword = Instance.new("Tool")
    sword.Name = "Sword"
    sword.Parent = templatesFolder

    local potion = Instance.new("Tool")
    potion.Name = "Potion"
    potion.Parent = templatesFolder
end

Players.PlayerAdded:Connect(function(player)
    ensurePlayerInventory(player)
    createInventoryUI(player)
    addItemToInventory(player, "Sword", 1)
    addItemToInventory(player, "Potion", 2)
end)

setupItemTemplates()
