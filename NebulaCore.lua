-- Nebula UI Library v4.0
-- Modern Mobile-First GUI Framework for Roblox
-- Enhanced with Advanced Animations, Debug System & Performance Optimizations

local Nebula = {}
Nebula.__index = Nebula

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")

-- Local player reference
local player = Players.LocalPlayer

-- Modern Color System (Fluent UI Inspired)
local MODERN_THEMES = {
    Default = {
        PRIMARY = Color3.fromRGB(0, 120, 215),
        PRIMARY_LIGHT = Color3.fromRGB(96, 171, 232),
        SURFACE = Color3.fromRGB(32, 32, 32),
        SURFACE_VARIANT = Color3.fromRGB(42, 42, 42),
        BACKGROUND = Color3.fromRGB(25, 25, 25),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(255, 255, 255),
        ON_SURFACE_VARIANT = Color3.fromRGB(180, 180, 180),
        OUTLINE = Color3.fromRGB(65, 65, 65),
        SUCCESS = Color3.fromRGB(52, 199, 89),
        WARNING = Color3.fromRGB(255, 149, 0),
        ERROR = Color3.fromRGB(255, 59, 48),
        SHADOW = Color3.fromRGB(0, 0, 0)
    },
    Light = {
        PRIMARY = Color3.fromRGB(0, 120, 215),
        PRIMARY_LIGHT = Color3.fromRGB(96, 171, 232),
        SURFACE = Color3.fromRGB(255, 255, 255),
        SURFACE_VARIANT = Color3.fromRGB(249, 249, 249),
        BACKGROUND = Color3.fromRGB(243, 243, 243),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(32, 32, 32),
        ON_SURFACE_VARIANT = Color3.fromRGB(117, 117, 117),
        OUTLINE = Color3.fromRGB(225, 225, 225),
        SUCCESS = Color3.fromRGB(16, 124, 16),
        WARNING = Color3.fromRGB(157, 93, 0),
        ERROR = Color3.fromRGB(197, 0, 0),
        SHADOW = Color3.fromRGB(0, 0, 0)
    },
    Dark = {
        PRIMARY = Color3.fromRGB(96, 171, 232),
        PRIMARY_LIGHT = Color3.fromRGB(120, 185, 240),
        SURFACE = Color3.fromRGB(32, 32, 32),
        SURFACE_VARIANT = Color3.fromRGB(42, 42, 42),
        BACKGROUND = Color3.fromRGB(25, 25, 25),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(255, 255, 255),
        ON_SURFACE_VARIANT = Color3.fromRGB(180, 180, 180),
        OUTLINE = Color3.fromRGB(65, 65, 65),
        SUCCESS = Color3.fromRGB(52, 199, 89),
        WARNING = Color3.fromRGB(255, 149, 0),
        ERROR = Color3.fromRGB(255, 59, 48),
        SHADOW = Color3.fromRGB(0, 0, 0)
    },
    Modern = {
        PRIMARY = Color3.fromRGB(0, 184, 148),
        PRIMARY_LIGHT = Color3.fromRGB(85, 239, 203),
        SURFACE = Color3.fromRGB(248, 250, 252),
        SURFACE_VARIANT = Color3.fromRGB(241, 245, 249),
        BACKGROUND = Color3.fromRGB(226, 232, 240),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(30, 41, 59),
        ON_SURFACE_VARIANT = Color3.fromRGB(100, 116, 139),
        OUTLINE = Color3.fromRGB(203, 213, 225),
        SUCCESS = Color3.fromRGB(34, 197, 94),
        WARNING = Color3.fromRGB(245, 158, 11),
        ERROR = Color3.fromRGB(239, 68, 68),
        SHADOW = Color3.fromRGB(51, 65, 85)
    }
}

-- Enhanced Mobile Settings
local MOBILE_SETTINGS = {
    SIDEBAR_WIDTH = UDim.new(0.7, 0),
    SIDEBAR_MIN_WIDTH = 280,
    CONTENT_PADDING = 20,
    ELEMENT_HEIGHT = 52,
    CORNER_RADIUS = 12,
    ANIMATION_DURATION = 0.3,
    TOUCH_TARGET = 44
}

