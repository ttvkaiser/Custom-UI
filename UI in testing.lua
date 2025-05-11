-- Full GUI Script with WalkSpeed, Infinite Jump, and Noclip Toggles

local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Player = game.Players.LocalPlayer

-- Colors
local ColorBlack = Color3.fromRGB(20, 20, 20)
local ColorDarkPurple = Color3.fromRGB(60, 40, 80)
local ColorDarkBlue = Color3.fromRGB(30, 50, 100)

-- Helper: add UICorner
local function addCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
end

-- Get game name
local success, info = pcall(function()
	return MarketplaceService:GetProductInfo(game.PlaceId)
end)

local gameName = "Unknown"
if success and info then
	gameName = info.Name
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomTabUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = ColorBlack
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
addCorner(MainFrame, 8)

local TitleBar = Instance.new("TextLabel", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = ColorDarkPurple
TitleBar.Text = "Nebula Hub | Game: " .. gameName .. " | Version 0.1.1"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 16
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.BorderSizePixel = 0
addCorner(TitleBar, 8)

local ControlHolder = Instance.new("Frame", TitleBar)
ControlHolder.Size = UDim2.new(0, 90, 1, 0)
ControlHolder.Position = UDim2.new(1, -90, 0, 0)
ControlHolder.BackgroundTransparency = 1

local originalSize = UDim2.new(0, 600, 0, 400)
local minimizedSize = UDim2.new(0, 600, 0, 40)
local expandedSize = UDim2.new(0, 900, 0, 650)
local isMinimized = false
local isExpanded = false

local TabButtons = Instance.new("Frame", MainFrame)
TabButtons.Size = UDim2.new(0, 120, 1, -30)
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.BackgroundColor3 = ColorDarkBlue
TabButtons.BorderSizePixel = 0
addCorner(TabButtons, 6)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -120, 1, -30)
ContentArea.Position = UDim2.new(0, 120, 0, 30)
ContentArea.BackgroundColor3 = ColorBlack
ContentArea.BorderSizePixel = 0
addCorner(ContentArea, 6)

local Tabs = {
	{ Name = "Home" },
	{ Name = "Main" },
	{ Name = "Automaticlly" },
	{ Name = "Inventory" },
	{ Name = "Shop" },
	{ Name = "Quest" },
	{ Name = "Teleport" },
	{ Name = "Settings" },
	{ Name = "Miscellaneous" },
}

-- Toggle + TextBox Frame
local ToggleFrame = Instance.new("Frame", MainFrame)
ToggleFrame.Size = UDim2.new(0, 220, 0, 120)
ToggleFrame.Position = UDim2.new(0, 120, 0, 60)
ToggleFrame.BackgroundTransparency = 1
ToggleFrame.Visible = false

-- Section Title
local SectionTitle = Instance.new("TextLabel", ToggleFrame)
SectionTitle.Size = UDim2.new(1, 0, 0, 20)
SectionTitle.Position = UDim2.new(0, 0, 0, 0)
SectionTitle.Text = "Local Player Configuration"
SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SectionTitle.Font = Enum.Font.GothamBold
SectionTitle.TextSize = 16
SectionTitle.BackgroundTransparency = 1

-- WalkSpeed Toggle
local ToggleLabel = Instance.new("TextLabel", ToggleFrame)
ToggleLabel.Size = UDim2.new(0, 80, 0, 25)
ToggleLabel.Position = UDim2.new(0, 0, 0, 25)
ToggleLabel.Text = "WalkSpeed"
ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLabel.Font = Enum.Font.Gotham
ToggleLabel.TextSize = 16
ToggleLabel.BackgroundTransparency = 1

local SpeedInput = Instance.new("TextBox", ToggleFrame)
SpeedInput.Size = UDim2.new(0, 60, 0, 25)
SpeedInput.Position = UDim2.new(0, 85, 0, 25)
SpeedInput.PlaceholderText = "Speed"
SpeedInput.Text = ""
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.BackgroundColor3 = ColorDarkBlue
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.TextSize = 14
SpeedInput.ClearTextOnFocus = false
SpeedInput.BorderSizePixel = 0
addCorner(SpeedInput, 6)

local ToggleButton = Instance.new("TextButton", ToggleFrame)
ToggleButton.Size = UDim2.new(0, 60, 0, 25)
ToggleButton.Position = UDim2.new(0, 150, 0, 25)
ToggleButton.Text = "Off"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = ColorDarkPurple
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.BorderSizePixel = 0
addCorner(ToggleButton, 6)

local isToggledOn = false
ToggleButton.MouseButton1Click:Connect(function()
	isToggledOn = not isToggledOn
	ToggleButton.Text = isToggledOn and "On" or "Off"
	ToggleButton.BackgroundColor3 = isToggledOn and Color3.fromRGB(0, 255, 120) or ColorDarkPurple

	local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if isToggledOn then
			local speed = tonumber(SpeedInput.Text)
			if speed then
				humanoid.WalkSpeed = speed
			end
		else
			humanoid.WalkSpeed = 16
		end
	end
end)

