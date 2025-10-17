-- Nebula UI Library v4.1.1 - Complete Fixed Version
local Nebula = {}
Nebula.__index = Nebula

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer

local function GetDeviceType()
    local isTouch = UserInputService.TouchEnabled
    local isMouse = UserInputService.MouseEnabled
    local platform = game:GetService("Platform")
    
    local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local isPortrait = viewportSize.Y > viewportSize.X
    
    local isIOS = platform == Enum.Platform.IOS
    local isAndroid = platform == Enum.Platform.Android
    local isConsole = platform == Enum.Platform.XBoxOne or platform == Enum.Platform.PS4
    
    local isMobile = (isTouch and not isMouse) or isIOS or isAndroid
    local isTablet = isMobile and (viewportSize.X > 1000 or viewportSize.Y > 1000)
    local isDesktop = isMouse and not isTouch and not isConsole
    
    return {
        IsMobile = isMobile,
        IsTablet = isTablet,
        IsDesktop = isDesktop,
        IsConsole = isConsole,
        IsTouch = isTouch,
        IsMouse = isMouse,
        Platform = platform,
        ViewportSize = viewportSize,
        IsPortrait = isPortrait
    }
end

local DeviceInfo = GetDeviceType()

local FEATHER_ICONS = {
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
    play = "rbxassetid://7734021209",
    pause = "rbxassetid://7734006080",
    stop = "rbxassetid://7734053495",
    refresh = "rbxassetid://7734021456",
    download = "rbxassetid://7733956233",
    upload = "rbxassetid://7734091286",
    save = "rbxassetid://7734021209",
    edit = "rbxassetid://7733954760",
    trash = "rbxassetid://7734084924",
    check = "rbxassetid://7733919526",
    x = "rbxassetid://7743878496",
    alert = "rbxassetid://7733715400",
    info = "rbxassetid://7733992901",
    warning = "rbxassetid://7733955511",
    star = "rbxassetid://7734053269",
    heart = "rbxassetid://7733992427",
    image = "rbxassetid://7733993016",
    video = "rbxassetid://7734091286",
    music = "rbxassetid://7734006080",
    volume = "rbxassetid://7734091379",
    code = "rbxassetid://7733920644",
    bug = "rbxassetid://7733919301",
    flag = "rbxassetid://7733964126",
    filter = "rbxassetid://7733966916",
    folder = "rbxassetid://7733964237",
    file = "rbxassetid://7733960981",
    file_text = "rbxassetid://7733960981"
}

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

local MOBILE_SETTINGS = {
    SIDEBAR_WIDTH = UDim.new(0.7, 0),
    SIDEBAR_MIN_WIDTH = 280,
    CONTENT_PADDING = 20,
    ELEMENT_HEIGHT = DeviceInfo.IsTablet and 48 or 52,
    CORNER_RADIUS = DeviceInfo.IsTablet and 14 or 12,
    ANIMATION_DURATION = 0.3,
    TOUCH_TARGET = DeviceInfo.IsTablet and 48 or 44
}

local Nebula_Internal = {
    Windows = {},
    Toasts = {},
    CurrentTheme = "Default",
    DeviceInfo = DeviceInfo,
    IsMobile = DeviceInfo.IsMobile,
    IsDesktop = DeviceInfo.IsDesktop,
    Version = "4.1.1",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "NebulaUI",
        FileName = "Configuration"
    },
    ToggleUIKeybind = "K",
    DebugMode = false,
    ActiveConnections = {},
    ActiveTweens = {}
}

local ConfigurationSystem = {
    DataStore = nil,
    Configurations = {},
    SaveQueue = {},
    IsSaving = false,
    LastSaveTime = 0,
    SaveDebounce = 1
}

function ConfigurationSystem:Initialize()
    if not Nebula_Internal.ConfigurationSaving.Enabled then return end
    
    local success, result = pcall(function()
        ConfigurationSystem.DataStore = game:GetService("DataStoreService"):GetDataStore(
            Nebula_Internal.ConfigurationSaving.FolderName,
            Nebula_Internal.ConfigurationSaving.FileName
        )
        
        local loaded = ConfigurationSystem.DataStore:GetAsync(tostring(player.UserId))
        if loaded then
            ConfigurationSystem.Configurations = loaded
        end
    end)
    
    if not success then
        warn("Nebula UI: Configuration saving failed - " .. result)
    end
end

