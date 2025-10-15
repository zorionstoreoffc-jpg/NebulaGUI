-- Nebula UI Library v2.0
-- Complete Roblox GUI Framework with Mobile Support
-- GitHub: https://github.com/zorionstoreoffc-jpg/NebulaGUI

local NebulaUI = {}
NebulaUI.__index = NebulaUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Local player reference
local player = Players.LocalPlayer

-- Internal state management
local NebulaUI_Internal = {
    Windows = {},
    Notifications = {},
    Themes = {},
    Configs = {},
    MobileEnabled = UserInputService.TouchEnabled,
    DebugMode = false,
    Version = "2.0.1"
}

-- Enhanced Nebula Color Themes
local NEBULA_THEMES = {
    Default = {
        BACKGROUND = Color3.fromRGB(15, 15, 30),
        FRAME = Color3.fromRGB(30, 30, 60),
        ACCENT = Color3.fromRGB(138, 43, 226),
        ACCENT2 = Color3.fromRGB(0, 191, 255),
        ACCENT3 = Color3.fromRGB(147, 112, 219),
        TEXT = Color3.fromRGB(255, 255, 255),
        BUTTON = Color3.fromRGB(50, 50, 90),
        BUTTON_HOVER = Color3.fromRGB(70, 70, 120),
        SUCCESS = Color3.fromRGB(46, 204, 113),
        WARNING = Color3.fromRGB(241, 196, 15),
        ERROR = Color3.fromRGB(231, 76, 60),
        BORDER = Color3.fromRGB(60, 60, 100)
    },
    Dark = {
        BACKGROUND = Color3.fromRGB(10, 10, 15),
        FRAME = Color3.fromRGB(25, 25, 35),
        ACCENT = Color3.fromRGB(86, 156, 214),
        ACCENT2 = Color3.fromRGB(106, 176, 234),
        ACCENT3 = Color3.fromRGB(126, 196, 254),
        TEXT = Color3.fromRGB(240, 240, 240),
        BUTTON = Color3.fromRGB(45, 45, 55),
        BUTTON_HOVER = Color3.fromRGB(65, 65, 75),
        SUCCESS = Color3.fromRGB(56, 214, 123),
        WARNING = Color3.fromRGB(251, 206, 25),
        ERROR = Color3.fromRGB(241, 86, 70),
        BORDER = Color3.fromRGB(50, 50, 70)
    },
    Cyber = {
        BACKGROUND = Color3.fromRGB(10, 15, 20),
        FRAME = Color3.fromRGB(20, 30, 40),
        ACCENT = Color3.fromRGB(0, 255, 170),
        ACCENT2 = Color3.fromRGB(0, 200, 255),
        ACCENT3 = Color3.fromRGB(100, 255, 200),
        TEXT = Color3.fromRGB(220, 255, 255),
        BUTTON = Color3.fromRGB(30, 45, 60),
        BUTTON_HOVER = Color3.fromRGB(50, 65, 80),
        SUCCESS = Color3.fromRGB(0, 255, 170),
        WARNING = Color3.fromRGB(255, 200, 0),
        ERROR = Color3.fromRGB(255, 60, 90),
        BORDER = Color3.fromRGB(0, 150, 200)
    }
}

-- Device optimization
local DEVICE_SETTINGS = {
    Mobile = {
        BUTTON_SIZE = UDim2.new(0, 140, 0, 50),
        FONT_SIZE = 16,
        PADDING = 10,
        TOUCH_TARGET = 44
    },
    Desktop = {
        BUTTON_SIZE = UDim2.new(0, 120, 0, 40),
        FONT_SIZE = 14,
        PADDING = 5,
        TOUCH_TARGET = 30
    }
}

local currentDevice = NebulaUI_Internal.MobileEnabled and "Mobile" or "Desktop"
local DEVICE = DEVICE_SETTINGS[currentDevice]

-- Utility functions
local function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

