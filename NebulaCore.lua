-- Nebula UI Library v4.1
-- Modern Mobile-First GUI Framework for Roblox
-- Enhanced with Feather Icons, Advanced Animations & Performance Optimizations

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
local TextService = game:GetService("TextService")

-- Local player reference
local player = Players.LocalPlayer

-- Feather Icons System
local FEATHER_ICONS = {
    -- Navigation
    home = "rbxassetid://7733774602",
    settings = "rbxassetid://7734068321",
    user = "rbxassetid://7734091286",
    users = "rbxassetid://7734091379",
    search = "rbxassetid://7734052925",
    menu = "rbxassetid://7734000129",
    arrow_right = "rbxassetid://7733717755",
    arrow_left = "rbxassetid://7733717447",
    chevron_down = "rbxassetid://7733919795",
    chevron_up = "rbxassetid://7733919981",
    chevron_right = "rbxassetid://7733919869",
    chevron_left = "rbxassetid://7733919682",

    -- Actions
    play = "rbxassetid://7734021209",
    pause = "rbxassetid://7734006080",
    stop = "rbxassetid://7734053495",
    refresh = "rbxassetid://7734021456",
    download = "rbxassetid://7733956233",
    upload = "rbxassetid://7734091286",
    save = "rbxassetid://7734021209",
    edit = "rbxassetid://7733954760",
    trash = "rbxassetid://7734084924",

    -- Status
    check = "rbxassetid://7733919526",
    x = "rbxassetid://7743878496",
    alert = "rbxassetid://7733715400",
    info = "rbxassetid://7733992901",
    warning = "rbxassetid://7733955511",
    star = "rbxassetid://7734053269",
    heart = "rbxassetid://7733992427",

    -- Media
    image = "rbxassetid://7733993016",
    video = "rbxassetid://7734091286",
    music = "rbxassetid://7734006080",
    volume = "rbxassetid://7734091379",

    -- Development
    code = "rbxassetid://7733920644",
    bug = "rbxassetid://7733919301",
    flag = "rbxassetid://7733964126",
    filter = "rbxassetid://7733966916",

    -- Files
    folder = "rbxassetid://7733964237",
    file = "rbxassetid://7733960981",
    file_text = "rbxassetid://7733960981"
}

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

-- Enhanced Mobile Settings with Viewport Scaling
local MOBILE_SETTINGS = {
    SIDEBAR_WIDTH = UDim.new(0.7, 0),
    SIDEBAR_MIN_WIDTH = 280,
    CONTENT_PADDING = 20,
    ELEMENT_HEIGHT = 52,
    CORNER_RADIUS = 12,
    ANIMATION_DURATION = 0.3,
    TOUCH_TARGET = 44
}

-- Internal State with Enhanced Detection
local Nebula_Internal = {
    Windows = {},
    Toasts = {},
    CurrentTheme = "Default",
    IsMobile = UserInputService.TouchEnabled and (UserInputService.MouseEnabled == false or UserInputService.GamepadEnabled),
    IsDesktop = UserInputService.MouseEnabled,
    IsConsole = UserInputService.GamepadEnabled,
    Version = "4.1.0",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "NebulaUI",
        FileName = "Configuration"
    },
    ToggleUIKeybind = "K",
    DebugMode = false,
    ActiveConnections = {},
    ActiveTweens = {},
    FocusManager = {
        CurrentFocus = nil,
        FocusHistory = {}
    }
}