function ConfigurationSystem:QueueSave()
    if not ConfigurationSystem.DataStore then return end
    
    local currentTime = os.time()
    if currentTime - ConfigurationSystem.LastSaveTime < ConfigurationSystem.SaveDebounce then
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

local ConnectionTracker = {
    ActiveConnections = {}
}

function ConnectionTracker:Track(connection)
    table.insert(self.ActiveConnections, connection)
    return connection
end

function ConnectionTracker:Cleanup()
    for i, connection in ipairs(self.ActiveConnections) do
        if connection and type(connection.Disconnect) == "function" then
            pcall(function() connection:Disconnect() end)
        end
    end
    self.ActiveConnections = {}
end

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
            pcall(function() tween:Cancel() end)
        end
    end
    self.ActiveTweens = {}
end

local RippleEffect = {}
RippleEffect.__index = RippleEffect

RippleEffect.RipplePool = {}
RippleEffect.MaxPoolSize = 10

function RippleEffect:GetRippleFromPool()
    if #RippleEffect.RipplePool > 0 then
        return table.remove(RippleEffect.RipplePool)
    end
    return nil
end

function RippleEffect:ReturnRippleToPool(ripple)
    if ripple then
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundTransparency = 0.8
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.Visible = false
        ripple.Parent = nil
        
        if #RippleEffect.RipplePool < RippleEffect.MaxPoolSize then
            table.insert(RippleEffect.RipplePool, ripple)
        else
            ripple:Destroy()
        end
    end
end

function RippleEffect:CreateRipple(button, position)
    local ripple = self:GetRippleFromPool()
    
    if not ripple then
        ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
    end
    
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, position.X - button.AbsolutePosition.X, 0, position.Y - button.AbsolutePosition.Y)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.Visible = true
    
    ripple.Parent = button
    
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
        ripple.Visible = false
        self:ReturnRippleToPool(ripple)
    end)
end

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
    self.IsMinimized = false
    
    self:BuildGUI()
    
    if options.ToggleUIKeybind then
        self:SetupToggleKeybind(options.ToggleUIKeybind)
    end
    
    return self
end

function Window:BuildGUI()
    local theme = MODERN_THEMES[self.ThemeName]
    
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = self.Name
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.DisplayOrder = 100
    self.GUI.IgnoreGuiInset = true
    self.GUI.Parent = CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    if Nebula_Internal.IsMobile then
        mainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
        mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    else
        mainFrame.Size = UDim2.new(0, 500, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    end
    mainFrame.BackgroundColor3 = theme.SURFACE
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 10
    mainFrame.Visible = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
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
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = theme.PRIMARY
    header.BorderSizePixel = 0
    header.ZIndex = mainFrame.ZIndex + 1
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    headerCorner.Parent = header
    
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
    
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = FEATHER_ICONS.x
    closeButton.ImageColor3 = theme.ON_PRIMARY
    closeButton.ZIndex = header.ZIndex + 1
    closeButton.Parent = header
    
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Image = FEATHER_ICONS.chevron_down
    minimizeButton.ImageColor3 = theme.ON_PRIMARY
    minimizeButton.ZIndex = header.ZIndex + 1
    minimizeButton.Parent = header
    
    self:SetupDrag(header, mainFrame)
    self:SetupResize(mainFrame)
    
    ConnectionTracker:Track(closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end))
    
    ConnectionTracker:Track(minimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end))
    
    header.Parent = mainFrame
    
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
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.ZIndex = tabContainer.ZIndex + 1
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabList
    
    ConnectionTracker:Track(tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if tabList then
            tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
        end
    end))
    
    tabList.Parent = tabContainer
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -120, 1, -40)
    contentContainer.Position = UDim2.new(0, 120, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ClipsDescendants = true
    contentContainer.ZIndex = mainFrame.ZIndex + 1
    
    self.MainFrame = mainFrame
    self.TabList = tabList
    self.ContentContainer = contentContainer
    
    tabContainer.Parent = mainFrame
    contentContainer.Parent = mainFrame
    mainFrame.Parent = self.GUI
    
    self.GUI.Enabled = false
end

function Window:SetupDrag(dragElement, targetElement)
    local dragStart, startPos
    
    local function update(input)
        if not self.IsDragging then return end
        
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
        if not self.IsResizing then return end
        
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
    if not keyCode then return end
    
    local connection
    local success, result = pcall(function()
        connection = ContextActionService:BindAction("ToggleNebulaUI_" .. self.Name, function(_, inputState)
            if inputState == Enum.UserInputState.Begin then
                self:Toggle()
            end
        end, false, keyCode)
    end)
    
    if success then
        table.insert(self._connections, {
            Disconnect = function() 
                ContextActionService:UnbindAction("ToggleNebulaUI_" .. self.Name) 
            end
        })
    else
        local inputConnection = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == keyCode then
                self:Toggle()
            end
        end)
        table.insert(self._connections, inputConnection)
    end