local function createRippleEffect(button, position, theme)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, position.X - button.AbsolutePosition.X, 0, position.Y - button.AbsolutePosition.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Parent = button
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(ripple, tweenInfo, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function createGlowEffect(frame, theme)
    local glowContainer = Instance.new("Frame")
    glowContainer.Name = "GlowContainer"
    glowContainer.Size = UDim2.new(1, 20, 1, 20)
    glowContainer.Position = UDim2.new(0, -10, 0, -10)
    glowContainer.BackgroundTransparency = 1
    glowContainer.ZIndex = frame.ZIndex - 1
    
    for i = 1, 3 do
        local glow = Instance.new("Frame")
        glow.Name = "GlowLayer" .. i
        glow.Size = UDim2.new(1, 0, 1, 0)
        glow.Position = UDim2.new(0, 0, 0, 0)
        glow.BackgroundColor3 = theme.ACCENT
        glow.BackgroundTransparency = 0.7 + (i * 0.1)
        glow.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = glow
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = theme.ACCENT2
        stroke.Thickness = 1
        stroke.Transparency = 0.5
        stroke.Parent = glow
        
        glow.Parent = glowContainer
    end
    
    glowContainer.Parent = frame
    return glowContainer
end

local function makeDraggable(dragHandle, mainFrame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
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

-- Main Nebula UI Library
function NebulaUI:CreateWindow(options)
    options = options or {}
    
    local window = {
        Name = options.Name or "NebulaWindow",
        Title = options.Title or "Nebula UI",
        Subtitle = options.Subtitle or "Advanced GUI Framework",
        Size = options.Size or UDim2.new(0, 450, 0, 550),
        Position = options.Position or UDim2.new(0.5, -225, 0.5, -275),
        ThemeName = options.Theme or "Default",
        MinimizeKey = options.MinimizeKey or Enum.KeyCode.F9,
        SaveConfig = options.SaveConfig or true,
        ConfigFolder = options.ConfigFolder or "NebulaConfigs",
        Tabs = {},
        Flags = {},
        Elements = {},
        Open = true,
        ParentGui = nil,
        MobileButton = nil
    }
    
    setmetatable(window, self)
    
    -- Apply theme
    window.Theme = deepCopy(NEBULA_THEMES[window.ThemeName] or NEBULA_THEMES.Default)
    if options.CustomTheme then
        for key, value in pairs(options.CustomTheme) do
            if window.Theme[key] ~= nil then
                window.Theme[key] = value
            end
        end
    end
    
    -- Create GUI
    window:BuildGUI()
    
    -- Set up keybinds
    if window.MinimizeKey then
        window.KeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == window.MinimizeKey then
                window:Toggle()
            end
        end)
    end
    
    -- Mobile support
    if NebulaUI_Internal.MobileEnabled and options.MobileButton ~= false then
        window:CreateMobileButton()
    end
    
    table.insert(NebulaUI_Internal.Windows, window)
    
    if NebulaUI_Internal.DebugMode then
        window:Log("Window '" .. window.Name .. "' created successfully")
    end
    
    return window
end

function NebulaUI:BuildGUI()
    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = self.Name
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    -- Load configuration if enabled
    if self.SaveConfig then
        self:LoadConfig()
    end
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = self.Size
    mainFrame.Position = self.Position
    mainFrame.BackgroundColor3 = self.Theme.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = self.Theme.BORDER
    mainStroke.Thickness = 2
    mainStroke.Parent = mainFrame
    
    -- Add glow effect
    createGlowEffect(mainFrame, self.Theme)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = self.Theme.FRAME
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -80, 0, 30)
    titleLabel.Position = UDim2.new(0, 15, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = self.Theme.TEXT
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.SciFi
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Size = UDim2.new(1, -80, 0, 15)
    subtitleLabel.Position = UDim2.new(0, 15, 0, 30)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = self.Subtitle
    subtitleLabel.TextColor3 = self.Theme.TEXT
    subtitleLabel.TextTransparency = 0.3
    subtitleLabel.TextSize = 12
    subtitleLabel.Font = Enum.Font.SciFi
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
    local closeButton = self:CreateButton({
        Text = "✕",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 10),
        BackgroundColor3 = self.Theme.ERROR,
        TextColor3 = self.Theme.TEXT
    })
    
    closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Tab system container
    local tabSystem = Instance.new("Frame")
    tabSystem.Name = "TabSystem"
    tabSystem.Size = UDim2.new(1, -20, 1, -70)
    tabSystem.Position = UDim2.new(0, 10, 0, 60)
    tabSystem.BackgroundTransparency = 1
    
    -- Tab buttons container
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
    tabButtonsFrame.BackgroundTransparency = 1
    
    -- Tab content container
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent"
    tabContentFrame.Size = UDim2.new(1, 0, 1, -45)
    tabContentFrame.Position = UDim2.new(0, 0, 0, 45)
    tabContentFrame.BackgroundTransparency = 1
    tabContentFrame.ClipsDescendants = true
    
    -- Assemble GUI hierarchy
    titleLabel.Parent = titleBar
    subtitleLabel.Parent = titleBar
    closeButton.Parent = titleBar
    titleBar.Parent = mainFrame
    
    tabButtonsFrame.Parent = tabSystem
    tabContentFrame.Parent = tabSystem
    tabSystem.Parent = mainFrame
    
    mainFrame.Parent = gui
    gui.Parent = player.PlayerGui
    
    -- Store references
    self.GUI = gui
    self.MainFrame = mainFrame
    self.TitleBar = titleBar
    self.TabSystem = tabSystem
    self.TabButtonsFrame = tabButtonsFrame
    self.TabContentFrame = tabContentFrame
    
    -- Make draggable
    makeDraggable(titleBar, mainFrame)
    
    -- Initial notification
    self:Notify({
        Title = self.Title,
        Content = "Nebula UI loaded successfully!",
        Type = "SUCCESS",
        Duration = 3
    })