-- Configuration Saving System with Auto-Save Debounce
local ConfigurationSystem = {
    DataStore = nil,
    Configurations = {},
    SaveQueue = {},
    IsSaving = false,
    LastSaveTime = 0,
    SaveDebounce = 1 -- seconds
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

function ConfigurationSystem:QueueSave()
    if not ConfigurationSystem.DataStore then return end
    
    local currentTime = os.time()
    if currentTime - ConfigurationSystem.LastSaveTime < ConfigurationSystem.SaveDebounce then
        -- Debounce: schedule save for later
        if not ConfigurationSystem.SaveQueue[tostring(player.UserId)] then
            ConfigurationSystem.SaveQueue[tostring(player.UserId)] = true
            delay(ConfigurationSystem.SaveDebounce, function()
                ConfigurationSystem:SaveConfiguration()
            end)
        end
        return
    end
    
    ConfigurationSystem:SaveConfiguration()
end

function ConfigurationSystem:SaveConfiguration()
    if not ConfigurationSystem.DataStore or ConfigurationSystem.IsSaving then return end
    
    ConfigurationSystem.IsSaving = true
    local success, result = pcall(function()
        ConfigurationSystem.DataStore:SetAsync(tostring(player.UserId), ConfigurationSystem.Configurations)
        ConfigurationSystem.LastSaveTime = os.time()
        ConfigurationSystem.SaveQueue[tostring(player.UserId)] = nil
    end)
    
    ConfigurationSystem.IsSaving = false
    
    if not success then
        warn("Nebula UI: Failed to save configuration - " .. result)
    end
end

function ConfigurationSystem:SetFlag(flag, value)
    ConfigurationSystem.Configurations[flag] = value
    if Nebula_Internal.ConfigurationSaving.Enabled then
        ConfigurationSystem:QueueSave()
    end
end

function ConfigurationSystem:GetFlag(flag, defaultValue)
    return ConfigurationSystem.Configurations[flag] or defaultValue
end

-- Enhanced Event System with Error Boundaries
local EventSystem = {}
EventSystem.__index = EventSystem

function EventSystem.new()
    local self = setmetatable({}, EventSystem)
    self._listeners = {}
    self._connections = {}
    return self
end

function EventSystem:Fire(eventName, ...)
    if not self._listeners[eventName] then return end
    
    for callbackId, callback in pairs(self._listeners[eventName]) do
        local success, result = pcall(callback, ...)
        if not success then
            warn(string.format("Nebula UI: Event callback error in %s - %s", eventName, result))
        end
    end
end

function EventSystem:Connect(eventName, callback)
    if not self._listeners[eventName] then
        self._listeners[eventName] = {}
    end
    
    local callbackId = HttpService:GenerateGUID(false)
    self._listeners[eventName][callbackId] = callback
    
    local connection = {
        Disconnect = function()
            if self._listeners[eventName] then
                self._listeners[eventName][callbackId] = nil
            end
        end
    }
    
    table.insert(self._connections, connection)
    return connection
end

function EventSystem:Cleanup()
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
    self._connections = {}
    self._listeners = {}
end

-- Connection Tracker for Memory Leak Prevention
local ConnectionTracker = {
    ActiveConnections = {}
}

function ConnectionTracker:Track(connection)
    table.insert(self.ActiveConnections, connection)
    return connection
end

function ConnectionTracker:Cleanup()
    for _, connection in ipairs(self.ActiveConnections) do
        if connection and type(connection.Disconnect) == "function" then
            connection:Disconnect()
        end
    end
    self.ActiveConnections = {}
end

-- Tween Manager for Memory Leak Prevention
local TweenManager = {
    ActiveTweens = {}
}

function TweenManager:Track(tween)
    table.insert(self.ActiveTweens, tween)
    return tween
end

function TweenManager:CancelAll()
    for _, tween in ipairs(self.ActiveTweens) do
        if tween and tween.Cancel then
            tween:Cancel()
        end
    end
    self.ActiveTweens = {}
end

-- Enhanced Notification System with Queue
local NotificationManager = {}
NotificationManager.__index = NotificationManager

function NotificationManager.new(parentGUI)
    local self = setmetatable({}, NotificationManager)
    self.Parent = parentGUI
    self.ActiveNotifications = {}
    self.NotificationQueue = {}
    self.MaxNotifications = 4
    return self
end

function NotificationManager:ShowNotification(options)
    -- Add to queue if too many notifications
    if #self.ActiveNotifications >= self.MaxNotifications then
        table.insert(self.NotificationQueue, options)
        return
    end
    
    local theme = MODERN_THEMES[Nebula_Internal.CurrentTheme]
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 100)
    notification.BackgroundColor3 = theme.SURFACE
    notification.BorderSizePixel = 0
    notification.ZIndex = 1000
    notification.ClipsDescendants = true
    
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
    
    -- Close button
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = FEATHER_ICONS.x
    closeButton.ImageColor3 = theme.ON_SURFACE_VARIANT
    closeButton.ZIndex = notification.ZIndex + 1
    closeButton.Parent = notification
    
    notification.Parent = self.Parent
    
    -- Position notification
    self:RepositionNotifications()
    
    -- Animate in
    notification.Position = UDim2.new(1, 300, notification.Position.Y.Scale, notification.Position.Y.Offset)
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, notification.Position.Y.Scale, notification.Position.Y.Offset)
    })
    TweenManager:Track(tweenIn)
    tweenIn:Play()
    
    table.insert(self.ActiveNotifications, notification)
    
    -- Close button connection
    ConnectionTracker:Track(closeButton.MouseButton1Click:Connect(function()
        self:DismissNotification(notification)
    end))
    
    -- Auto dismiss
    local duration = options.Duration or 6.5
    if duration > 0 then
        delay(duration, function()
            if notification.Parent then
                self:DismissNotification(notification)
            end
        end)
    end
    
    return notification
end

function NotificationManager:RepositionNotifications()
    local yOffset = -120
    for i, notif in ipairs(self.ActiveNotifications) do
        notif.Position = UDim2.new(1, -320, 1, yOffset)
        yOffset = yOffset - 110
    end
end