-- Internal State
local Nebula_Internal = {
    Windows = {},
    Toasts = {},
    CurrentTheme = "Default",
    IsMobile = UserInputService.TouchEnabled,
    Version = "4.0.0",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "NebulaUI",
        FileName = "Configuration"
    },
    ToggleUIKeybind = "K",
    DebugMode = false
}

-- Configuration Saving System
local ConfigurationSystem = {
    DataStore = nil,
    Configurations = {}
}

function ConfigurationSystem:Initialize()
    if not Nebula_Internal.ConfigurationSaving.Enabled then return end
    
    local success, result = pcall(function()
        ConfigurationSystem.DataStore = game:GetService("DataStoreService"):GetDataStore(
            Nebula_Internal.ConfigurationSaving.FolderName or "NebulaUI",
            Nebula_Internal.ConfigurationSaving.FileName or "Configuration"
        )
        
        -- Load existing configuration
        local loaded = ConfigurationSystem.DataStore:GetAsync(tostring(player.UserId))
        if loaded then
            ConfigurationSystem.Configurations = loaded
        end
    end)
    
    if not success then
        warn("Nebula UI: Configuration saving failed to initialize - " .. result)
    end
end

function ConfigurationSystem:SaveConfiguration()
    if not ConfigurationSystem.DataStore then return end
    
    local success, result = pcall(function()
        ConfigurationSystem.DataStore:SetAsync(tostring(player.UserId), ConfigurationSystem.Configurations)
    end)
    
    if not success then
        warn("Nebula UI: Failed to save configuration - " .. result)
    end
end

function ConfigurationSystem:SetFlag(flag, value)
    ConfigurationSystem.Configurations[flag] = value
    if Nebula_Internal.ConfigurationSaving.Enabled then
        ConfigurationSystem:SaveConfiguration()
    end
end

function ConfigurationSystem:GetFlag(flag, defaultValue)
    return ConfigurationSystem.Configurations[flag] or defaultValue
end

-- Enhanced Event System
local EventSystem = {}
EventSystem.__index = EventSystem

function EventSystem.new()
    local self = setmetatable({}, EventSystem)
    self._listeners = {}
    return self
end

function EventSystem:Fire(eventName, ...)
    if not self._listeners[eventName] then return end
    
    for callbackId, callback in pairs(self._listeners[eventName]) do
        local success, result = pcall(callback, ...)
        if not success then
            warn("Nebula UI: Event callback error - " .. result)
        end
    end
end

function EventSystem:Connect(eventName, callback)
    if not self._listeners[eventName] then
        self._listeners[eventName] = {}
    end
    
    local callbackId = HttpService:GenerateGUID(false)
    self._listeners[eventName][callbackId] = callback
    
    return {
        Disconnect = function()
            if self._listeners[eventName] then
                self._listeners[eventName][callbackId] = nil
            end
        end
    }
end

-- Notification System
local NotificationManager = {}
NotificationManager.__index = NotificationManager

function NotificationManager.new(parentGUI)
    local self = setmetatable({}, NotificationManager)
    self.Parent = parentGUI
    self.ActiveNotifications = {}
    return self
end