-- Infinite Jump Toggle
local InfiniteJumpToggle = Instance.new("TextButton", ToggleFrame)
InfiniteJumpToggle.Size = UDim2.new(0, 100, 0, 25)
InfiniteJumpToggle.Position = UDim2.new(0, 0, 0, 60)
InfiniteJumpToggle.Text = "Infinite Jump: Off"
InfiniteJumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteJumpToggle.BackgroundColor3 = ColorDarkPurple
InfiniteJumpToggle.Font = Enum.Font.GothamBold
InfiniteJumpToggle.TextSize = 14
InfiniteJumpToggle.BorderSizePixel = 0
addCorner(InfiniteJumpToggle, 6)

local infiniteJumpEnabled = false
local jumpConnection

InfiniteJumpToggle.MouseButton1Click:Connect(function()
	infiniteJumpEnabled = not infiniteJumpEnabled
	InfiniteJumpToggle.Text = "Infinite Jump: " .. (infiniteJumpEnabled and "On" or "Off")
	InfiniteJumpToggle.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 255, 120) or ColorDarkPurple

	if infiniteJumpEnabled then
		jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
			local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if jumpConnection then
			jumpConnection:Disconnect()
			jumpConnection = nil
		end
	end
end)

-- Noclip Toggle
local NoclipToggle = Instance.new("TextButton", ToggleFrame)
NoclipToggle.Size = UDim2.new(0, 100, 0, 25)
NoclipToggle.Position = UDim2.new(0, 110, 0, 60)
NoclipToggle.Text = "Noclip: Off"
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.BackgroundColor3 = ColorDarkPurple
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.TextSize = 14
NoclipToggle.BorderSizePixel = 0
addCorner(NoclipToggle, 6)

local noclipEnabled = false
local RunService = game:GetService("RunService")

NoclipToggle.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipToggle.Text = "Noclip: " .. (noclipEnabled and "On" or "Off")
	NoclipToggle.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 255, 120) or ColorDarkPurple
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and Player.Character then
		for _, part in pairs(Player.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide == true then
				part.CanCollide = false
			end
		end
	end
end)

-- Tab Buttons
for index, tab in ipairs(Tabs) do
	local Button = Instance.new("TextButton", TabButtons)
	Button.Size = UDim2.new(1, 0, 0, 40)
	Button.Position = UDim2.new(0, 0, 0, (index - 1) * 40)
	Button.Text = tab.Name
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.BackgroundColor3 = ColorDarkPurple
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14
	Button.BorderSizePixel = 0
	addCorner(Button, 6)

	local ContentLabel = Instance.new("TextLabel")
	ContentLabel.Size = UDim2.new(1, 0, 1, 0)
	ContentLabel.Position = UDim2.new(0, 0, 0, 0)
	ContentLabel.BackgroundTransparency = 1
	ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ContentLabel.Font = Enum.Font.Gotham
	ContentLabel.TextSize = 16
	ContentLabel.TextWrapped = true
	ContentLabel.Text = tab.Content or tab.Name .. " tab content"
	ContentLabel.Visible = false
	ContentLabel.Name = "Tab_" .. tab.Name
	ContentLabel.Parent = ContentArea

	Button.MouseButton1Click:Connect(function()
		for _, child in pairs(ContentArea:GetChildren()) do
			if child:IsA("TextLabel") then
				child.Visible = false
			end
		end
		local targetTab = ContentArea:FindFirstChild("Tab_" .. tab.Name)
		if targetTab then
			targetTab.Visible = true
		end
		ToggleFrame.Visible = (tab.Name == "Home" and not isMinimized)
	end)

	if index == 1 then
		ContentLabel.Visible = true
	end
end

-- Control Buttons
local function createControlButton(symbol, offset, color, callback)
	local btn = Instance.new("TextButton", ControlHolder)
	btn.Size = UDim2.new(0, 30, 1, 0)
	btn.Position = UDim2.new(0, offset, 0, 0)
	btn.BackgroundColor3 = color
	btn.Text = symbol
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.BorderSizePixel = 0
	addCorner(btn, 4)
	btn.MouseButton1Click:Connect(callback)
end

-- _ Minimize
createControlButton("_", 0, ColorDarkBlue, function()
	if isMinimized then
		MainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
		TabButtons.Visible = true
		ContentArea.Visible = true
		for _, label in ipairs(ContentArea:GetChildren()) do
			if label:IsA("TextLabel") and label.Visible and label.Name == "Tab_Home" then
				ToggleFrame.Visible = true
			end
		end
		isMinimized = false
	else
		MainFrame:TweenSize(minimizedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
		TabButtons.Visible = false
		ContentArea.Visible = false
		ToggleFrame.Visible = false
		isMinimized = true
	end
end)

-- O Expand
createControlButton("▢", 30, ColorDarkPurple, function()
	if isExpanded then
		MainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
		isExpanded = false
	else
		MainFrame:TweenSize(expandedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
		isExpanded = true
	end
end)

-- X Close
createControlButton("X", 60, Color3.fromRGB(120, 40, 40), function()
	ScreenGui:Destroy()
end)