function NotificationManager:DismissNotification(notification)
    if not notification or not notification.Parent then return end
    
    local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 300, notification.Position.Y.Scale, notification.Position.Y.Offset)
    })
    TweenManager:Track(tweenOut)
    tweenOut:Play()
    
    tweenOut.Completed:Wait()
    notification:Destroy()
    
    for i, notif in ipairs(self.ActiveNotifications) do
        if notif == notification then
            table.remove(self.ActiveNotifications, i)
            break
        end
    end
    
    -- Show next notification in queue
    self:RepositionNotifications()
    if #self.NotificationQueue > 0 then
        local nextNotification = table.remove(self.NotificationQueue, 1)
        self:ShowNotification(nextNotification)
    end
end

function NotificationManager:GetIconForType(iconType)
    local iconMap = {
        info = FEATHER_ICONS.info,
        success = FEATHER_ICONS.check,
        warning = FEATHER_ICONS.alert,
        error = FEATHER_ICONS.x
    }
    return iconMap[iconType] or FEATHER_ICONS.info
end

-- Ripple Effect System
local RippleEffect = {}
RippleEffect.__index = RippleEffect

function RippleEffect:CreateRipple(button, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, position.X - button.AbsolutePosition.X, 0, position.Y - button.AbsolutePosition.Y)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Parent = button
    
    -- Animate ripple
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local sizeTween = TweenService:Create(ripple, tweenInfo, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, position.X - button.AbsolutePosition.X - maxSize/2, 0, position.Y - button.AbsolutePosition.Y - maxSize/2),
        BackgroundTransparency = 1
    })
    
    TweenManager:Track(sizeTween)
    sizeTween:Play()
    
    sizeTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Focus Management System
local FocusManager = {
    CurrentFocus = nil,
    FocusHistory = {}
}

function FocusManager:SetFocus(element)
    if self.CurrentFocus then
        table.insert(self.FocusHistory, self.CurrentFocus)
    end
    self.CurrentFocus = element
end

function FocusManager:ClearFocus()
    self.CurrentFocus = nil
end

function FocusManager:RestorePreviousFocus()
    if #self.FocusHistory > 0 then
        self.CurrentFocus = table.remove(self.FocusHistory)
        return self.CurrentFocus
    end
    return nil
end

-- Window Class with Enhanced Features
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
    self._connections = {}
    self._activeTweens = {}
    self.IsDragging = false
    self.IsResizing = false
    self.DragStartPosition = nil
    self.StartSize = nil
    
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
    mainFrame.ZIndex = 10
    
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
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    -- Header with drag support
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = theme.PRIMARY
    header.BorderSizePixel = 0
    header.ZIndex = mainFrame.ZIndex + 1
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    headerCorner.Parent = header
    
    -- Icon in header
    if self.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(0, 8, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Image = FEATHER_ICONS[self.Icon] or self.Icon
        icon.ImageColor3 = theme.ON_PRIMARY
        icon.ZIndex = header.ZIndex + 1
        icon.Parent = header
    end
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = self.Icon and UDim2.new(1, -120, 1, 0) or UDim2.new(1, -80, 1, 0)
    title.Position = self.Icon and UDim2.new(0, 40, 0, 0) or UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.Name
    title.TextColor3 = theme.ON_PRIMARY
    title.TextSize = 18
    title.Font = Enum.Font.SourceSansSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = header.ZIndex + 1
    title.Parent = header
    
    -- Close button
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = FEATHER_ICONS.x
    closeButton.ImageColor3 = theme.ON_PRIMARY
    closeButton.ZIndex = header.ZIndex + 1
    closeButton.Parent = header
    
    -- Window controls
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Image = FEATHER_ICONS.chevron_down
    minimizeButton.ImageColor3 = theme.ON_PRIMARY
    minimizeButton.ZIndex = header.ZIndex + 1
    minimizeButton.Parent = header
    
    -- Setup drag and resize
    self:SetupDrag(header, mainFrame)
    self:SetupResize(mainFrame)
    
    table.insert(self._connections, closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end))
    
    table.insert(self._connections, minimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end))
    
    header.Parent = mainFrame
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = theme.SURFACE_VARIANT
    tabContainer.BorderSizePixel = 0
    tabContainer.ZIndex = mainFrame.ZIndex + 1
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 3
    tabList.ScrollBarImageColor3 = theme.OUTLINE
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.ScrollingDirection = Enum.ScrollingDirection.Y
    tabList.ZIndex = tabContainer.ZIndex + 1
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
    contentContainer.ZIndex = mainFrame.ZIndex + 1
    contentContainer.Parent = mainFrame
    
    self.MainFrame = mainFrame
    self.TabList = tabList
    self.ContentContainer = contentContainer
    self.NotificationManager = NotificationManager.new(self.GUI)
    
    mainFrame.Parent = self.GUI
    
    -- Initially hidden
    self.GUI.Enabled = false
end

function Window:SetupDrag(dragElement, targetElement)
    local dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        targetElement.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    table.insert(self._connections, dragElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsDragging = true
            dragStart = input.Position
            startPos = targetElement.Position
            
            table.insert(self._connections, input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.IsDragging = false
                end
            end))
        end
    end))
    
    table.insert(self._connections, dragElement.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if self.IsDragging then
                update(input)
            end
        end
    end))
end