function NotificationManager:ShowNotification(options)
    local theme = MODERN_THEMES[Nebula_Internal.CurrentTheme]
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 100)
    notification.Position = UDim2.new(1, -320, 1, -120)
    notification.BackgroundColor3 = theme.SURFACE
    notification.BorderSizePixel = 0
    notification.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236773"
    shadow.ImageColor3 = theme.SHADOW
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = notification.ZIndex - 1
    shadow.Parent = notification
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 16, 0, 16)
    icon.BackgroundTransparency = 1
    icon.Image = self:GetIconForType(options.Image or "info")
    icon.ImageColor3 = theme.PRIMARY
    icon.ZIndex = notification.ZIndex + 1
    icon.Parent = notification
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 0, 24)
    title.Position = UDim2.new(0, 56, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = options.Title or "Notification"
    title.TextColor3 = theme.ON_SURFACE
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = notification.ZIndex + 1
    title.Parent = notification
    
    local content = Instance.new("TextLabel")
    content.Name = "Content"
    content.Size = UDim2.new(1, -60, 0, 40)
    content.Position = UDim2.new(0, 56, 0, 40)
    content.BackgroundTransparency = 1
    content.Text = options.Content or ""
    content.TextColor3 = theme.ON_SURFACE_VARIANT
    content.TextSize = 14
    content.Font = Enum.Font.SourceSans
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextWrapped = true
    content.ZIndex = notification.ZIndex + 1
    content.Parent = notification
    
    notification.Parent = self.Parent
    
    -- Animate in
    notification.Position = UDim2.new(1, 300, 1, -120)
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -120)
    })
    tweenIn:Play()
    
    table.insert(self.ActiveNotifications, notification)
    
    -- Auto dismiss
    local duration = options.Duration or 6.5
    if duration > 0 then
        task.delay(duration, function()
            self:DismissNotification(notification)
        end)
    end
    
    return notification
end

function NotificationManager:DismissNotification(notification)
    if not notification or not notification.Parent then return end
    
    local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 300, 1, -120)
    })
    tweenOut:Play()
    
    tweenOut.Completed:Wait()
    notification:Destroy()
    
    for i, notif in ipairs(self.ActiveNotifications) do
        if notif == notification then
            table.remove(self.ActiveNotifications, i)
            break
        end
    end
end

function NotificationManager:GetIconForType(iconType)
    local icons = {
        rewind = "rbxassetid://6026568198",
        info = "rbxassetid://6026568208",
        success = "rbxassetid://6026568263",
        warning = "rbxassetid://6026568243",
        error = "rbxassetid://6026568278"
    }
    return icons[iconType] or icons.info
end

-- Window Class
local Window = {}
Window.__index = Window

function Window.new(nebula, options)
    local self = setmetatable({}, Window)
    
    self.Nebula = nebula
    self.Name = options.Name or "NebulaWindow"
    self.Icon = options.Icon
    self.ThemeName = options.Theme or Nebula_Internal.CurrentTheme
    self.Tabs = {}
    self.Flags = {}
    self.IsOpen = false
    self.ConfigurationSaving = options.ConfigurationSaving or Nebula_Internal.ConfigurationSaving
    
    self:BuildGUI()
    
    -- Set up UI toggle keybind
    if options.ToggleUIKeybind then
        self:SetupToggleKeybind(options.ToggleUIKeybind)
    end
    
    return self
end

function Window:BuildGUI()
    local theme = MODERN_THEMES[self.ThemeName]
    
    -- Main GUI Container
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = self.Name
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.DisplayOrder = 10
    self.GUI.Parent = CoreGui
    
    -- Main Container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = theme.SURFACE
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236773"
    shadow.ImageColor3 = theme.SHADOW
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = theme.PRIMARY
    header.BorderSizePixel = 0
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 40, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.Name
    title.TextColor3 = theme.ON_PRIMARY
    title.TextSize = 18
    title.Font = Enum.Font.SourceSansSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = theme.ON_PRIMARY
    closeButton.TextSize = 24
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = header
    
    closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    header.Parent = mainFrame
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = theme.SURFACE_VARIANT
    tabContainer.BorderSizePixel = 0
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 3
    tabList.ScrollBarImageColor3 = theme.OUTLINE
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = tabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabList
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -120, 1, -40)
    contentContainer.Position = UDim2.new(0, 120, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = mainFrame
    
    self.MainFrame = mainFrame
    self.TabList = tabList
    self.ContentContainer = contentContainer
    self.NotificationManager = NotificationManager.new(self.GUI)
    
    mainFrame.Parent = self.GUI
    
    -- Initially hidden
    self.GUI.Enabled = false
end

function Window:SetupToggleKeybind(keybind)
    local keyCode = Enum.KeyCode[keybind]
    if not keyCode then
        warn("Nebula UI: Invalid keybind - " .. keybind)
        return
    end
    
    ContextActionService:BindAction("ToggleNebulaUI", function(_, inputState)
        if inputState == Enum.UserInputState.Begin then
            self:Toggle()
        end
    end, false, keyCode)
end

function Window:Toggle()
    self.IsOpen = not self.IsOpen
    self.GUI.Enabled = self.IsOpen
    
    if self.IsOpen then
        self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
        self.MainFrame.Size = UDim2.new(0, 500, 0, 0)
        
        local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 400)
        })
        tween:Play()
    else
        local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 500, 0, 0)
        })
        tween:Play()
        
        tween.Completed:Wait()
        self.GUI.Enabled = false
    end