end

function Window:Toggle()
    if not self.GUI or not self.GUI.Parent then return end
    
    for _, tween in ipairs(self._activeTweens) do
        if tween and tween.Cancel then
            pcall(function() tween:Cancel() end)
        end
    end
    self._activeTweens = {}
    
    self.IsOpen = not self.IsOpen
    
    local success, result = pcall(function()
        if self.IsOpen then
            self.GUI.Enabled = true
            self.MainFrame.Visible = true
            self.MainFrame.Size = UDim2.new(0, 500, 0, 0)
            self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
            
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local tween = TweenService:Create(self.MainFrame, tweenInfo, {
                Size = UDim2.new(0, 500, 0, 400)
            })
            
            TweenManager:Track(tween)
            table.insert(self._activeTweens, tween)
            tween:Play()
        else
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
            local tween = TweenService:Create(self.MainFrame, tweenInfo, {
                Size = UDim2.new(0, 500, 0, 0)
            })
            
            TweenManager:Track(tween)
            table.insert(self._activeTweens, tween)
            
            local completedConnection
            completedConnection = tween.Completed:Connect(function()
                if completedConnection then
                    completedConnection:Disconnect()
                end
                if not self.IsOpen and self.GUI then
                    self.GUI.Enabled = false
                end
            end)
            
            tween:Play()
        end
    end)
    
    if not success then
        if self.GUI then
            self.GUI.Enabled = self.IsOpen
            if self.IsOpen and self.MainFrame then
                self.MainFrame.Size = UDim2.new(0, 500, 0, 400)
            elseif self.MainFrame then
                self.MainFrame.Size = UDim2.new(0, 500, 0, 0)
            end
        end
    end
end

function Window:Minimize()
    if not self.MainFrame then return end
    
    self.IsMinimized = not self.IsMinimized
    local targetSize = self.IsMinimized and UDim2.new(0, 500, 0, 40) or UDim2.new(0, 500, 0, 400)
    
    local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    
    TweenManager:Track(tween)
    table.insert(self._activeTweens, tween)
    tween:Play()
    
    local minimizeButton = self.MainFrame.Header:FindFirstChild("MinimizeButton")
    if minimizeButton then
        minimizeButton.Image = self.IsMinimized and FEATHER_ICONS.chevron_up or FEATHER_ICONS.chevron_down
    end
end