function Window:SetupResize(targetElement)
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 16, 0, 16)
    resizeHandle.Position = UDim2.new(1, -16, 1, -16)
    resizeHandle.BackgroundTransparency = 0.8
    resizeHandle.BackgroundColor3 = MODERN_THEMES[self.ThemeName].OUTLINE
    resizeHandle.BorderSizePixel = 0
    resizeHandle.ZIndex = targetElement.ZIndex + 2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = resizeHandle
    
    resizeHandle.Parent = targetElement
    
    local resizeStart, startSize, startPos
    
    local function update(input)
        local delta = input.Position - resizeStart
        local newSize = UDim2.new(
            startSize.X.Scale, math.max(400, startSize.X.Offset + delta.X),
            startSize.Y.Scale, math.max(300, startSize.Y.Offset + delta.Y)
        )
        targetElement.Size = newSize
    end
    
    table.insert(self._connections, resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsResizing = true
            resizeStart = input.Position
            startSize = targetElement.Size
            startPos = targetElement.Position
            
            table.insert(self._connections, input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.IsResizing = false
                end
            end))
        end
    end))
    
    table.insert(self._connections, resizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if self.IsResizing then
                update(input)
            end
        end
    end))
end

function Window:SetupToggleKeybind(keybind)
    local keyCode = Enum.KeyCode[keybind]
    if not keyCode then
        warn("Nebula UI: Invalid keybind - " .. keybind)
        return
    end
    
    local connection = ContextActionService:BindAction("ToggleNebulaUI", function(_, inputState)
        if inputState == Enum.UserInputState.Begin then
            self:Toggle()
        end
    end, false, keyCode)
    
    table.insert(self._connections, {Disconnect = function() ContextActionService:UnbindAction("ToggleNebulaUI") end})
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
        table.insert(self._activeTweens, tween)
        tween:Play()
    else
        local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 500, 0, 0)
        })
        table.insert(self._activeTweens, tween)
        tween:Play()
        
        tween.Completed:Wait()
        self.GUI.Enabled = false
    end
end

function Window:Minimize()
    local targetSize = self.MainFrame.Size.Y.Offset == 40 and UDim2.new(0, 500, 0, 400) or UDim2.new(0, 500, 0, 40)
    
    local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    table.insert(self._activeTweens, tween)
    tween:Play()
end