end

function Window:CreateTab(name, icon)
    local tab = {
        Name = name,
        Icon = icon,
        Content = nil,
        Window = self
    }
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = "  " .. name
    tabButton.TextColor3 = theme.ON_SURFACE_VARIANT
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.SourceSansSemibold
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Create content frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = name .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = theme.OUTLINE
    contentFrame.Visible = false
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentFrame
    contentLayout.Padding = UDim.new(0, 8)
    
    tabButton.Parent = self.TabList
    contentFrame.Parent = self.ContentContainer
    
    tab.Button = tabButton
    tab.Content = contentFrame
    
    table.insert(self.Tabs, tab)
    
    -- Tab selection logic
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(selectedTab)
    for _, tab in ipairs(self.Tabs) do
        tab.Content.Visible = false
        tab.Button.TextColor3 = MODERN_THEMES[self.ThemeName].ON_SURFACE_VARIANT
    end
    
    selectedTab.Content.Visible = true
    selectedTab.Button.TextColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
end

-- UI Elements
function Window:CreateButton(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local button = Instance.new("TextButton")
    button.Name = options.Name or "Button"
    button.Size = UDim2.new(1, -20, 0, 36)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = theme.PRIMARY
    button.TextColor3 = theme.ON_PRIMARY
    button.Text = options.Name or "Button"
    button.TextSize = 14
    button.Font = Enum.Font.SourceSansSemibold
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.PRIMARY_LIGHT
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.PRIMARY
        }):Play()
    end)
    
    -- Click handler
    if options.Callback then
        button.MouseButton1Click:Connect(function()
            pcall(options.Callback)
        end)
    end
    
    button.Parent = tab.Content
    
    return button
end

function Window:CreateToggle(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = options.Name or "Toggle"
    toggleContainer.Size = UDim2.new(1, -20, 0, 36)
    toggleContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Toggle"
    label.TextColor3 = theme.ON_SURFACE
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "Switch"
    toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
    toggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
    toggleSwitch.BackgroundColor3 = theme.OUTLINE
    toggleSwitch.BorderSizePixel = 0
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch
    
    local toggleThumb = Instance.new("Frame")
    toggleThumb.Name = "Thumb"
    toggleThumb.Size = UDim2.new(0, 16, 0, 16)
    toggleThumb.Position = UDim2.new(0, 2, 0, 2)
    toggleThumb.BackgroundColor3 = theme.SURFACE
    toggleThumb.BorderSizePixel = 0
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = toggleThumb
    toggleThumb.Parent = toggleSwitch
    
    toggleSwitch.Parent = toggleContainer
    
    local isToggled = options.CurrentValue or false
    if options.Flag then
        isToggled = ConfigurationSystem:GetFlag(options.Flag, isToggled)
    end
    
    local function updateToggle()
        TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and theme.PRIMARY or theme.OUTLINE
        }):Play()
        
        TweenService:Create(toggleThumb, TweenInfo.new(0.2), {
            Position = isToggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
        
        if options.Callback then
            pcall(options.Callback, isToggled)
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, isToggled)
        end
    end
    
    toggleSwitch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isToggled = not isToggled
            updateToggle()
        end
    end)
    
    updateToggle()
    toggleContainer.Parent = tab.Content
    
    return {
        SetValue = function(self, value)
            isToggled = value
            updateToggle()
        end,
        GetValue = function(self)
            return isToggled
        end
    }
