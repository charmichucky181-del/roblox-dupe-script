-- Advanced inventory system - Search and find items across all game files
-- Searches ReplicatedStorage, ServerStorage, Workspace, and finds items by name

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local inventoryData = {}

local function ensurePlayerInventory(player)
    if not inventoryData[player] then
        inventoryData[player] = {}
    end
end

local function findItemInAllStorage(itemName)
    -- Search in ReplicatedStorage
    local found = ReplicatedStorage:FindFirstChild(itemName)
    if found then
        return found, "ReplicatedStorage"
    end

    -- Search in ServerStorage
    found = ServerStorage:FindFirstChild(itemName)
    if found then
        return found, "ServerStorage"
    end

    -- Search in Workspace
    found = workspace:FindFirstChild(itemName)
    if found then
        return found, "Workspace"
    end

    -- Deep search in ReplicatedStorage
    local function deepSearch(parent, targetName)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == targetName then
                return child
            end
            local result = deepSearch(child, targetName)
            if result then
                return result
            end
        end
        return nil
    end

    found = deepSearch(ReplicatedStorage, itemName)
    if found then
        return found, "ReplicatedStorage"
    end

    found = deepSearch(ServerStorage, itemName)
    if found then
        return found, "ServerStorage"
    end

    found = deepSearch(workspace, itemName)
    if found then
        return found, "Workspace"
    end

    return nil, "Not Found"
end

local function getAllGameItems()
    local items = {}

    local function collectItems(parent, location)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Tool") or child:IsA("Model") or child:IsA("Part") then
                if not items[child.Name] then
                    items[child.Name] = {obj = child, location = location}
                end
            end
            collectItems(child, location)
        end
    end

    collectItems(ReplicatedStorage, "ReplicatedStorage")
    collectItems(ServerStorage, "ServerStorage")
    collectItems(workspace, "Workspace")

    return items
end

local function addItemToInventory(player, itemName, amount)
    ensurePlayerInventory(player)

    if not inventoryData[player][itemName] then
        inventoryData[player][itemName] = 0
    end

    inventoryData[player][itemName] += amount

    local template, location = findItemInAllStorage(itemName)
    if template then
        for i = 1, amount do
            local clone = template:Clone()
            clone.Parent = player.Backpack
        end
        return true, location
    else
        return false, "Not Found"
    end
end