function Window:CreateTab(name, icon)
    local tab = {
        Name = name,
        Icon = icon,
        Content = nil,
        Window = self,
        _connections = {}
    }
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, -8, 0, 40)
    tabButton.Position = UDim2.new(0, 4, 0, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = "  " .. name
    tabButton.TextColor3 = theme.ON_SURFACE_VARIANT
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.SourceSansSemibold
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = tabButton
    
    -- Add icon if provided
    if icon then
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = FEATHER_ICONS[icon] or icon
        tabIcon.ImageColor3 = theme.ON_SURFACE_VARIANT
        tabIcon.Parent = tabButton
        
        tabButton.Text = "    " .. name
    end
    
    -- Create content frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = name .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = theme.OUTLINE
    contentFrame.Visible = false
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.ScrollingEnabled = true
    contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentFrame
    contentLayout.Padding = UDim.new(0, 8)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)
    contentPadding.Parent = contentFrame
    
    tabButton.Parent = self.TabList
    contentFrame.Parent = self.ContentContainer
    
    tab.Button = tabButton
    tab.Content = contentFrame
    
    table.insert(self.Tabs, tab)
    
    -- Tab selection logic with animation
    table.insert(tab._connections, tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end))
    
    -- Hover effects
    table.insert(tab._connections, tabButton.MouseEnter:Connect(function()
        if not tab.Content.Visible then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.9,
                BackgroundColor3 = theme.PRIMARY
            }):Play()
        end
    end))
    
    table.insert(tab._connections, tabButton.MouseLeave:Connect(function()
        if not tab.Content.Visible then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
        end
    end))
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(selectedTab)
    for _, tab in ipairs(self.Tabs) do
        -- Animate tab transition
        if tab.Content.Visible then
            local hideTween = TweenService:Create(tab.Content, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Position = UDim2.new(-0.1, 0, 0, 0)
            })
            table.insert(self._activeTweens, hideTween)
            hideTween:Play()
            hideTween.Completed:Wait()
        end
        
        tab.Content.Visible = false
        tab.Button.TextColor3 = MODERN_THEMES[self.ThemeName].ON_SURFACE_VARIANT
        tab.Button.BackgroundTransparency = 1
        
        if tab.Button:FindFirstChild("Icon") then
            tab.Button.Icon.ImageColor3 = MODERN_THEMES[self.ThemeName].ON_SURFACE_VARIANT
        end
    end
    
    -- Show selected tab with animation
    selectedTab.Content.Visible = true
    selectedTab.Content.Position = UDim2.new(1.1, 0, 0, 0)
    
    local showTween = TweenService:Create(selectedTab.Content, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    table.insert(self._activeTweens, showTween)
    showTween:Play()
    
    selectedTab.Button.TextColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    selectedTab.Button.BackgroundTransparency = 0.8
    selectedTab.Button.BackgroundColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    
    if selectedTab.Button:FindFirstChild("Icon") then
        selectedTab.Button.Icon.ImageColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    end
end

-- UI Elements with Enhanced Features
function Window:CreateButton(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local button = Instance.new("TextButton")
    button.Name = options.Name or "Button"
    button.Size = UDim2.new(1, -20, 0, 36)
    button.BackgroundColor3 = theme.PRIMARY
    button.TextColor3 = theme.ON_PRIMARY
    button.Text = options.Name or "Button"
    button.TextSize = 14
    button.Font = Enum.Font.SourceSansSemibold
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Add icon if provided
    if options.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 8, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Image = FEATHER_ICONS[options.Icon] or options.Icon
        icon.ImageColor3 = theme.ON_PRIMARY
        icon.Parent = button
        
        button.Text = "    " .. button.Text
    end
    
    -- Ripple effect
    local function createRipple(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            RippleEffect:CreateRipple(button, input.Position)
        end
    end
    
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
    
    -- Click handler with error boundary
    if options.Callback then
        button.InputBegan:Connect(createRipple)
        
        button.MouseButton1Click:Connect(function()
            local success, result = pcall(options.Callback)
            if not success then
                warn("Nebula UI: Button callback error - " .. result)
                self.NotificationManager:ShowNotification({
                    Title = "Error",
                    Content = "Button action failed: " .. result,
                    Image = "error",
                    Duration = 5
                })
            end
        end)
    end
    
    -- Keyboard support
    button.MouseButton2Click:Connect(function()
        -- Right click also triggers for accessibility
        if options.Callback then
            local success, result = pcall(options.Callback)
            if not success then
                warn("Nebula UI: Button callback error - " .. result)
            end
        end
    end)
    
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
    
    local toggleSwitch = Instance.new("TextButton")
    toggleSwitch.Name = "Switch"
    toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
    toggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
    toggleSwitch.BackgroundColor3 = theme.OUTLINE
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.AutoButtonColor = false
    toggleSwitch.Text = ""
    
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
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        
        local colorTween = TweenService:Create(toggleSwitch, tweenInfo, {
            BackgroundColor3 = isToggled and theme.PRIMARY or theme.OUTLINE
        })
        TweenManager:Track(colorTween)
        colorTween:Play()
        
        local positionTween = TweenService:Create(toggleThumb, tweenInfo, {
            Position = isToggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
        })
        TweenManager:Track(positionTween)
        positionTween:Play()
        
        if options.Callback then
            local success, result = pcall(options.Callback, isToggled)
            if not success then
                warn("Nebula UI: Toggle callback error - " .. result)
                self.NotificationManager:ShowNotification({
                    Title = "Error",
                    Content = "Toggle action failed: " .. result,
                    Image = "error",
                    Duration = 5
                })
            end
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, isToggled)
        end
    end
    
    -- Mouse input
    toggleSwitch.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        RippleEffect:CreateRipple(toggleSwitch, Vector2.new(toggleSwitch.AbsolutePosition.X + toggleSwitch.AbsoluteSize.X/2, toggleSwitch.AbsolutePosition.Y + toggleSwitch.AbsoluteSize.Y/2))
    end)
    
    -- Keyboard support
    toggleSwitch.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.Return then
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
    
    -- Value tooltip
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 40, 0, 20)
    tooltip.Position = UDim2.new(0, 0, -2, 0)
    tooltip.BackgroundColor3 = theme.SURFACE
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 100
    
    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 4)
    tooltipCorner.Parent = tooltip
    
    local tooltipText = Instance.new("TextLabel")
    tooltipText.Size = UDim2.new(1, 0, 1, 0)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = ""
    tooltipText.TextColor3 = theme.ON_SURFACE
    tooltipText.TextSize = 10
    tooltipText.Font = Enum.Font.SourceSans
    tooltipText.Parent = tooltip
    
    tooltip.Parent = thumb
    
    track.Parent = sliderContainer
    
    local minValue = options.Range[1]
    local maxValue = options.Range[2]
    local increment = options.Increment or 1
    local currentValue = options.CurrentValue or minValue
    if options.Flag then
        currentValue = ConfigurationSystem:GetFlag(options.Flag, currentValue)
    end
    
    local isDragging = false
    
    local function updateSlider(value, showTooltip)
        currentValue = math.floor((value - minValue) / increment) * increment + minValue
        currentValue = math.clamp(currentValue, minValue, maxValue)
        
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        thumb.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(currentValue) .. (options.Suffix or "")
        
        if showTooltip then
            tooltipText.Text = tostring(currentValue) .. (options.Suffix or "")
            tooltip.Visible = true
            tooltip.Position = UDim2.new(percentage, -20, -2, 0)
        else
            tooltip.Visible = false
        end
        
        if options.Callback then
            local success, result = pcall(options.Callback, currentValue)
            if not success then
                warn("Nebula UI: Slider callback error - " .. result)
            end
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, currentValue)
        end
    end
    
    local function onInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            local relativeX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
            local percentage = relativeX / track.AbsoluteSize.X
            updateSlider(percentage * (maxValue - minValue) + minValue, true)
        end
    end
    
    local function endDrag()
        isDragging = false
        tooltip.Visible = false
    end
    
    -- Input handling with proper drag system
    track.InputBegan:Connect(onInput)
    
    track.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                local relativeX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                local percentage = relativeX / track.AbsoluteSize.X
                updateSlider(percentage * (maxValue - minValue) + minValue, true)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            endDrag()
        end
    end)
    
    updateSlider(currentValue, false)
    sliderContainer.Parent = tab.Content
    
    return {
        SetValue = function(self, value)
            updateSlider(value, false)
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
    textBox.PlaceholderColor3 = theme.ON_SURFACE_VARIANT
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = textBox
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = textBox
    
    -- Focus management
    textBox.Focused:Connect(function()
        FocusManager:SetFocus(textBox)
        TweenService:Create(textBox, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.PRIMARY_LIGHT,
            TextColor3 = theme.ON_PRIMARY
        }):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        FocusManager:ClearFocus()
        TweenService:Create(textBox, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.SURFACE_VARIANT,
            TextColor3 = theme.ON_SURFACE
        }):Play()
        
        if options.Callback then
            local success, result = pcall(options.Callback, textBox.Text)
            if not success then
                warn("Nebula UI: Input callback error - " .. result)
                self.NotificationManager:ShowNotification({
                    Title = "Error",
                    Content = "Input action failed: " .. result,
                    Image = "error",
                    Duration = 5
                })
            end
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, textBox.Text)
        end
    end)
    
    if options.Flag then
        textBox.Text = ConfigurationSystem:GetFlag(options.Flag, options.CurrentValue or "")
    end
    
    textBox.Parent = inputContainer
    inputContainer.Parent = tab.Content
    
    return {
        SetValue = function(self, value)
            textBox.Text = value
        end,
        GetValue = function(self)
            return textBox.Text
        end,
        Focus = function(self)
            textBox:CaptureFocus()
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
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    
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
    arrow.Image = FEATHER_ICONS.chevron_down
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
    optionsFrame.ZIndex = 100
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = optionsFrame
    
    -- Search box for dropdown with many options
    if options.Searchable and #options.Options > 8 then
        local searchBox = Instance.new("TextBox")
        searchBox.Name = "SearchBox"
        searchBox.Size = UDim2.new(1, -8, 0, 30)
        searchBox.Position = UDim2.new(0, 4, 0, 4)
        searchBox.BackgroundColor3 = theme.SURFACE_VARIANT
        searchBox.TextColor3 = theme.ON_SURFACE
        searchBox.PlaceholderText = "Search..."
        searchBox.TextSize = 12
        searchBox.Font = Enum.Font.SourceSans
        
        local searchPadding = Instance.new("UIPadding")
        searchPadding.PaddingLeft = UDim.new(0, 8)
        searchPadding.PaddingRight = UDim.new(0, 8)
        searchPadding.Parent = searchBox
        
        searchBox.Parent = optionsFrame
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, 34 + (#options.Options * 30))
    end
    
    dropdownButton.Parent = dropdownContainer
    optionsFrame.Parent = dropdownContainer
    
    local currentOptions = options.CurrentOption or (options.MultipleOptions and {} or options.Options[1])
    local isOpen = false
    local filteredOptions = options.Options
    
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
        optionButton.Size = UDim2.new(1, -8, 0, 30)
        optionButton.Position = UDim2.new(0, 4, 0, options.Searchable and 34 or 0)
        optionButton.BackgroundColor3 = theme.SURFACE_VARIANT
        optionButton.TextColor3 = theme.ON_SURFACE
        optionButton.Text = option
        optionButton.TextSize = 12
        optionButton.Font = Enum.Font.SourceSans
        optionButton.AutoButtonColor = false
        optionButton.ZIndex = optionsFrame.ZIndex + 1
        
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 8)
        optionPadding.PaddingRight = UDim.new(0, 8)
        optionPadding.Parent = optionButton
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = theme.PRIMARY
            optionButton.TextColor3 = theme.ON_PRIMARY
        end)
        
        optionButton.MouseLeave:Connect(function()
            if not (options.MultipleOptions and table.find(currentOptions, option)) then
                optionButton.BackgroundColor3 = theme.SURFACE_VARIANT
                optionButton.TextColor3 = theme.ON_SURFACE
            end
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
                    optionButton.BackgroundColor3 = theme.PRIMARY
                    optionButton.TextColor3 = theme.ON_PRIMARY
                else
                    optionButton.BackgroundColor3 = theme.SURFACE_VARIANT
                    optionButton.TextColor3 = theme.ON_SURFACE
                end
            else
                currentOptions = option
                isOpen = false
                optionsFrame.Visible = false
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = 0
                }):Play()
            end
            
            updateDropdown()
            
            if options.Callback then
                local success, result = pcall(options.Callback, currentOptions)
                if not success then
                    warn("Nebula UI: Dropdown callback error - " .. result)
                end
            end
            
            if options.Flag then
                ConfigurationSystem:SetFlag(options.Flag, currentOptions)
            end
        end)
        
        return optionButton
    end
    
    local function populateOptions()
        -- Clear existing options (except search box)
        for _, child in ipairs(optionsFrame:GetChildren()) do
            if child.Name ~= "SearchBox" then
                child:Destroy()
            end
        end
        
        -- Create option buttons
        for _, option in ipairs(filteredOptions) do
            local optionButton = createOption(option)
            optionButton.Parent = optionsFrame
        end
    end
    
    -- Search functionality
    if options.Searchable then
        local searchBox = optionsFrame:FindFirstChild("SearchBox")
        if searchBox then
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(searchBox.Text)
                if searchText == "" then
                    filteredOptions = options.Options
                else
                    filteredOptions = {}
                    for _, option in ipairs(options.Options) do
                        if string.find(string.lower(option), searchText, 1, true) then
                            table.insert(filteredOptions, option)
                        end
                    end
                end
                populateOptions()
            end)
        end
    end
    
    -- Initial population
    populateOptions()
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        
        if isOpen then
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, math.min(#filteredOptions * 30 + (options.Searchable and 34 or 0), 150))
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
        end
    end)
    
    -- Close dropdown when clicking outside
    local function closeDropdown(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local isInBounds = dropdownContainer.AbsolutePosition:X() <= input.Position.X and input.Position.X <= dropdownContainer.AbsolutePosition:X() + dropdownContainer.AbsoluteSize:X() and
                              dropdownContainer.AbsolutePosition:Y() <= input.Position.Y and input.Position.Y <= dropdownContainer.AbsolutePosition:Y() + dropdownContainer.AbsoluteSize:Y()
            
            if not isInBounds then
                isOpen = false
                optionsFrame.Visible = false
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = 0
                }):Play()
            end
        end
    end
    
    UserInputService.InputBegan:Connect(closeDropdown)
    
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
        end,
        RefreshOptions = function(self, newOptions)
            options.Options = newOptions
            filteredOptions = newOptions
            populateOptions()
        end
    }
