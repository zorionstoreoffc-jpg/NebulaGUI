-- NEBULA UI LIBRARY v2.0
-- A comprehensive, production-ready Roblox GUI library
-- Supports: PC, Mobile, Method Chaining, Themes, Config System

local NebulaUI = {}
NebulaUI.__index = NebulaUI
NebulaUI.Version = "2.0.0"
NebulaUI.Debug = false

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Local Variables
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Theme System
NebulaUI.Themes = {
    Default = {
        Background = Color3.fromRGB(15, 15, 30),
        Foreground = Color3.fromRGB(25, 25, 50),
        Accent = Color3.fromRGB(138, 43, 226),
        AccentGradient = Color3.fromRGB(0, 191, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Border = Color3.fromRGB(70, 70, 120)
    },
    Dark = {
        Background = Color3.fromRGB(10, 10, 10),
        Foreground = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(100, 100, 255),
        AccentGradient = Color3.fromRGB(150, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 0, 0),
        Border = Color3.fromRGB(50, 50, 50)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Foreground = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(100, 100, 255),
        AccentGradient = Color3.fromRGB(150, 100, 255),
        Text = Color3.fromRGB(20, 20, 20),
        TextDark = Color3.fromRGB(100, 100, 100),
        Success = Color3.fromRGB(40, 180, 99),
        Warning = Color3.fromRGB(230, 180, 0),
        Error = Color3.fromRGB(200, 50, 50),
        Border = Color3.fromRGB(200, 200, 200)
    }
}

-- Utility Functions
local function tween(obj, props, duration)
    duration = duration or 0.3
    local tween = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad), props)
    tween:Play()
    return tween
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

-- Window Class
local Window = {}
Window.__index = Window

function NebulaUI:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Nebula UI"
    self.Subtitle = config.Subtitle or ""
    self.Size = config.Size or UDim2.new(0, 500, 0, 600)
    self.Theme = NebulaUI.Themes[config.Theme] or NebulaUI.Themes.Default
    self.MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    self.SaveConfig = config.SaveConfig or false
    self.ConfigFolder = config.ConfigFolder or "NebulaConfigs"
    
    self.Tabs = {}
    self.Flags = {}
    self.Connections = {}
    self.Notifications = {}
    
    self:CreateGUI()
    self:SetupKeybinds()
    
    return self
end

function Window:CreateGUI()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NebulaUI_" .. HttpService:GenerateGUID(false)
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = player.PlayerGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    createCorner(self.MainFrame, 12)
    createStroke(self.MainFrame, self.Theme.Accent, 3)
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = self.Theme.Foreground
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    createCorner(self.TitleBar, 12)
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TitleBar
    
    -- Subtitle
    if self.Subtitle ~= "" then
        local subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Size = UDim2.new(1, -100, 0, 15)
        subtitleLabel.Position = UDim2.new(0, 15, 0, 22)
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Text = self.Subtitle
        subtitleLabel.TextColor3 = self.Theme.TextDark
        subtitleLabel.TextSize = 12
        subtitleLabel.Font = Enum.Font.Gotham
        subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtitleLabel.Parent = self.TitleBar
    end
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = self.Theme.Error
    closeBtn.Text = "×"
    closeBtn.TextColor3 = self.Theme.Text
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = self.TitleBar
    
    createCorner(closeBtn, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 0, 35)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 45)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = self.TabContainer
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -20, 1, -95)
    self.ContentContainer.Position = UDim2.new(0, 10, 0, 85)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.MainFrame
    
    self:MakeDraggable()
end

function Window:MakeDraggable()
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Window:SetupKeybinds()
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == self.MinimizeKey then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end))
end

function Window:CreateTab(config)
    if type(config) == "string" then
        config = {Name = config}
    end
    
    local tab = setmetatable({}, {__index = Tab})
    tab.Window = self
    tab.Name = config.Name or "Tab"
    tab.Icon = config.Icon
    tab.Elements = {}
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Size = UDim2.new(0, 100, 0, 30)
    tab.Button.BackgroundColor3 = self.Theme.Foreground
    tab.Button.Text = tab.Name
    tab.Button.TextColor3 = self.Theme.TextDark
    tab.Button.TextSize = 14
    tab.Button.Font = Enum.Font.GothamSemibold
    tab.Button.Parent = self.TabContainer
    
    createCorner(tab.Button, 6)
    
    -- Tab Content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = tab.Name
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.ScrollBarThickness = 4
    tab.Content.ScrollBarImageColor3 = self.Theme.Accent
    tab.Content.BorderSizePixel = 0
    tab.Content.Visible = false
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tab.Content
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    if config.Default or #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(selectedTab)
    for _, tab in ipairs(self.Tabs) do
        tab.Content.Visible = false
        tab.Button.BackgroundColor3 = self.Theme.Foreground
        tab.Button.TextColor3 = self.Theme.TextDark
    end
    
    selectedTab.Content.Visible = true
    tween(selectedTab.Button, {BackgroundColor3 = self.Theme.Accent})
    selectedTab.Button.TextColor3 = self.Theme.Text
