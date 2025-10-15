-- Nebula UI Library v2.0
-- Advanced Roblox GUI Library with Mobile Support
-- Created by: AI Assistant
-- Last Updated: 2024

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
    DebugMode = false
}

-- Default theme configurations
local DEFAULT_THEMES = {
    Default = {
        Background = Color3.fromRGB(15, 15, 30),
        Foreground = Color3.fromRGB(30, 30, 60),
        Accent = Color3.fromRGB(138, 43, 226),
        Accent2 = Color3.fromRGB(0, 191, 255),
        AccentGradient = Color3.fromRGB(147, 112, 219),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Border = Color3.fromRGB(50, 50, 90)
    },
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        Foreground = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(86, 156, 214),
        Accent2 = Color3.fromRGB(66, 135, 245),
        AccentGradient = Color3.fromRGB(106, 176, 234),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(56, 214, 123),
        Warning = Color3.fromRGB(251, 206, 25),
        Error = Color3.fromRGB(241, 86, 70),
        Border = Color3.fromRGB(60, 60, 60)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Foreground = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 122, 255),
        Accent2 = Color3.fromRGB(90, 200, 250),
        AccentGradient = Color3.fromRGB(100, 210, 255),
        Text = Color3.fromRGB(0, 0, 0),
        TextDark = Color3.fromRGB(80, 80, 80),
        Success = Color3.fromRGB(52, 199, 89),
        Warning = Color3.fromRGB(255, 149, 0),
        Error = Color3.fromRGB(255, 59, 48),
        Border = Color3.fromRGB(220, 220, 220)
    },
    Crimson = {
        Background = Color3.fromRGB(20, 15, 15),
        Foreground = Color3.fromRGB(40, 20, 20),
        Accent = Color3.fromRGB(220, 20, 60),
        Accent2 = Color3.fromRGB(180, 30, 30),
        AccentGradient = Color3.fromRGB(240, 50, 80),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 180),
        Success = Color3.fromRGB(50, 200, 100),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(220, 20, 60),
        Border = Color3.fromRGB(80, 40, 40)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 30, 45),
        Foreground = Color3.fromRGB(25, 50, 75),
        Accent = Color3.fromRGB(0, 150, 199),
        Accent2 = Color3.fromRGB(72, 202, 228),
        AccentGradient = Color3.fromRGB(100, 220, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 220, 255),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Border = Color3.fromRGB(40, 100, 150)
    },
    Forest = {
        Background = Color3.fromRGB(15, 30, 20),
        Foreground = Color3.fromRGB(25, 50, 35),
        Accent = Color3.fromRGB(76, 175, 80),
        Accent2 = Color3.fromRGB(56, 142, 60),
        AccentGradient = Color3.fromRGB(105, 200, 110),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 220, 180),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Border = Color3.fromRGB(40, 90, 50)
    }
}

-- Animation presets
local ANIMATION_PRESETS = {
    Default = {
        Speed = 0.3,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    },
    Bounce = {
        Speed = 0.5,
        EasingStyle = Enum.EasingStyle.Bounce,
        EasingDirection = Enum.EasingDirection.Out
    },
    Elastic = {
        Speed = 0.6,
        EasingStyle = Enum.EasingStyle.Elastic,
        EasingDirection = Enum.EasingDirection.Out
    }
}

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