end

-- New UI Elements
function Window:CreateKeybind(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local keybindContainer = Instance.new("Frame")
    keybindContainer.Name = options.Name or "Keybind"
    keybindContainer.Size = UDim2.new(1, -20, 0, 36)
    keybindContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Keybind"
    label.TextColor3 = theme.ON_SURFACE
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = keybindContainer
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Size = UDim2.new(0, 80, 0, 24)
    keybindButton.Position = UDim2.new(1, -90, 0.5, -12)
    keybindButton.BackgroundColor3 = theme.SURFACE_VARIANT
    keybindButton.TextColor3 = theme.ON_SURFACE
    keybindButton.Text = options.CurrentKeybind or "None"
    keybindButton.TextSize = 12
    keybindButton.Font = Enum.Font.SourceSans
    keybindButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = keybindButton
    
    keybindButton.Parent = keybindContainer
    
    local listening = false
    local currentKeybind = options.CurrentKeybind
    
    local function updateKeybind()
        keybindButton.Text = currentKeybind or "None"
        
        if options.Callback then
            local success, result = pcall(options.Callback, currentKeybind)
            if not success then
                warn("Nebula UI: Keybind callback error - " .. result)
            end
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, currentKeybind)
        end
    end
    
    keybindButton.MouseButton1Click:Connect(function()
        listening = true
        keybindButton.Text = "Listening..."
        keybindButton.BackgroundColor3 = theme.PRIMARY
        keybindButton.TextColor3 = theme.ON_PRIMARY
    end)
    
    local inputConnection
    inputConnection = UserInputService.InputBegan:Connect(function(input)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKeybind = input.KeyCode.Name
                listening = false
                keybindButton.BackgroundColor3 = theme.SURFACE_VARIANT
                keybindButton.TextColor3 = theme.ON_SURFACE
                updateKeybind()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                currentKeybind = "MouseButton1"
                listening = false
                keybindButton.BackgroundColor3 = theme.SURFACE_VARIANT
                keybindButton.TextColor3 = theme.ON_SURFACE
                updateKeybind()
            end
        end
    end)
    
    table.insert(self._connections, inputConnection)
    
    updateKeybind()
    keybindContainer.Parent = tab.Content
    
    return {
        SetKeybind = function(self, keybind)
            currentKeybind = keybind
            updateKeybind()
        end,
        GetKeybind = function(self)
            return currentKeybind
        end
    }