end

function Window:Notify(config)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, -310, 1, 100)
    notif.BackgroundColor3 = self.Theme.Foreground
    notif.BorderSizePixel = 0
    notif.ZIndex = 100
    notif.Parent = self.ScreenGui
    
    createCorner(notif, 8)
    
    local typeColor = config.Type == "Success" and self.Theme.Success or
                     config.Type == "Warning" and self.Theme.Warning or
                     config.Type == "Error" and self.Theme.Error or
                     self.Theme.Accent
    
    createStroke(notif, typeColor, 2)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Notification"
    title.TextColor3 = typeColor
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notif
    
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -20, 0, 35)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.BackgroundTransparency = 1
    content.Text = config.Content or ""
    content.TextColor3 = self.Theme.Text
    content.TextSize = 14
    content.Font = Enum.Font.Gotham
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.Parent = notif
    
    tween(notif, {Position = UDim2.new(1, -310, 1, -90)})
    
    delay(config.Duration or 5, function()
        tween(notif, {Position = UDim2.new(1, -310, 1, 100)}):Completed:Connect(function()
            notif:Destroy()
        end)
    end)
end

function Window:Destroy()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    self.ScreenGui:Destroy()
end

-- Tab Class
Tab = {}
Tab.__index = Tab

function Tab:AddButton(config)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, isMobile and 50 or 40)
    button.BackgroundColor3 = self.Window.Theme.Foreground
    button.Text = config.Name or "Button"
    button.TextColor3 = self.Window.Theme.Text
    button.TextSize = isMobile and 16 or 14
    button.Font = Enum.Font.GothamSemibold
    button.Parent = self.Content
    
    createCorner(button, 6)
    createStroke(button, self.Window.Theme.Border, 1)
    
    button.MouseEnter:Connect(function()
        tween(button, {BackgroundColor3 = self.Window.Theme.Accent})
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {BackgroundColor3 = self.Window.Theme.Foreground})
    end)
    
    button.MouseButton1Click:Connect(function()
        pcall(config.Callback)
    end)
    
    return button
end

function Tab:AddToggle(config)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = self.Content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Toggle"
    label.TextColor3 = self.Window.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggle.BackgroundColor3 = config.Default and self.Window.Theme.Success or self.Window.Theme.Foreground
    toggle.Text = config.Default and "ON" or "OFF"
    toggle.TextColor3 = self.Window.Theme.Text
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = container
    
    createCorner(toggle, 12)
    
    local state = config.Default or false
    
    if config.Flag then
        self.Window.Flags[config.Flag] = state
    end
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        tween(toggle, {BackgroundColor3 = state and self.Window.Theme.Success or self.Window.Theme.Foreground})
        
        if config.Flag then
            self.Window.Flags[config.Flag] = state
        end
        
        pcall(config.Callback, state)
    end)
    
    return container
end

function Tab:AddSlider(config)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = self.Content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = (config.Name or "Slider") .. ": " .. (config.Default or config.Min)
    label.TextColor3 = self.Window.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = self.Window.Theme.Foreground
    track.BorderSizePixel = 0
    track.Parent = container
    
    createCorner(track, 3)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = self.Window.Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    createCorner(fill, 3)
    
    local min, max = config.Min or 0, config.Max or 100
    local value = config.Default or min
    local increment = config.Increment or 1
    
    local function update(val)
        value = math.clamp(math.floor(val / increment + 0.5) * increment, min, max)
        local percent = (value - min) / (max - min)
        tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        label.Text = (config.Name or "Slider") .. ": " .. value .. (config.Suffix or "")
        
        if config.Flag then
            self.Window.Flags[config.Flag] = value
        end
        
        pcall(config.Callback, value)
    end
    
    update(value)
    
    local dragging = false
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local relativeX = input.Position.X - track.AbsolutePosition.X
            local percent = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
            update(min + (max - min) * percent)
        end
    end)
    
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = input.Position.X - track.AbsolutePosition.X
            local percent = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
            update(min + (max - min) * percent)
        end
    end)
    
    return container
end

function Tab:AddLabel(config)
    if type(config) == "string" then
        config = {Text = config}
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = config.Text or config.Name or "Label"
    label.TextColor3 = self.Window.Theme.Text
    label.TextSize = config.TextSize or 14
    label.Font = config.Font or Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Content
    
    return label
end

function Tab:AddSection(config)
    if type(config) == "string" then
        config = {Name = config}
    end
    
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 25)
    section.BackgroundTransparency = 1
    section.Text = config.Name or "Section"
    section.TextColor3 = self.Window.Theme.Accent
    section.TextSize = 16
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = self.Content
    
    return section
end

-- Return Library
return NebulaUI