end

function NebulaUI:CreateMobileButton()
    local mobileButton = self:CreateButton({
        Text = "☰",
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Theme.ACCENT,
        TextColor3 = self.Theme.TEXT,
        TextSize = 24
    })
    
    mobileButton.ZIndex = 100
    mobileButton.Parent = player.PlayerGui
    
    mobileButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.MobileButton = mobileButton
end

function NebulaUI:Toggle()
    if self.GUI then
        self.Open = not self.Open
        self.GUI.Enabled = self.Open
        
        if self.Open then
            self:Notify({
                Title = self.Title,
                Content = "Window enabled",
                Type = "SUCCESS",
                Duration = 2
            })
        else
            self:Notify({
                Title = self.Title,
                Content = "Window disabled - Use " .. (self.MinimizeKey and self.MinimizeKey.Name or "F9") .. " to reopen",
                Type = "WARNING",
                Duration = 2
            })
        end
    end
end

-- Tab Management
function NebulaUI:CreateTab(options)
    options = options or {}
    
    local tab = {
        Name = options.Name or "Tab",
        Icon = options.Icon,
        Default = options.Default or false,
        Window = self,
        Elements = {},
        BadgeCount = 0
    }
    
    -- Create tab button
    local tabButton = self:CreateButton({
        Text = tab.Name,
        Size = UDim2.new(0.2, -5, 0, 35),
        BackgroundColor3 = self.Theme.FRAME,
        TextColor3 = self.Theme.TEXT
    })
    
    -- Create tab content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = tab.Name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 6
    tabContent.ScrollBarImageColor3 = self.Theme.ACCENT
    tabContent.Visible = false
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = tabContent
    layout.Padding = UDim.new(0, DEVICE.PADDING)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    tab.Button = tabButton
    tab.Content = tabContent
    
    -- Add to window
    table.insert(self.Tabs, tab)
    
    -- Position tab button
    local tabCount = #self.Tabs
    tabButton.Position = UDim2.new((tabCount-1) * 0.2, 5, 0, 0)
    tabButton.Parent = self.TabButtonsFrame
    tabContent.Parent = self.TabContentFrame
    
    -- Tab switching logic
    tabButton.MouseButton1Click:Connect(function()
        for _, otherTab in ipairs(self.Tabs) do
            otherTab.Content.Visible = false
        end
        tabContent.Visible = true
        self:Notify({
            Title = "Tab Changed",
            Content = "Now viewing: " .. tab.Name,
            Type = "SUCCESS",
            Duration = 1
        })
    end)
    
    -- Set as default if specified or first tab
    if tab.Default or tabCount == 1 then
        tabContent.Visible = true
    end
    
    -- Method chaining support
    setmetatable(tab, {
        __index = function(_, key)
            local method = NebulaUI[key]
            if method then
                return function(tabSelf, ...)
                    return method(self, tabSelf.Content, ...)
                end
            end
        end
    })
    
    return tab