end

function Window:CreateSlider(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = options.Name or "Slider"
    sliderContainer.Size = UDim2.new(1, -20, 0, 60)
    sliderContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Slider"
    label.TextColor3 = theme.ON_SURFACE
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(options.CurrentValue or options.Range[1]) .. (options.Suffix or "")
    valueLabel.TextColor3 = theme.ON_SURFACE_VARIANT
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderContainer
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = theme.OUTLINE
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = theme.PRIMARY
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    fill.Parent = track
    
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = UDim2.new(0, -8, 0.5, -8)
    thumb.BackgroundColor3 = theme.PRIMARY
    thumb.BorderSizePixel = 0
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    thumb.Parent = track
    
    track.Parent = sliderContainer
    
    local minValue = options.Range[1]
    local maxValue = options.Range[2]
    local increment = options.Increment or 1
    local currentValue = options.CurrentValue or minValue
    if options.Flag then
        currentValue = ConfigurationSystem:GetFlag(options.Flag, currentValue)
    end
    
    local function updateSlider(value)
        currentValue = math.floor((value - minValue) / increment) * increment + minValue
        currentValue = math.clamp(currentValue, minValue, maxValue)
        
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        thumb.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(currentValue) .. (options.Suffix or "")
        
        if options.Callback then
            pcall(options.Callback, currentValue)
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, currentValue)
        end
    end
    
    local function onInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local relativeX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
            local percentage = relativeX / track.AbsoluteSize.X
            updateSlider(percentage * (maxValue - minValue) + minValue)
        end
    end
    
    track.InputBegan:Connect(onInput)
    track.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and input.UserInputState == Enum.UserInputState.Change then
            onInput(input)
        end
    end)
    
    updateSlider(currentValue)
    sliderContainer.Parent = tab.Content
    
    return {
        SetValue = function(self, value)
            updateSlider(value)
        end,
        GetValue = function(self)
            return currentValue
        end
    }
end

function Window:CreateInput(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = options.Name or "Input"
    inputContainer.Size = UDim2.new(1, -20, 0, 36)
    inputContainer.BackgroundTransparency = 1
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, 0, 1, 0)
    textBox.BackgroundColor3 = theme.SURFACE_VARIANT
    textBox.TextColor3 = theme.ON_SURFACE
    textBox.PlaceholderText = options.PlaceholderText or ""
    textBox.Text = options.CurrentValue or ""
    textBox.TextSize = 14
    textBox.Font = Enum.Font.SourceSans
    textBox.ClearTextOnFocus = options.RemoveTextAfterFocusLost or false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = textBox
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = textBox
    
    textBox.Parent = inputContainer
    
    if options.Callback then
        textBox.FocusLost:Connect(function()
            pcall(options.Callback, textBox.Text)
            
            if options.Flag then
                ConfigurationSystem:SetFlag(options.Flag, textBox.Text)
            end
        end)
    end
    
    if options.Flag then
        textBox.Text = ConfigurationSystem:GetFlag(options.Flag, options.CurrentValue or "")
    end
    
    inputContainer.Parent = tab.Content
    
    return {
        SetValue = function(self, value)
            textBox.Text = value
        end,
        GetValue = function(self)
            return textBox.Text
        end
    }
end