end

function Window:CreateColorPicker(tab, options)
    local theme = MODERN_THEMES[self.ThemeName]
    
    local colorPickerContainer = Instance.new("Frame")
    colorPickerContainer.Name = options.Name or "ColorPicker"
    colorPickerContainer.Size = UDim2.new(1, -20, 0, 36)
    colorPickerContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Color Picker"
    label.TextColor3 = theme.ON_SURFACE
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = colorPickerContainer
    
    local colorPreview = Instance.new("TextButton")
    colorPreview.Name = "ColorPreview"
    colorPreview.Size = UDim2.new(0, 40, 0, 24)
    colorPreview.Position = UDim2.new(1, -50, 0.5, -12)
    colorPreview.BackgroundColor3 = options.CurrentColor or Color3.fromRGB(255, 255, 255)
    colorPreview.BorderSizePixel = 0
    colorPreview.AutoButtonColor = false
    colorPreview.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = colorPreview
    
    colorPreview.Parent = colorPickerContainer
    
    local currentColor = options.CurrentColor or Color3.fromRGB(255, 255, 255)
    if options.Flag then
        currentColor = ConfigurationSystem:GetFlag(options.Flag, currentColor)
    end
    
    -- Color picker modal (simplified version)
    local function showColorPicker()
        -- This would open a full color picker modal in a complete implementation
        -- For now, we'll just cycle through some preset colors
        local presetColors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 255, 255)
        }
        
        local currentIndex = 1
        for i, color in ipairs(presetColors) do
            if color == currentColor then
                currentIndex = i
                break
            end
        end
        
        currentColor = presetColors[(currentIndex % #presetColors) + 1]
        colorPreview.BackgroundColor3 = currentColor
        
        if options.Callback then
            local success, result = pcall(options.Callback, currentColor)
            if not success then
                warn("Nebula UI: Color picker callback error - " .. result)
            end
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, currentColor)
        end
    end
    
    colorPreview.MouseButton1Click:Connect(showColorPicker)
    
    colorPickerContainer.Parent = tab.Content
    
    return {
        SetColor = function(self, color)
            currentColor = color
            colorPreview.BackgroundColor3 = color
        end,
        GetColor = function(self)
            return currentColor
        end
    }
end

-- Theme Management
function Window:SetTheme(themeName)
    if not MODERN_THEMES[themeName] then
        warn("Nebula UI: Invalid theme name - " .. themeName)
        return
    end
    
    self.ThemeName = themeName
    Nebula_Internal.CurrentTheme = themeName
    self:RefreshAllColors()
end

function Window:RefreshAllColors()
    local theme = MODERN_THEMES[self.ThemeName]
    
    -- Refresh main window colors
    if self.MainFrame then
        self.MainFrame.BackgroundColor3 = theme.SURFACE
        self.MainFrame.Header.BackgroundColor3 = theme.PRIMARY
        self.MainFrame.Header.Title.TextColor3 = theme.ON_PRIMARY
        self.MainFrame.TabContainer.BackgroundColor3 = theme.SURFACE_VARIANT
    end
    
    -- Refresh all UI elements in tabs
    for _, tab in ipairs(self.Tabs) do
        self:RefreshTabColors(tab, theme)
    end
end

function Window:RefreshTabColors(tab, theme)
    -- This would recursively refresh all UI elements in the tab
    -- Implementation would iterate through all children and update colors
end

-- Cleanup Methods
function Window:Cleanup()
    -- Disconnect all connections
    for _, connection in ipairs(self._connections) do
        if connection and type(connection.Disconnect) == "function" then
            connection:Disconnect()
        end
    end
    
    -- Cancel all tweens
    for _, tween in ipairs(self._activeTweens) do
        if tween and tween.Cancel then
            tween:Cancel()
        end
    end
    
    -- Clean up tabs
    for _, tab in ipairs(self.Tabs) do
        if tab._connections then
            for _, conn in ipairs(tab._connections) do
                if conn and type(conn.Disconnect) == "function" then
                    conn:Disconnect()
                end
            end
        end
    end
    
    -- Destroy GUI
    if self.GUI then
        self.GUI:Destroy()
    end
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

function Nebula:SetGlobalTheme(themeName)
    if not MODERN_THEMES[themeName] then
        warn("Nebula UI: Invalid theme name - " .. themeName)
        return
    end
    
    Nebula_Internal.CurrentTheme = themeName
    for _, window in ipairs(Nebula_Internal.Windows) do
        window:SetTheme(themeName)
    end
end

function Nebula:GetVersion()
    return Nebula_Internal.Version
end

function Nebula:Cleanup()
    -- Clean up all windows
    for _, window in ipairs(Nebula_Internal.Windows) do
        window:Cleanup()
    end
    
    -- Clean up global connections and tweens
    ConnectionTracker:Cleanup()
    TweenManager:CancelAll()
    
    Nebula_Internal.Windows = {}
end

-- Initialize configuration system
ConfigurationSystem:Initialize()

-- Make library available globally
if getgenv then
    getgenv().Nebula = Nebula
end

return Nebula