end

-- Component Creation Methods
function NebulaUI:CreateButton(options)
    options = options or {}
    
    local button = Instance.new("TextButton")
    button.Name = options.Name or "Button"
    button.Size = options.Size or DEVICE.BUTTON_SIZE
    button.Position = options.Position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = options.BackgroundColor3 or self.Theme.BUTTON
    button.Text = options.Text or "Button"
    button.TextColor3 = options.TextColor3 or self.Theme.TEXT
    button.TextSize = options.TextSize or DEVICE.FONT_SIZE
    button.Font = options.Font or Enum.Font.SciFi
    button.AutoButtonColor = false
    button.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Theme.ACCENT2
    stroke.Thickness = 2
    stroke.Parent = button
    
    -- Enhanced hover effects
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.BUTTON_HOVER,
            Size = button.Size + UDim2.new(0, 5, 0, 5)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = options.BackgroundColor3 or self.Theme.BUTTON,
            Size = options.Size or DEVICE.BUTTON_SIZE
        })
        tween:Play()
    end)
    
    -- Click effects with ripple
    button.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Theme.ACCENT,
            Size = (options.Size or DEVICE.BUTTON_SIZE) - UDim2.new(0, 3, 0, 3)
        })
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Theme.BUTTON_HOVER,
            Size = (options.Size or DEVICE.BUTTON_SIZE) + UDim2.new(0, 5, 0, 5)
        })
        tween:Play()
    end)
    
    -- Ripple effect
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            createRippleEffect(button, input.Position, self.Theme)
        end
    end)
    
    -- Callback execution
    if options.Callback then
        button.MouseButton1Click:Connect(function()
            local success, err = pcall(options.Callback)
            if not success and NebulaUI_Internal.DebugMode then
                warn("NebulaUI: Button callback error - " .. tostring(err))
            end
        end)
    end
    
    return button
end

-- Public API Methods for adding elements to tabs
function NebulaUI:AddButton(tabContent, options)
    local button = self:CreateButton(options)
    button.Parent = tabContent
    return button
end

function NebulaUI:AddToggle(tabContent, options)
    options = options or {}
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = options.Name or "Toggle"
    toggleContainer.Size = UDim2.new(1, 0, 0, 40)
    toggleContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Toggle"
    label.TextColor3 = self.Theme.TEXT
    label.TextSize = DEVICE.FONT_SIZE
    label.Font = Enum.Font.SciFi
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0, 5)
    toggleButton.BackgroundColor3 = (options.Default and self.Theme.SUCCESS) or self.Theme.BUTTON
    toggleButton.Text = (options.Default and "ON") or "OFF"
    toggleButton.TextColor3 = self.Theme.TEXT
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.SciFi
    toggleButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Theme.ACCENT2
    stroke.Thickness = 2
    stroke.Parent = toggleButton
    
    local isToggled = options.Default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.Text = isToggled and "ON" or "OFF"
        
        local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and self.Theme.SUCCESS or self.Theme.BUTTON
        })
        tween:Play()
        
        if options.Callback then
            local success, err = pcall(options.Callback, isToggled)
            if not success and NebulaUI_Internal.DebugMode then
                warn("NebulaUI: Toggle callback error - " .. tostring(err))
            end
        end
        
        if options.Flag then
            self.Flags[options.Flag] = isToggled
            if self.SaveConfig then
                self:SaveConfig()
            end
        end
    end)
    
    toggleButton.Parent = toggleContainer
    toggleContainer.Parent = tabContent
    
    if options.Flag then
        self.Flags[options.Flag] = isToggled
    end
    
    return toggleContainer
end