function Window:CreateTab(name, icon)
    local tab = {
        Name = name,
        Icon = icon,
        Content = nil,
        Window = self,
        _connections = {},
        _activeTweens = {}
    }
    
    local theme = MODERN_THEMES[self.ThemeName]
    
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
    
    table.insert(tab._connections, tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end))
    
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
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(selectedTab)
    for _, tab in ipairs(self.Tabs) do
        if tab._activeTweens then
            for _, tween in ipairs(tab._activeTweens) do
                if tween and tween.Cancel then
                    pcall(tween.Cancel, tween)
                end
            end
            tab._activeTweens = {}
        end
    end

    for _, tab in ipairs(self.Tabs) do
        if tab.Content.Visible then
            local hideTween = TweenService:Create(tab.Content, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Position = UDim2.new(-0.1, 0, 0, 0)
            })
            
            if not tab._activeTweens then tab._activeTweens = {} end
            table.insert(tab._activeTweens, hideTween)
            hideTween:Play()
        end
        
        tab.Content.Visible = false
        tab.Button.TextColor3 = MODERN_THEMES[self.ThemeName].ON_SURFACE_VARIANT
        tab.Button.BackgroundTransparency = 1
        
        if tab.Button:FindFirstChild("Icon") then
            tab.Button.Icon.ImageColor3 = MODERN_THEMES[self.ThemeName].ON_SURFACE_VARIANT
        end
    end

    selectedTab.Content.Visible = true
    selectedTab.Content.Position = UDim2.new(1.1, 0, 0, 0)
    
    local showTween = TweenService:Create(selectedTab.Content, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    if not selectedTab._activeTweens then selectedTab._activeTweens = {} end
    table.insert(selectedTab._activeTweens, showTween)
    showTween:Play()

    selectedTab.Button.TextColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    selectedTab.Button.BackgroundTransparency = 0.8
    selectedTab.Button.BackgroundColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    
    if selectedTab.Button:FindFirstChild("Icon") then
        selectedTab.Button.Icon.ImageColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    end
end

function Window:CreateButton(tab, options)
    if not tab or not tab.Content then return nil end
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    local button = Instance.new("TextButton")
    button.Name = options.Name or "Button"
    if Nebula_Internal.IsMobile then
        button.Size = UDim2.new(1, -20, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    else
        button.Size = UDim2.new(1, -20, 0, 36)
    end
    button.BackgroundColor3 = theme.PRIMARY
    button.TextColor3 = theme.ON_PRIMARY
    button.Text = options.Name or "Button"
    button.TextSize = Nebula_Internal.IsMobile and MOBILE_SETTINGS.FONT_SIZE_MEDIUM or 14
    button.Font = Enum.Font.SourceSansSemibold
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, MOBILE_SETTINGS.CORNER_RADIUS)
    corner.Parent = button
    
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
    
    local function createRipple(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            RippleEffect:CreateRipple(button, input.Position)
        end
    end
    
    ConnectionTracker:Track(button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.PRIMARY_LIGHT
        }):Play()
    end))
    
    ConnectionTracker:Track(button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.PRIMARY
        }):Play()
    end))
    
    if options.Callback then
        ConnectionTracker:Track(button.InputBegan:Connect(createRipple))
        
        ConnectionTracker:Track(button.MouseButton1Click:Connect(function()
            local success, result = pcall(options.Callback)
            if not success then
                warn("Nebula UI: Button callback error - " .. result)
            end
        end))
    end
    
    button.Parent = tab.Content
    return button
end

function Window:CreateToggle(tab, options)
    if not tab or not tab.Content then return nil end
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = options.Name or "Toggle"
    if Nebula_Internal.IsMobile then
        toggleContainer.Size = UDim2.new(1, -20, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    else
        toggleContainer.Size = UDim2.new(1, -20, 0, 36)
    end
    toggleContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Toggle"
    label.TextColor3 = theme.ON_SURFACE
    label.TextSize = Nebula_Internal.IsMobile and MOBILE_SETTINGS.FONT_SIZE_MEDIUM or 14
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
            end
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, isToggled)
        end
    end
    
    ConnectionTracker:Track(toggleSwitch.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        RippleEffect:CreateRipple(toggleSwitch, Vector2.new(toggleSwitch.AbsolutePosition.X + toggleSwitch.AbsoluteSize.X/2, toggleSwitch.AbsolutePosition.Y + toggleSwitch.AbsoluteSize.Y/2))
    end))
    
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
    if not tab or not tab.Content then return nil end
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = options.Name or "Slider"
    if Nebula_Internal.IsMobile then
        sliderContainer.Size = UDim2.new(1, -20, 0, 70)
    else
        sliderContainer.Size = UDim2.new(1, -20, 0, 60)
    end
    sliderContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = options.Name or "Slider"
    label.TextColor3 = theme.ON_SURFACE
    label.TextSize = Nebula_Internal.IsMobile and MOBILE_SETTINGS.FONT_SIZE_MEDIUM or 14
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
    valueLabel.TextSize = Nebula_Internal.IsMobile and MOBILE_SETTINGS.FONT_SIZE_SMALL or 12
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
    
    local isDragging = false
    
    local function updateSlider(value, showTooltip)
        currentValue = math.floor((value - minValue) / increment) * increment + minValue
        currentValue = math.clamp(currentValue, minValue, maxValue)
        
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        thumb.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(currentValue) .. (options.Suffix or "")
        
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
    end
    
    ConnectionTracker:Track(track.InputBegan:Connect(onInput))
    
    ConnectionTracker:Track(track.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                local relativeX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                local percentage = relativeX / track.AbsoluteSize.X
                updateSlider(percentage * (maxValue - minValue) + minValue, true)
            end
        end
    end))
    
    ConnectionTracker:Track(UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            endDrag()
        end
    end))
    
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
    if not tab or not tab.Content then return nil end
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = options.Name or "Input"
    if Nebula_Internal.IsMobile then
        inputContainer.Size = UDim2.new(1, -20, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    else
        inputContainer.Size = UDim2.new(1, -20, 0, 36)
    end
    inputContainer.BackgroundTransparency = 1
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, 0, 1, 0)
    textBox.BackgroundColor3 = theme.SURFACE_VARIANT
    textBox.TextColor3 = theme.ON_SURFACE
    textBox.PlaceholderText = options.PlaceholderText or ""
    textBox.Text = options.CurrentValue or ""
    textBox.TextSize = Nebula_Internal.IsMobile and MOBILE_SETTINGS.FONT_SIZE_MEDIUM or 14
    textBox.Font = Enum.Font.SourceSans
    textBox.ClearTextOnFocus = options.RemoveTextAfterFocusLost or false
    textBox.PlaceholderColor3 = theme.ON_SURFACE_VARIANT
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, MOBILE_SETTINGS.CORNER_RADIUS)
    corner.Parent = textBox
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = textBox
    
    ConnectionTracker:Track(textBox.Focused:Connect(function()
        TweenService:Create(textBox, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.SURFACE,
            TextColor3 = theme.ON_SURFACE
        }):Play()
    end))
    
    ConnectionTracker:Track(textBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(textBox, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.SURFACE_VARIANT,
            TextColor3 = theme.ON_SURFACE
        }):Play()
        
        if options.Callback then
            local success, result = pcall(options.Callback, textBox.Text, enterPressed)
            if not success then
                warn("Nebula UI: Input callback error - " .. result)
            end
        end
        
        if options.Flag then
            ConfigurationSystem:SetFlag(options.Flag, textBox.Text)
        end
    end))
    
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