function Window:CreateDropdown(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = options.Name or "Dropdown"
    dropdownContainer.Size = UDim2.new(1, -20, 0, 36)
    dropdownContainer.BackgroundTransparency = 1
    dropdownContainer.ClipsDescendants = true
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 36)
    dropdownButton.BackgroundColor3 = theme.SURFACE_VARIANT
    dropdownButton.TextColor3 = theme.ON_SURFACE
    dropdownButton.Text = options.Name or "Dropdown"
    dropdownButton.TextSize = 14
    dropdownButton.Font = Enum.Font.SourceSansSemibold
    dropdownButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = dropdownButton
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = dropdownButton
    
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -20, 0.5, -8)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6031090997"
    arrow.ImageColor3 = theme.ON_SURFACE_VARIANT
    arrow.Parent = dropdownButton
    
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 0, 36)
    optionsFrame.BackgroundColor3 = theme.SURFACE
    optionsFrame.ScrollBarThickness = 4
    optionsFrame.ScrollBarImageColor3 = theme.OUTLINE
    optionsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    optionsFrame.Visible = false
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = optionsFrame
    
    dropdownButton.Parent = dropdownContainer
    optionsFrame.Parent = dropdownContainer
    
    local currentOptions = options.CurrentOption or (options.MultipleOptions and {} or options.Options[1])
    local isOpen = false
    
    local function updateDropdown()
        if options.MultipleOptions then
            local displayText = ""
            for i, option in ipairs(currentOptions) do
                if i > 1 then
                    displayText = displayText .. ", "
                end
                displayText = displayText .. option
            end
            dropdownButton.Text = displayText == "" and options.Name or displayText
        else
            dropdownButton.Text = currentOptions or options.Name
        end
    end
    
    local function createOption(option)
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = theme.SURFACE_VARIANT
        optionButton.TextColor3 = theme.ON_SURFACE
        optionButton.Text = option
        optionButton.TextSize = 12
        optionButton.Font = Enum.Font.SourceSans
        optionButton.AutoButtonColor = false
        
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 8)
        optionPadding.PaddingRight = UDim.new(0, 8)
        optionPadding.Parent = optionButton
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = theme.PRIMARY
            optionButton.TextColor3 = theme.ON_PRIMARY
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = theme.SURFACE_VARIANT
            optionButton.TextColor3 = theme.ON_SURFACE
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            if options.MultipleOptions then
                local found = false
                for i, opt in ipairs(currentOptions) do
                    if opt == option then
                        table.remove(currentOptions, i)
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(currentOptions, option)
                end
            else
                currentOptions = option
                isOpen = false
                optionsFrame.Visible = false
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
            end
            
            updateDropdown()
            
            if options.Callback then
                pcall(options.Callback, currentOptions)
            end
            
            if options.Flag then
                ConfigurationSystem:SetFlag(options.Flag, currentOptions)
            end
        end)
        
        return optionButton
    end
    
    -- Populate options
    for _, option in ipairs(options.Options) do
        local optionButton = createOption(option)
        optionButton.Parent = optionsFrame
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        
        if isOpen then
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, math.min(#options.Options * 30, 150))
            }):Play()
        else
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
        end
    end)
    
    updateDropdown()
    
    if options.Flag then
        local saved = ConfigurationSystem:GetFlag(options.Flag, currentOptions)
        if options.MultipleOptions and type(saved) == "table" then
            currentOptions = saved
        else
            currentOptions = saved
        end
        updateDropdown()
    end
    
    dropdownContainer.Parent = tab.Content
    
    return {
        SetValue = function(self, value)
            currentOptions = value
            updateDropdown()
        end,
        GetValue = function(self)
            return currentOptions
        end
    }
end

-- Main Nebula API
function Nebula:CreateWindow(options)
    options = options or {}
    
    -- Apply configuration settings
    if options.ConfigurationSaving then
        Nebula_Internal.ConfigurationSaving = options.ConfigurationSaving
        ConfigurationSystem:Initialize()
    end
    
    if options.Theme then
        Nebula_Internal.CurrentTheme = options.Theme
    end
    
    if options.ToggleUIKeybind then
        Nebula_Internal.ToggleUIKeybind = options.ToggleUIKeybind
    end
    
    local window = Window.new(self, options)
    table.insert(Nebula_Internal.Windows, window)
    
    return window
end

function Nebula:Notify(options)
    -- Find first window to use its notification manager
    if #Nebula_Internal.Windows > 0 then
        local window = Nebula_Internal.Windows[1]
        window.NotificationManager:ShowNotification(options)
    else
        warn("Nebula UI: No windows created yet. Create a window first.")
    end
end

-- Initialize configuration system
ConfigurationSystem:Initialize()

-- Make library available globally
if getgenv then
    getgenv().Nebula = Nebula
end

return Nebula
