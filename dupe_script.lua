local Players = game:GetService("Players")

local function createDupeGUI(player)
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DupeGUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 360, 0, 220)
	mainFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
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
	title.Text = "Dupe Tool"
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
	status.TextSize = 14
	status.BackgroundTransparency = 1
	status.TextXAlignment = Enum.TextXAlignment.Left
	status.Parent = mainFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 120, 0, 24)
	nameLabel.Position = UDim2.new(0, 14, 0, 90)
	nameLabel.Text = "Object Name"
	nameLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 15
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = mainFrame

	local objectBox = Instance.new("TextBox")
	objectBox.Size = UDim2.new(1, -30, 0, 38)
	objectBox.Position = UDim2.new(0, 15, 0, 116)
	objectBox.PlaceholderText = "Ex: Tree"
	objectBox.Text = ""
	objectBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	objectBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
	objectBox.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	objectBox.BorderSizePixel = 0
	objectBox.Font = Enum.Font.Gotham
	objectBox.TextSize = 18
	objectBox.Parent = mainFrame

	local corner2 = Instance.new("UICorner")
	corner2.CornerRadius = UDim.new(0, 10)
	corner2.Parent = objectBox

	local amountLabel = Instance.new("TextLabel")
	amountLabel.Size = UDim2.new(0, 120, 0, 24)
	amountLabel.Position = UDim2.new(0, 14, 0, 165)
	amountLabel.Text = "Amount"
	amountLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	amountLabel.Font = Enum.Font.Gotham
	amountLabel.TextSize = 15
	amountLabel.BackgroundTransparency = 1
	amountLabel.TextXAlignment = Enum.TextXAlignment.Left
	amountLabel.Parent = mainFrame

	local amountBox = Instance.new("TextBox")
	amountBox.Size = UDim2.new(0, 90, 0, 32)
	amountBox.Position = UDim2.new(0, 15, 0, 188)
	amountBox.Text = "1"
	amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	amountBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
	amountBox.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	amountBox.BorderSizePixel = 0
	amountBox.Font = Enum.Font.GothamBold
	amountBox.TextSize = 16
	amountBox.Parent = mainFrame

	local amountCorner = Instance.new("UICorner")
	amountCorner.CornerRadius = UDim.new(0, 8)
	amountCorner.Parent = amountBox

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 140, 0, 40)
	button.Position = UDim2.new(1, -150, 0, 180)
	button.Text = "Duplicate"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(96, 110, 255)
	button.BorderSizePixel = 0
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	button.Parent = mainFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 10)
	buttonCorner.Parent = button

	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = Color3.fromRGB(140, 150, 255)
	buttonStroke.Thickness = 1
	buttonStroke.Parent = button

	button.MouseButton1Click:Connect(function()
		local objectName = objectBox.Text
		local amount = tonumber(amountBox.Text) or 1

		if objectName == "" then
			status.Text = "Type an object name"
			status.TextColor3 = Color3.fromRGB(255, 170, 170)
			return
		end

		if amount < 1 then
			amount = 1
		end

		local target = workspace:FindFirstChild(objectName)

		if not target then
			status.Text = "Object not found in Workspace"
			status.TextColor3 = Color3.fromRGB(255, 170, 170)
			return
		end

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
			else
				clone.Position = target.Position + Vector3.new(i * 4, 0, 0)
			end
		end

		status.Text = "Duplicated " .. amount .. "x " .. objectName
		status.TextColor3 = Color3.fromRGB(170, 255, 170)
	end)
end

local player = Players.LocalPlayer
createDupeGUI(player)