function Window:Cleanup()
    for i, connection in ipairs(self._connections) do
        if connection and type(connection.Disconnect) == "function" then
            pcall(function() connection:Disconnect() end)
        end
    end
    self._connections = {}
    
    for i, tween in ipairs(self._activeTweens) do
        if tween and tween.Cancel then
            pcall(function() tween:Cancel() end)
        end
    end
    self._activeTweens = {}
    
    for _, tab in ipairs(self.Tabs) do
        if tab._connections then
            for _, conn in ipairs(tab._connections) do
                if conn and type(conn.Disconnect) == "function" then
                    pcall(function() conn:Disconnect() end)
                end
            end
        end
    end
    self.Tabs = {}
    
    if self.GUI then
        self.GUI:Destroy()
        self.GUI = nil
    end
    
    for i, window in ipairs(Nebula_Internal.Windows) do
        if window == self then
            table.remove(Nebula_Internal.Windows, i)
            break
        end
    end
end

function Nebula:CreateWindow(options)
    options = options or {}
    
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
    if #Nebula_Internal.Windows > 0 then
        local window = Nebula_Internal.Windows[1]
        if window.NotificationManager then
            window.NotificationManager:ShowNotification(options)
        end
    end
end

function Nebula:SetGlobalTheme(themeName)
    if not MODERN_THEMES[themeName] then return end
    
    Nebula_Internal.CurrentTheme = themeName
    for _, window in ipairs(Nebula_Internal.Windows) do
        window:SetTheme(themeName)
    end
end

function Nebula:GetVersion()
    return Nebula_Internal.Version
end

function Nebula:GetDeviceInfo()
    return {
        Type = DeviceInfo.IsMobile and "Mobile" or DeviceInfo.IsDesktop and "Desktop" or DeviceInfo.IsConsole and "Console" or "Unknown",
        IsMobile = DeviceInfo.IsMobile,
        IsTablet = DeviceInfo.IsTablet,
        IsDesktop = DeviceInfo.IsDesktop,
        IsTouch = DeviceInfo.IsTouch,
        IsMouse = DeviceInfo.IsMouse,
        Platform = tostring(DeviceInfo.Platform),
        ScreenSize = DeviceInfo.ViewportSize,
        Orientation = DeviceInfo.IsPortrait and "Portrait" or "Landscape"
    }
end

function Nebula:IsMobileDevice()
    return DeviceInfo.IsMobile
end

function Nebula:IsDesktopDevice()
    return DeviceInfo.IsDesktop
end

function Nebula:Cleanup()
    for _, window in ipairs(Nebula_Internal.Windows) do
        window:Cleanup()
    end
    
    ConnectionTracker:Cleanup()
    TweenManager:CancelAll()
    
    if ConfigurationSystem.DataStore then
        ConfigurationSystem:SaveConfiguration()
    end
    
    Nebula_Internal.Windows = {}
end

ConfigurationSystem:Initialize()

if getgenv then
    getgenv().Nebula = Nebula
end

return Nebula