function NebulaUI:AddSlider(tabContent, options)
    options = options or {}
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = options.Name or "Slider"
    sliderContainer.Size = UDim2.new(1, 0, 0, 60)
    sliderContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = (options.Name or "Slider") .. ": " .. (options.Default or options.Min or 0)
    label.TextColor3 = self.Theme.TEXT
    label.TextSize = DEVICE.FONT_SIZE
    label.Font = Enum.Font.SciFi
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = self.Theme.BUTTON
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((options.Default or options.Min or 0) / (options.Max or 100), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = self.Theme.ACCENT
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new((options.Default or options.Min or 0) / (options.Max or 100), -10, 0, -7)
    thumb.BackgroundColor3 = self.Theme.ACCENT2
    thumb.Text = ""
    thumb.AutoButtonColor = false
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 10)
    thumbCorner.Parent = thumb
    
    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Color = self.Theme.TEXT
    thumbStroke.Thickness = 2
    thumbStroke.Parent = thumb
    
    fill.Parent = track
    track.Parent = sliderContainer
    thumb.Parent = track
    
    -- Slider functionality
    local isSliding = false
    local min = options.Min or 0
    local max = options.Max or 100
    local currentValue = options.Default or min
    
    local function updateValue(value)
        currentValue = math.clamp(value, min, max)
        local percent = (currentValue - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, -10, 0, -7)
        label.Text = (options.Name or "Slider") .. ": " .. currentValue .. (options.Suffix or "")
        
        if options.Callback then
            local success, err = pcall(options.Callback, currentValue)
            if not success and NebulaUI_Internal.DebugMode then
                warn("NebulaUI: Slider callback error - " .. tostring(err))
            end
        end
        
        if options.Flag then
            self.Flags[options.Flag] = currentValue
            if self.SaveConfig then
                self:SaveConfig()
            end
        end
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
        end
    end)
    
    thumb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = input.Position.X - track.AbsolutePosition.X
            local percent = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            if options.Increment then
                value = math.floor(value / options.Increment) * options.Increment
            end
            updateValue(value)
        end
    end)
    
    sliderContainer.Parent = tabContent
    
    if options.Flag then
        self.Flags[options.Flag] = currentValue
    end
    
    return sliderContainer
end

function NebulaUI:AddLabel(tabContent, options)
    options = options or {}
    
    local label = Instance.new("TextLabel")
    label.Name = options.Name or "Label"
    label.Size = UDim2.new(1, 0, 0, options.Height or 30)
    label.BackgroundTransparency = 1
    label.Text = options.Text or "Label"
    label.TextColor3 = options.Color or self.Theme.TEXT
    label.TextSize = options.TextSize or DEVICE.FONT_SIZE
    label.Font = options.Font or Enum.Font.SciFi
    label.TextXAlignment = options.Alignment or Enum.TextXAlignment.Left
    label.TextWrapped = true
    
    label.Parent = tabContent
    return label
end

function NebulaUI:AddSection(tabContent, options)
    options = options or {}
    
    local section = Instance.new("Frame")
    section.Name = options.Name or "Section"
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "SectionLabel"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Section"
    label.TextColor3 = self.Theme.ACCENT
    label.TextSize = 16
    label.Font = Enum.Font.SciFi
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local line = Instance.new("Frame")
    line.Name = "Divider"
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 35)
    line.BackgroundColor3 = self.Theme.ACCENT2
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.5
    
    label.Parent = section
    line.Parent = section
    section.Parent = tabContent
    
    return section
end

-- Notification System
function NebulaUI:Notify(options)
    options = options or {}
    
    if not self.GUI then return end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 1, -100)
    notification.BackgroundColor3 = self.Theme.FRAME
    notification.BorderSizePixel = 0
    notification.ZIndex = 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local strokeColor = self.Theme.ACCENT
    if options.Type == "SUCCESS" then
        strokeColor = self.Theme.SUCCESS
    elseif options.Type == "WARNING" then
        strokeColor = self.Theme.WARNING
    elseif options.Type == "ERROR" then
        strokeColor = self.Theme.ERROR
    end
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = strokeColor
    stroke.Thickness = 2
    stroke.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = options.Title or "Notification"
    titleLabel.TextColor3 = strokeColor
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.SciFi
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 35)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = options.Content or ""
    messageLabel.TextColor3 = self.Theme.TEXT
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.SciFi
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = notification
    
    notification.Parent = self.GUI
    
    -- Animate in
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 1, -180)
    })
    tweenIn:Play()
    
    -- Auto remove after duration
    local duration = options.Duration or 5
    delay(duration, function()
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, -320, 1, -100)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    table.insert(NebulaUI_Internal.Notifications, notification)
end