local function createInventoryUI(player)
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedInventoryGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 500)
    frame.Position = UDim2.new(0.5, -210, 0.5, -250)
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

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 35)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Text = "Advanced Inventory"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.BackgroundTransparency = 1
    title.Parent = frame

    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 48)
    status.Text = "Ready"
    status.TextColor3 = Color3.fromRGB(170, 255, 170)
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.BackgroundTransparency = 1
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextWrapped = true
    status.Parent = frame

    -- Search Box
    local searchLabel = Instance.new("TextLabel")
    searchLabel.Size = UDim2.new(1, -20, 0, 18)
    searchLabel.Position = UDim2.new(0, 10, 0, 75)
    searchLabel.Text = "Search Item:"
    searchLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    searchLabel.Font = Enum.Font.Gotham
    searchLabel.TextSize = 12
    searchLabel.BackgroundTransparency = 1
    searchLabel.TextXAlignment = Enum.TextXAlignment.Left
    searchLabel.Parent = frame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 0, 32)
    searchBox.Position = UDim2.new(0, 10, 0, 98)
    searchBox.PlaceholderText = "Type item name (ex: Sword, Tool, etc)"
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    searchBox.BorderSizePixel = 0
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.Parent = frame

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox

    -- Item List
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -20, 0, 240)
    list.Position = UDim2.new(0, 10, 0, 138)
    list.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 8
    list.Parent = frame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = list

    -- Current Inventory Display
    local invLabel = Instance.new("TextLabel")
    invLabel.Size = UDim2.new(1, -20, 0, 18)
    invLabel.Position = UDim2.new(0, 10, 1, -105)
    invLabel.Text = "Your Inventory:"
    invLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    invLabel.Font = Enum.Font.Gotham
    invLabel.TextSize = 12
    invLabel.BackgroundTransparency = 1
    invLabel.TextXAlignment = Enum.TextXAlignment.Left
    invLabel.Parent = frame

    local invList = Instance.new("ScrollingFrame")
    invList.Size = UDim2.new(1, -20, 0, 50)
    invList.Position = UDim2.new(0, 10, 1, -80)
    invList.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    invList.BorderSizePixel = 0
    invList.ScrollBarThickness = 6
    invList.Parent = frame

    local invCorner = Instance.new("UICorner")
    invCorner.CornerRadius = UDim.new(0, 8)
    invCorner.Parent = invList

    local invLayout = Instance.new("UIListLayout")
    invLayout.Padding = UDim.new(0, 3)
    invLayout.Parent = invList

    local selectedItem = nil

    local function refreshList(searchTerm)
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                if child.Name ~= "UIListLayout" then
                    child:Destroy()
                end
            end
        end

        local allItems = getAllGameItems()

        for itemName, itemData in pairs(allItems) do
            if searchTerm == "" or string.find(string.lower(itemName), string.lower(searchTerm)) then
                local itemBtn = Instance.new("TextButton")
                itemBtn.Size = UDim2.new(1, -10, 0, 40)
                itemBtn.Text = itemName .. " [" .. itemData.location .. "]"
                itemBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                itemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                itemBtn.BorderSizePixel = 0
                itemBtn.Font = Enum.Font.Gotham
                itemBtn.TextSize = 12
                itemBtn.Parent = list

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = itemBtn

                itemBtn.MouseButton1Click:Connect(function()
                    selectedItem = itemName
                    for _, btn in ipairs(list:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                        end
                    end
                    itemBtn.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
                    status.Text = "Selected: " .. itemName .. " from " .. itemData.location
                    status.TextColor3 = Color3.fromRGB(170, 200, 255)
                end)
            end
        end
    end

    local function refreshInventory()
        for _, child in ipairs(invList:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                if child.Name ~= "UIListLayout" then
                    child:Destroy()
                end
            end
        end

        local items = inventoryData[player]
        if not items or next(items) == nil then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Size = UDim2.new(1, -10, 0, 30)
            emptyLabel.Text = "Empty"
            emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            emptyLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            emptyLabel.Parent = invList

            local emptyCorner = Instance.new("UICorner")
            emptyCorner.CornerRadius = UDim.new(0, 6)
            emptyCorner.Parent = emptyLabel
            return
        end

        for itemName, amount in pairs(items) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, -10, 0, 28)
            itemLabel.Text = itemName .. "  x" .. amount
            itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemLabel.BackgroundColor3 = Color3.fromRGB(60, 70, 100)
            itemLabel.Font = Enum.Font.GothamMedium
            itemLabel.TextSize = 14
            itemLabel.Parent = invList

            local labelCorner = Instance.new("UICorner")
            labelCorner.CornerRadius = UDim.new(0, 6)
            labelCorner.Parent = itemLabel
        end
    end

    -- Amount input
    local amountLabel = Instance.new("TextLabel")
    amountLabel.Size = UDim2.new(0, 80, 0, 18)
    amountLabel.Position = UDim2.new(0, 10, 1, -40)
    amountLabel.Text = "Amount:"
    amountLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    amountLabel.Font = Enum.Font.Gotham
    amountLabel.TextSize = 12
    amountLabel.BackgroundTransparency = 1
    amountLabel.Parent = frame

    local amountBox = Instance.new("TextBox")
    amountBox.Size = UDim2.new(0, 50, 0, 28)
    amountBox.Position = UDim2.new(0, 100, 1, -40)
    amountBox.Text = "1"
    amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    amountBox.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    amountBox.BorderSizePixel = 0
    amountBox.Font = Enum.Font.GothamBold
    amountBox.TextSize = 14
    amountBox.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = amountBox

    -- Add button
    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0, 100, 0, 28)
    addBtn.Position = UDim2.new(0, 160, 1, -40)
    addBtn.Text = "Add to Inv"
    addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addBtn.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
    addBtn.BorderSizePixel = 0
    addBtn.Font = Enum.Font.GothamBold
    addBtn.TextSize = 12
    addBtn.Parent = frame

    local addCorner = Instance.new("UICorner")
    addCorner.CornerRadius = UDim.new(0, 6)
    addCorner.Parent = addBtn

    addBtn.MouseButton1Click:Connect(function()
        if not selectedItem then
            status.Text = "Select an item first!"
            status.TextColor3 = Color3.fromRGB(255, 170, 170)
            return
        end

        local amount = tonumber(amountBox.Text) or 1
        if amount < 1 then amount = 1 end
        if amount > 100 then amount = 100 end

        local success, location = addItemToInventory(player, selectedItem, amount)
        if success then
            status.Text = "✓ Added " .. amount .. "x " .. selectedItem .. " from " .. location
            status.TextColor3 = Color3.fromRGB(170, 255, 170)
            refreshInventory()
        else
            status.Text = "✗ Item not found in game files"
            status.TextColor3 = Color3.fromRGB(255, 170, 170)
        end
    end)

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 8)
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

    -- Search functionality
    searchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            refreshList(searchBox.Text)
        end
    end)

    -- Draggable
    local dragging = false
    local dragStart = nil
    local framePos = nil

    frame.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            framePos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessed)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = framePos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)

    -- Initial load
    refreshList("")
    refreshInventory()
end

Players.PlayerAdded:Connect(function(player)
    ensurePlayerInventory(player)
    createInventoryUI(player)
end)