local function createRippleEffect(button, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, position.X - button.AbsolutePosition.X, 0, position.Y - button.AbsolutePosition.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Parent = button
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
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
        glow.BackgroundColor3 = theme.Accent
        glow.BackgroundTransparency = 0.7 + (i * 0.1)
        glow.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = glow
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = theme.Accent2
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
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Main Window Class
function NebulaUI:CreateWindow(options)
    options = options or {}
    
    local window = {
        Name = options.Name or "NebulaWindow",
        Title = options.Title or "Nebula UI",
        Subtitle = options.Subtitle or "Advanced GUI Library",
        Size = options.Size or UDim2.new(0, 500, 0, 600),
        Position = options.Position or UDim2.new(0.5, -250, 0.5, -300),
        Theme = options.Theme or "Default",
        MinimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl,
        SaveConfig = options.SaveConfig or false,
        ConfigFolder = options.ConfigFolder or "NebulaConfigs",
        Tabs = {},
        Flags = {},
        Elements = {},
        Open = true,
        ParentGui = nil
    }
    
    setmetatable(window, self)
    
    -- Apply theme
    window.CurrentTheme = deepCopy(DEFAULT_THEMES[window.Theme] or DEFAULT_THEMES.Default)
    if options.CustomTheme then
        for key, value in pairs(options.CustomTheme) do
            if window.CurrentTheme[key] ~= nil then
                window.CurrentTheme[key] = value
            end
        end
    end
    
    -- Create GUI
    window:BuildGUI()
    
    -- Set up keybinds
    if window.MinimizeKey then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
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
        print("NebulaUI: Window '" .. window.Name .. "' created successfully")
    end
    
    return window
end

function NebulaUI:BuildGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = self.Name
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    if self.SaveConfig then
        self:LoadConfig()
    end
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = self.Size
    mainFrame.Position = self.Position
    mainFrame.BackgroundColor3 = self.CurrentTheme.Background
    mainFrame.BorderSizePixel = 0
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = self.CurrentTheme.Border
    mainStroke.Thickness = 2
    mainStroke.Parent = mainFrame
    
    createGlowEffect(mainFrame, self.CurrentTheme)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = self.CurrentTheme.Foreground
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = self.CurrentTheme.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.SciFi
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Size = UDim2.new(1, -80, 0, 15)
    subtitleLabel.Position = UDim2.new(0, 10, 0, 20)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = self.Subtitle
    subtitleLabel.TextColor3 = self.CurrentTheme.TextDark
    subtitleLabel.TextSize = 12
    subtitleLabel.Font = Enum.Font.SciFi
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeButton = self:CreateButton({
        Text = "X",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 5),
        BackgroundColor3 = self.CurrentTheme.Error
    })
    
    closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Tab System
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
    tabButtonsFrame.Position = UDim2.new(0, 10, 0, 50)
    tabButtonsFrame.BackgroundTransparency = 1
    
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent"
    tabContentFrame.Size = UDim2.new(1, -20, 1, -100)
    tabContentFrame.Position = UDim2.new(0, 10, 0, 100)
    tabContentFrame.BackgroundTransparency = 1
    
    -- Assemble GUI
    titleLabel.Parent = titleBar
    subtitleLabel.Parent = titleBar
    closeButton.Parent = titleBar
    titleBar.Parent = mainFrame
    tabButtonsFrame.Parent = mainFrame
    tabContentFrame.Parent = mainFrame
    mainFrame.Parent = gui
    gui.Parent = player.PlayerGui
    
    self.GUI = gui
    self.MainFrame = mainFrame
    self.TitleBar = titleBar
    self.TabButtonsFrame = tabButtonsFrame
    self.TabContentFrame = tabContentFrame
    
    makeDraggable(titleBar, mainFrame)
    
    self:Notify({
        Title = self.Title,
        Content = "Window loaded successfully!",
        Type = "Success",
        Duration = 3
    })
end

function NebulaUI:CreateMobileButton()
    local mobileButton = self:CreateButton({
        Text = "☰",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.CurrentTheme.Accent
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
                Type = "Success",
                Duration = 2
            })
        else
            self:Notify({
                Title = self.Title,
                Content = "Window disabled",
                Type = "Warning",
                Duration = 2
            })
        end
    end
end

function NebulaUI:CreateTab(options)
    options = options or {}
    
    local tab = {
        Name = options.Name or "Tab",
        Icon = options.Icon,
        Default = options.Default or false,
        Window = self,
        Elements = {}
    }
    
    -- Create tab button
    local tabButton = self:CreateButton({
        Text = tab.Name,
        Size = UDim2.new(0.2, -5, 0, 35),
        BackgroundColor3 = self.CurrentTheme.Foreground
    })
    
    -- Create tab content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = tab.Name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 6
    tabContent.ScrollBarImageColor3 = self.CurrentTheme.Accent
    tabContent.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = tabContent
    layout.Padding = UDim.new(0, 5)
    
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
            Type = "Success",
            Duration = 2
        })
    end)
    
    -- Set as default if specified
    if tab.Default or tabCount == 1 then
        tabContent.Visible = true
    end
    
    -- Method chaining support
    setmetatable(tab, {
        __index = function(_, key)
            local method = NebulaUI[key]
            if method then
                return function(self, ...)
                    return method(self.Window, ...)
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
    button.Size = options.Size or UDim2.new(1, 0, 0, 40)
    button.Position = options.Position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = options.BackgroundColor3 or self.CurrentTheme.Accent
    button.Text = options.Text or "Button"
    button.TextColor3 = options.TextColor3 or self.CurrentTheme.Text
    button.TextSize = options.TextSize or 14
    button.Font = options.Font or Enum.Font.SciFi
    button.AutoButtonColor = false
    button.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.CurrentTheme.Border
    stroke.Thickness = 2
    stroke.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = self.CurrentTheme.Accent2,
            Size = button.Size + UDim2.new(0, 5, 0, 5)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = options.BackgroundColor3 or self.CurrentTheme.Accent,
            Size = options.Size or UDim2.new(1, 0, 0, 40)
        })
        tween:Play()
    end)
    
    -- Click effects
    button.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = self.CurrentTheme.AccentGradient,
            Size = (options.Size or UDim2.new(1, 0, 0, 40)) - UDim2.new(0, 3, 0, 3)
        })
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = self.CurrentTheme.Accent2,
            Size = (options.Size or UDim2.new(1, 0, 0, 40)) + UDim2.new(0, 5, 0, 5)
        })
        tween:Play()
    end)
    
    -- Ripple effect
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            createRippleEffect(button, input.Position)
        end
    end)
    
    -- Callback
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