-- Configuration System
function NebulaUI:SaveConfig(name)
    if not self.SaveConfig then return end
    
    local configName = name or self.Name
    local configData = {
        WindowPosition = self.MainFrame.Position,
        Flags = self.Flags,
        Theme = self.ThemeName
    }
    
    NebulaUI_Internal.Configs[configName] = configData
    
    if NebulaUI_Internal.DebugMode then
        self:Log("Config saved: " .. configName)
    end
end

function NebulaUI:LoadConfig(name)
    if not self.SaveConfig then return end
    
    local configName = name or self.Name
    local configData = NebulaUI_Internal.Configs[configName]
    
    if configData then
        if configData.WindowPosition then
            self.MainFrame.Position = configData.WindowPosition
        end
        
        if configData.Flags then
            self.Flags = configData.Flags
        end
        
        if configData.Theme then
            self:SetTheme(configData.Theme)
        end
        
        if NebulaUI_Internal.DebugMode then
            self:Log("Config loaded: " .. configName)
        end
    end
end

function NebulaUI:GetConfig()
    return {
        WindowPosition = self.MainFrame.Position,
        Flags = self.Flags,
        Theme = self.ThemeName
    }
end

-- Theme Management
function NebulaUI:SetTheme(themeName)
    if NEBULA_THEMES[themeName] then
        self.ThemeName = themeName
        self.Theme = deepCopy(NEBULA_THEMES[themeName])
        self:UpdateTheme()
        
        self:Notify({
            Title = "Theme Changed",
            Content = "Applied theme: " .. themeName,
            Type = "SUCCESS",
            Duration = 3
        })
    else
        warn("NebulaUI: Theme '" .. themeName .. "' not found")
    end
end

function NebulaUI:UpdateTheme()
    -- Update all UI elements with new theme
    if self.MainFrame then
        self.MainFrame.BackgroundColor3 = self.Theme.BACKGROUND
        self.TitleBar.BackgroundColor3 = self.Theme.FRAME
    end
end

-- Utility Methods
function NebulaUI:Destroy()
    if self.KeyConnection then
        self.KeyConnection:Disconnect()
    end
    if self.GUI then
        self.GUI:Destroy()
    end
    if self.MobileButton then
        self.MobileButton:Destroy()
    end
    
    for i, window in ipairs(NebulaUI_Internal.Windows) do
        if window == self then
            table.remove(NebulaUI_Internal.Windows, i)
            break
        end
    end
end

function NebulaUI:SetVisible(visible)
    if self.GUI then
        self.GUI.Enabled = visible
        self.Open = visible
    end
end

function NebulaUI:Log(message)
    if NebulaUI_Internal.DebugMode then
        print("[NebulaUI] " .. message)
    end
end

-- Library initialization
function NebulaUI:Initialize()
    self:Notify({
        Title = self.Title,
        Content = "Nebula UI v" .. NebulaUI_Internal.Version .. " initialized!",
        Type = "SUCCESS",
        Duration = 3
    })
end

-- Global library methods
function NebulaUI.SetDebugMode(enabled)
    NebulaUI_Internal.DebugMode = enabled
    print("NebulaUI: Debug mode " .. (enabled and "enabled" or "disabled"))
end

function NebulaUI.GetVersion()
    return NebulaUI_Internal.Version
end

function NebulaUI.GetDeviceInfo()
    return {
        IsMobile = NebulaUI_Internal.MobileEnabled,
        DeviceType = currentDevice,
        Settings = DEVICE
    }
end

-- Make the library available globally
getgenv().NebulaUI = NebulaUI

-- Auto-initialize if in testing environment
if NebulaUI_Internal.DebugMode then
    print("Nebula UI Library v" .. NebulaUI.GetVersion() .. " loaded successfully")
    print("Device: " .. currentDevice .. " | Mobile: " .. tostring(NebulaUI_Internal.MobileEnabled))
end

return NebulaUI
