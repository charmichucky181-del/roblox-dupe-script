-- Universal Dupe Script - Dupe items in inventory/backpack
-- Works with all executors
-- Synapse X, Script-Ware, JJSploit, Oxygen U, Lua Executor, etc.

local Players = game:GetService("Players")
local player = Players.LocalPlayer or game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

local function createDupeGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DupeGUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 400, 0, 350)
	mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
	mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = mainFrame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(120, 120, 255)
	stroke.Thickness = 2
	stroke.Parent = mainFrame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -20, 0, 40)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.Text = "Item Dupe Tool"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 24
	title.BackgroundTransparency = 1
	title.Parent = mainFrame

	local status = Instance.new("TextLabel")
	status.Name = "Status"
	status.Size = UDim2.new(1, -20, 0, 22)
	status.Position = UDim2.new(0, 10, 0, 48)
	status.Text = "Ready"
	status.TextColor3 = Color3.fromRGB(170, 255, 170)
	status.Font = Enum.Font.Gotham
	status.TextSize = 12
	status.BackgroundTransparency = 1
	status.TextXAlignment = Enum.TextXAlignment.Left
	status.Parent = mainFrame

	-- Tabs
	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, 0, 0, 40)
	tabFrame.Position = UDim2.new(0, 0, 0, 70)
	tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	tabFrame.BorderSizePixel = 0
	tabFrame.Parent = mainFrame

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 8)
	tabCorner.Parent = tabFrame

	local tab1Btn = Instance.new("TextButton")
	tab1Btn.Size = UDim2.new(0.5, -2, 1, 0)
	tab1Btn.Position = UDim2.new(0, 0, 0, 0)
	tab1Btn.Text = "Your Backpack"
	tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab1Btn.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
	tab1Btn.BorderSizePixel = 0
	tab1Btn.Font = Enum.Font.GothamBold
	tab1Btn.TextSize = 14
	tab1Btn.Parent = tabFrame

	local tab1Corner = Instance.new("UICorner")
	tab1Corner.CornerRadius = UDim.new(0, 8)
	tab1Corner.Parent = tab1Btn

	local tab2Btn = Instance.new("TextButton")
	tab2Btn.Size = UDim2.new(0.5, -2, 1, 0)
	tab2Btn.Position = UDim2.new(0.5, 2, 0, 0)
	tab2Btn.Text = "Dupe Workspace"
	tab2Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	tab2Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	tab2Btn.BorderSizePixel = 0
	tab2Btn.Font = Enum.Font.GothamBold
	tab2Btn.TextSize = 14
	tab2Btn.Parent = tabFrame

	local tab2Corner = Instance.new("UICorner")
	tab2Corner.CornerRadius = UDim.new(0, 8)
	tab2Corner.Parent = tab2Btn

	-- TAB 1: Backpack Mode
	local tab1Container = Instance.new("Frame")
	tab1Container.Name = "Tab1"
	tab1Container.Size = UDim2.new(1, -20, 1, -130)
	tab1Container.Position = UDim2.new(0, 10, 0, 115)
	tab1Container.BackgroundTransparency = 1
	tab1Container.Visible = true
	tab1Container.Parent = mainFrame

	local itemsLabel = Instance.new("TextLabel")
	itemsLabel.Size = UDim2.new(1, 0, 0, 20)
	itemsLabel.Position = UDim2.new(0, 0, 0, 0)
	itemsLabel.Text = "Items in your Backpack:"
	itemsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	itemsLabel.Font = Enum.Font.Gotham
	itemsLabel.TextSize = 12
	itemsLabel.BackgroundTransparency = 1
	itemsLabel.TextXAlignment = Enum.TextXAlignment.Left
	itemsLabel.Parent = tab1Container

	local itemsList = Instance.new("ScrollingFrame")
	itemsList.Size = UDim2.new(1, 0, 1, -80)
	itemsList.Position = UDim2.new(0, 0, 0, 25)
	itemsList.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	itemsList.BorderSizePixel = 0
	itemsList.ScrollBarThickness = 8
	itemsList.Parent = tab1Container

	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 8)
	listCorner.Parent = itemsList

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = itemsList

	local selectedItem = nil

	local function refreshItemsList()
		for _, child in ipairs(itemsList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") or item:IsA("Model") or item:IsA("Part") then
				local itemBtn = Instance.new("TextButton")
				itemBtn.Size = UDim2.new(1, -10, 0, 35)
				itemBtn.Text = item.Name
				itemBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
				itemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
				itemBtn.BorderSizePixel = 0
				itemBtn.Font = Enum.Font.Gotham
				itemBtn.TextSize = 13
				itemBtn.Parent = itemsList

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 6)
				btnCorner.Parent = itemBtn

				itemBtn.MouseButton1Click:Connect(function()
					selectedItem = item
					for _, btn in ipairs(itemsList:GetChildren()) do
						if btn:IsA("TextButton") then
							btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
							btn.TextColor3 = Color3.fromRGB(200, 200, 220)
						end
					end
					itemBtn.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
					itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
					status.Text = "Selected: " .. item.Name
					status.TextColor3 = Color3.fromRGB(170, 200, 255)
				end)
			end
		end

		local spacer = Instance.new("Frame")
		spacer.Size = UDim2.new(1, 0, 0, 0)
		spacer.Parent = itemsList
	end

	local amountLabel1 = Instance.new("TextLabel")
	amountLabel1.Size = UDim2.new(0, 120, 0, 20)
	amountLabel1.Position = UDim2.new(0, 0, 1, -50)
	amountLabel1.Text = "Amount:"
	amountLabel1.TextColor3 = Color3.fromRGB(200, 200, 220)
	amountLabel1.Font = Enum.Font.Gotham
	amountLabel1.TextSize = 12
	amountLabel1.BackgroundTransparency = 1
	amountLabel1.TextXAlignment = Enum.TextXAlignment.Left
	amountLabel1.Parent = tab1Container

	local amountBox1 = Instance.new("TextBox")
	amountBox1.Size = UDim2.new(0, 80, 0, 30)
	amountBox1.Position = UDim2.new(0, 100, 1, -50)
	amountBox1.Text = "1"
	amountBox1.TextColor3 = Color3.fromRGB(255, 255, 255)
	amountBox1.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	amountBox1.BorderSizePixel = 0
	amountBox1.Font = Enum.Font.GothamBold
	amountBox1.TextSize = 14
	amountBox1.Parent = tab1Container

	local box1Corner = Instance.new("UICorner")
	box1Corner.CornerRadius = UDim.new(0, 8)
	box1Corner.Parent = amountBox1

	local dupeBtn1 = Instance.new("TextButton")
	dupeBtn1.Size = UDim2.new(1, -200, 0, 30)
	dupeBtn1.Position = UDim2.new(0, 190, 1, -50)
	dupeBtn1.Text = "Duplicate Selected"
	dupeBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)
	dupeBtn1.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
	dupeBtn1.BorderSizePixel = 0
	dupeBtn1.Font = Enum.Font.GothamBold
	dupeBtn1.TextSize = 12
	dupeBtn1.Parent = tab1Container

	local btn1Corner = Instance.new("UICorner")
	btn1Corner.CornerRadius = UDim.new(0, 8)
	btn1Corner.Parent = dupeBtn1

	dupeBtn1.MouseButton1Click:Connect(function()
		if not selectedItem then
			status.Text = "Select an item first!"
			status.TextColor3 = Color3.fromRGB(255, 170, 170)
			return
		end

		local amount = tonumber(amountBox1.Text) or 1
		if amount < 1 then amount = 1 end
		if amount > 50 then amount = 50 end

		local success = pcall(function()
			for i = 1, amount do
				local clone = selectedItem:Clone()
				clone.Parent = backpack
				wait(0.05)
			end
		end)

		if success then
			status.Text = "Duplicated " .. amount .. "x " .. selectedItem.Name
			status.TextColor3 = Color3.fromRGB(170, 255, 170)
		else
			status.Text = "Error duplicating item"
			status.TextColor3 = Color3.fromRGB(255, 170, 170)
		end
	end)

	-- TAB 2: Workspace Mode
	local tab2Container = Instance.new("Frame")
	tab2Container.Name = "Tab2"
	tab2Container.Size = UDim2.new(1, -20, 1, -130)
	tab2Container.Position = UDim2.new(0, 10, 0, 115)
	tab2Container.BackgroundTransparency = 1
	tab2Container.Visible = false
	tab2Container.Parent = mainFrame

	local wsNameLabel = Instance.new("TextLabel")
	wsNameLabel.Size = UDim2.new(0, 120, 0, 20)
	wsNameLabel.Position = UDim2.new(0, 0, 0, 0)
	wsNameLabel.Text = "Object Name:"
	wsNameLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	wsNameLabel.Font = Enum.Font.Gotham
	wsNameLabel.TextSize = 12
	wsNameLabel.BackgroundTransparency = 1
	wsNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	wsNameLabel.Parent = tab2Container

	local wsNameBox = Instance.new("TextBox")
	wsNameBox.Size = UDim2.new(1, 0, 0, 30)
	wsNameBox.Position = UDim2.new(0, 0, 0, 25)
	wsNameBox.PlaceholderText = "Ex: Sword, Tree, Part"
	wsNameBox.Text = ""
	wsNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	wsNameBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
	wsNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	wsNameBox.BorderSizePixel = 0
	wsNameBox.Font = Enum.Font.Gotham
	wsNameBox.TextSize = 14
	wsNameBox.Parent = tab2Container

	local wsBox1Corner = Instance.new("UICorner")
	wsBox1Corner.CornerRadius = UDim.new(0, 8)
	wsBox1Corner.Parent = wsNameBox

	local wsAmountLabel = Instance.new("TextLabel")
	wsAmountLabel.Size = UDim2.new(0, 120, 0, 20)
	wsAmountLabel.Position = UDim2.new(0, 0, 0, 65)
	wsAmountLabel.Text = "Amount:"
	wsAmountLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	wsAmountLabel.Font = Enum.Font.Gotham
	wsAmountLabel.TextSize = 12
	wsAmountLabel.BackgroundTransparency = 1
	wsAmountLabel.TextXAlignment = Enum.TextXAlignment.Left
	wsAmountLabel.Parent = tab2Container

	local wsAmountBox = Instance.new("TextBox")
	wsAmountBox.Size = UDim2.new(0, 80, 0, 30)
	wsAmountBox.Position = UDim2.new(0, 0, 0, 90)
	wsAmountBox.Text = "1"
	wsAmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	wsAmountBox.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	wsAmountBox.BorderSizePixel = 0
	wsAmountBox.Font = Enum.Font.GothamBold
	wsAmountBox.TextSize = 14
	wsAmountBox.Parent = tab2Container

	local wsBox2Corner = Instance.new("UICorner")
	wsBox2Corner.CornerRadius = UDim.new(0, 8)
	wsBox2Corner.Parent = wsAmountBox

	local dupeBtn2 = Instance.new("TextButton")
	dupeBtn2.Size = UDim2.new(1, -100, 0, 30)
	dupeBtn2.Position = UDim2.new(0, 100, 0, 90)
	dupeBtn2.Text = "Duplicate"
	dupeBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
	dupeBtn2.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
	dupeBtn2.BorderSizePixel = 0
	dupeBtn2.Font = Enum.Font.GothamBold
	dupeBtn2.TextSize = 12
	dupeBtn2.Parent = tab2Container

	local btn2Corner = Instance.new("UICorner")
	btn2Corner.CornerRadius = UDim.new(0, 8)
	btn2Corner.Parent = dupeBtn2

	dupeBtn2.MouseButton1Click:Connect(function()
		local objectName = wsNameBox.Text
		local amount = tonumber(wsAmountBox.Text) or 1

		if objectName == "" then
			status.Text = "Type an object name"
			status.TextColor3 = Color3.fromRGB(255, 170, 170)
			return
		end

		if amount < 1 then amount = 1 end
		if amount > 100 then amount = 100 end

		local target = workspace:FindFirstChild(objectName)

		if not target then
			status.Text = "Object not found in Workspace"
			status.TextColor3 = Color3.fromRGB(255, 170, 170)
			return
		end

		local success = pcall(function()
			for i = 1, amount do
				local clone = target:Clone()
				clone.Parent = workspace

				if clone:IsA("Model") then
					if clone.PrimaryPart then
						local offset = Vector3.new(i * 4, 0, 0)
						clone:PivotTo(target:GetPivot() * CFrame.new(offset))
					else
						clone:MoveTo(target:GetPivot().Position + Vector3.new(i * 4, 0, 0))
					end
				elseif clone:IsA("BasePart") then
					clone.Position = target.Position + Vector3.new(i * 4, 0, 0)
				end

				wait(0.05)
			end
		end)

		if success then
			status.Text = "Duplicated " .. amount .. "x " .. objectName
			status.TextColor3 = Color3.fromRGB(170, 255, 170)
		else
			status.Text = "Error duplicating"
			status.TextColor3 = Color3.fromRGB(255, 170, 170)
		end
	end)

	-- Tab switching
	tab1Btn.MouseButton1Click:Connect(function()
		tab1Container.Visible = true
		tab2Container.Visible = false
		tab1Btn.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
		tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tab2Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		tab2Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		refreshItemsList()
	end)

	tab2Btn.MouseButton1Click:Connect(function()
		tab1Container.Visible = false
		tab2Container.Visible = true
		tab2Btn.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
		tab2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tab1Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		tab1Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	end)

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 5)
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	closeBtn.BorderSizePixel = 0
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 18
	closeBtn.Parent = mainFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeBtn

	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	-- Draggable
	local dragging = false
	local dragStart = nil
	local framePos = nil

	mainFrame.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			framePos = mainFrame.Position
		end
	end)

	mainFrame.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessed)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = framePos + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end)

	-- Initial load
	refreshItemsList()

	-- Refresh items when backpack changes
	backpack.ChildAdded:Connect(function()
		if tab1Container.Visible then
			refreshItemsList()
		end
	end)

	backpack.ChildRemoved:Connect(function()
		if tab1Container.Visible then
			refreshItemsList()
		end
	end)
end

if player then
	createDupeGUI()
else
	warn("Failed to get LocalPlayer")
end