function NebulaUI:AddButton(tab, options)
    local button = self:CreateButton(options)
    button.Parent = tab.Content
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Content.UIListLayout.AbsoluteContentSize.Y)
    return button
end

function NebulaUI:AddToggle(tab, options)
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
    label.TextColor3 = self.CurrentTheme.Text
    label.TextSize = 14
    label.Font = Enum.Font.SciFi
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0, 5)
    toggleButton.BackgroundColor3 = (options.Default and self.CurrentTheme.Success) or self.CurrentTheme.Foreground
    toggleButton.Text = (options.Default and "ON") or "OFF"
    toggleButton.TextColor3 = self.CurrentTheme.Text
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.SciFi
    toggleButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.CurrentTheme.Border
    stroke.Thickness = 2
    stroke.Parent = toggleButton
    
    local isToggled = options.Default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.Text = isToggled and "ON" or "OFF"
        
        local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and self.CurrentTheme.Success or self.CurrentTheme.Foreground
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
    toggleContainer.Parent = tab.Content
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Content.UIListLayout.AbsoluteContentSize.Y)
    
    if options.Flag then
        self.Flags[options.Flag] = isToggled
    end
    
    return toggleContainer
end

function NebulaUI:AddSlider(tab, options)
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
    label.TextColor3 = self.CurrentTheme.Text
    label.TextSize = 14
    label.Font = Enum.Font.SciFi
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = self.CurrentTheme.Foreground
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((options.Default or options.Min or 0) / (options.Max or 100), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = self.CurrentTheme.Accent
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new((options.Default or options.Min or 0) / (options.Max or 100), -10, 0, -7)
    thumb.BackgroundColor3 = self.CurrentTheme.Accent2
    thumb.Text = ""
    thumb.AutoButtonColor = false
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 10)
    thumbCorner.Parent = thumb
    
    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Color = self.CurrentTheme.Text
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
    
    sliderContainer.Parent = tab.Content
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Content.UIListLayout.AbsoluteContentSize.Y)
    
    if options.Flag then
        self.Flags[options.Flag] = currentValue
    end
    
    return sliderContainer
end

-- Notification System
function NebulaUI:Notify(options)
    options = options or {}
    
    if not self.GUI then return end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 1, -100)
    notification.BackgroundColor3 = self.CurrentTheme.Foreground
    notification.BorderSizePixel = 0
    notification.ZIndex = 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local strokeColor = self.CurrentTheme.Accent
    if options.Type == "Success" then
        strokeColor = self.CurrentTheme.Success
    elseif options.Type == "Warning" then
        strokeColor = self.CurrentTheme.Warning
    elseif options.Type == "Error" then
        strokeColor = self.CurrentTheme.Error
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
    messageLabel.TextColor3 = self.CurrentTheme.Text
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
        Flags = self.Flags
    }
    
    NebulaUI_Internal.Configs[configName] = configData
    
    if NebulaUI_Internal.DebugMode then
        print("NebulaUI: Config saved - " .. configName)
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
            -- Apply flag values to elements (would need element references)
        end
        
        if NebulaUI_Internal.DebugMode then
            print("NebulaUI: Config loaded - " .. configName)
        end
    end
end

function NebulaUI:GetConfig()
    return {
        WindowPosition = self.MainFrame.Position,
        Flags = self.Flags
    }
end

-- Theme Management
function NebulaUI:SetTheme(themeName)
    if DEFAULT_THEMES[themeName] then
        self.Theme = themeName
        self.CurrentTheme = deepCopy(DEFAULT_THEMES[themeName])
        self:UpdateTheme()
        
        self:Notify({
            Title = "Theme Changed",
            Content = "Applied theme: " .. themeName,
            Type = "Success",
            Duration = 3
        })
    else
        warn("NebulaUI: Theme '" .. themeName .. "' not found")
    end
end

function NebulaUI:UpdateTheme()
    -- This would update all UI elements with the new theme
    -- Implementation would require storing references to all created elements
    if self.MainFrame then
        self.MainFrame.BackgroundColor3 = self.CurrentTheme.Background
    end
end

-- Utility Methods
function NebulaUI:Destroy()
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

-- Library initialization
function NebulaUI:Initialize()
    self:Notify({
        Title = self.Title,
        Content = "Nebula UI initialized successfully!",
        Type = "Success",
        Duration = 3
    })
end

-- Global library methods
function NebulaUI.SetDebugMode(enabled)
    NebulaUI_Internal.DebugMode = enabled
    print("NebulaUI: Debug mode " .. (enabled and "enabled" or "disabled"))
end

function NebulaUI.GetVersion()
    return "2.0.0"
end

-- Make the library available globally
getgenv().NebulaUI = NebulaUI

if NebulaUI_Internal.DebugMode then
    print("Nebula UI Library v" .. NebulaUI.GetVersion() .. " loaded successfully")
end

return NebulaUI
