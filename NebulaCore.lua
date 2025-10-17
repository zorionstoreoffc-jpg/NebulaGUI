-- Nebula UI Library v5.0.0 - Modernized and Enhanced
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
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Device Detection System
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

-- Icon Library
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
    file_text = "rbxassetid://7733960981",
    loading = "rbxassetid://7734053495",
    spinner = "rbxassetid://7734021456"
}

-- Modern Theme System
local MODERN_THEMES = {
    Default = {
        PRIMARY = Color3.fromRGB(0, 120, 215),
        PRIMARY_LIGHT = Color3.fromRGB(96, 171, 232),
        PRIMARY_CONTAINER = Color3.fromRGB(232, 240, 254),
        SURFACE = Color3.fromRGB(32, 32, 32),
        SURFACE_VARIANT = Color3.fromRGB(42, 42, 42),
        BACKGROUND = Color3.fromRGB(25, 25, 25),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(255, 255, 255),
        ON_SURFACE_VARIANT = Color3.fromRGB(180, 180, 180),
        OUTLINE = Color3.fromRGB(65, 65, 65),
        OUTLINE_VARIANT = Color3.fromRGB(55, 55, 55),
        SUCCESS = Color3.fromRGB(52, 199, 89),
        WARNING = Color3.fromRGB(255, 149, 0),
        ERROR = Color3.fromRGB(255, 59, 48),
        SHADOW = Color3.fromRGB(0, 0, 0),
        GLASS = Color3.fromRGB(255, 255, 255),
        ACCENT = Color3.fromRGB(0, 184, 148)
    },
    Light = {
        PRIMARY = Color3.fromRGB(0, 120, 215),
        PRIMARY_LIGHT = Color3.fromRGB(96, 171, 232),
        PRIMARY_CONTAINER = Color3.fromRGB(232, 240, 254),
        SURFACE = Color3.fromRGB(255, 255, 255),
        SURFACE_VARIANT = Color3.fromRGB(249, 249, 249),
        BACKGROUND = Color3.fromRGB(243, 243, 243),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(32, 32, 32),
        ON_SURFACE_VARIANT = Color3.fromRGB(117, 117, 117),
        OUTLINE = Color3.fromRGB(225, 225, 225),
        OUTLINE_VARIANT = Color3.fromRGB(200, 200, 200),
        SUCCESS = Color3.fromRGB(16, 124, 16),
        WARNING = Color3.fromRGB(157, 93, 0),
        ERROR = Color3.fromRGB(197, 0, 0),
        SHADOW = Color3.fromRGB(0, 0, 0),
        GLASS = Color3.fromRGB(255, 255, 255),
        ACCENT = Color3.fromRGB(0, 184, 148)
    },
    Dark = {
        PRIMARY = Color3.fromRGB(96, 171, 232),
        PRIMARY_LIGHT = Color3.fromRGB(120, 185, 240),
        PRIMARY_CONTAINER = Color3.fromRGB(32, 50, 70),
        SURFACE = Color3.fromRGB(32, 32, 32),
        SURFACE_VARIANT = Color3.fromRGB(42, 42, 42),
        BACKGROUND = Color3.fromRGB(25, 25, 25),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(255, 255, 255),
        ON_SURFACE_VARIANT = Color3.fromRGB(180, 180, 180),
        OUTLINE = Color3.fromRGB(65, 65, 65),
        OUTLINE_VARIANT = Color3.fromRGB(55, 55, 55),
        SUCCESS = Color3.fromRGB(52, 199, 89),
        WARNING = Color3.fromRGB(255, 149, 0),
        ERROR = Color3.fromRGB(255, 59, 48),
        SHADOW = Color3.fromRGB(0, 0, 0),
        GLASS = Color3.fromRGB(255, 255, 255),
        ACCENT = Color3.fromRGB(0, 184, 148)
    },
    Modern = {
        PRIMARY = Color3.fromRGB(0, 184, 148),
        PRIMARY_LIGHT = Color3.fromRGB(85, 239, 203),
        PRIMARY_CONTAINER = Color3.fromRGB(224, 255, 244),
        SURFACE = Color3.fromRGB(248, 250, 252),
        SURFACE_VARIANT = Color3.fromRGB(241, 245, 249),
        BACKGROUND = Color3.fromRGB(226, 232, 240),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(30, 41, 59),
        ON_SURFACE_VARIANT = Color3.fromRGB(100, 116, 139),
        OUTLINE = Color3.fromRGB(203, 213, 225),
        OUTLINE_VARIANT = Color3.fromRGB(148, 163, 184),
        SUCCESS = Color3.fromRGB(34, 197, 94),
        WARNING = Color3.fromRGB(245, 158, 11),
        ERROR = Color3.fromRGB(239, 68, 68),
        SHADOW = Color3.fromRGB(51, 65, 85),
        GLASS = Color3.fromRGB(255, 255, 255),
        ACCENT = Color3.fromRGB(139, 92, 246)
    },
    Neon = {
        PRIMARY = Color3.fromRGB(139, 92, 246),
        PRIMARY_LIGHT = Color3.fromRGB(196, 181, 253),
        PRIMARY_CONTAINER = Color3.fromRGB(237, 233, 254),
        SURFACE = Color3.fromRGB(17, 24, 39),
        SURFACE_VARIANT = Color3.fromRGB(31, 41, 55),
        BACKGROUND = Color3.fromRGB(3, 7, 18),
        ON_PRIMARY = Color3.fromRGB(255, 255, 255),
        ON_SURFACE = Color3.fromRGB(243, 244, 246),
        ON_SURFACE_VARIANT = Color3.fromRGB(156, 163, 175),
        OUTLINE = Color3.fromRGB(75, 85, 99),
        OUTLINE_VARIANT = Color3.fromRGB(55, 65, 81),
        SUCCESS = Color3.fromRGB(52, 211, 153),
        WARNING = Color3.fromRGB(251, 191, 36),
        ERROR = Color3.fromRGB(248, 113, 113),
        SHADOW = Color3.fromRGB(0, 0, 0),
        GLASS = Color3.fromRGB(255, 255, 255),
        ACCENT = Color3.fromRGB(236, 72, 153)
    }
}

-- Typography System
local TYPOGRAPHY = {
    Heading1 = {
        Size = 32,
        Weight = Enum.Font.SourceSansBold,
        LineHeight = 1.2
    },
    Heading2 = {
        Size = 24,
        Weight = Enum.Font.SourceSansBold,
        LineHeight = 1.2
    },
    Heading3 = {
        Size = 20,
        Weight = Enum.Font.SourceSansSemibold,
        LineHeight = 1.3
    },
    Heading4 = {
        Size = 18,
        Weight = Enum.Font.SourceSansSemibold,
        LineHeight = 1.3
    },
    Heading5 = {
        Size = 16,
        Weight = Enum.Font.SourceSansSemibold,
        LineHeight = 1.4
    },
    Heading6 = {
        Size = 14,
        Weight = Enum.Font.SourceSansSemibold,
        LineHeight = 1.4
    },
    BodyLarge = {
        Size = 16,
        Weight = Enum.Font.SourceSans,
        LineHeight = 1.5
    },
    BodyMedium = {
        Size = 14,
        Weight = Enum.Font.SourceSans,
        LineHeight = 1.5
    },
    BodySmall = {
        Size = 12,
        Weight = Enum.Font.SourceSans,
        LineHeight = 1.4
    },
    Label = {
        Size = 14,
        Weight = Enum.Font.SourceSansSemibold,
        LineHeight = 1.3
    },
    Caption = {
        Size = 12,
        Weight = Enum.Font.SourceSans,
        LineHeight = 1.3
    }
}

-- Spacing System (4px base unit)
local SPACING = {
    XS = 4,
    S = 8,
    M = 12,
    L = 16,
    XL = 24,
    XXL = 32,
    XXXL = 48
}

-- Mobile Settings
local MOBILE_SETTINGS = {
    SIDEBAR_WIDTH = UDim.new(0.7, 0),
    SIDEBAR_MIN_WIDTH = 280,
    CONTENT_PADDING = 20,
    ELEMENT_HEIGHT = DeviceInfo.IsTablet and 48 or 52,
    CORNER_RADIUS = DeviceInfo.IsTablet and 14 or 12,
    ANIMATION_DURATION = 0.3,
    TOUCH_TARGET = DeviceInfo.IsTablet and 48 or 44,
    FONT_SIZE_SMALL = 12,
    FONT_SIZE_MEDIUM = 14,
    FONT_SIZE_LARGE = 16
}

-- Animation Easing Functions
local EASING = {
    Smooth = Enum.EasingStyle.Cubic,
    SmoothIn = Enum.EasingStyle.Cubic,
    SmoothOut = Enum.EasingStyle.Cubic,
    SmoothInOut = Enum.EasingStyle.Cubic,
    Spring = Enum.EasingStyle.Back,
    Bounce = Enum.EasingStyle.Bounce,
    Elastic = Enum.EasingStyle.Elastic,
    Linear = Enum.EasingStyle.Linear
}

-- Animation Durations
local DURATIONS = {
    Fast = 0.15,
    Normal = 0.2,
    Slow = 0.3,
    Slower = 0.4,
    PageTransition = 0.3,
    ModalTransition = 0.25,
    Focus = 0.1
}

-- Internal State
local Nebula_Internal = {
    Windows = {},
    Toasts = {},
    CurrentTheme = "Default",
    DeviceInfo = DeviceInfo,
    IsMobile = DeviceInfo.IsMobile,
    IsDesktop = DeviceInfo.IsDesktop,
    Version = "5.0.0",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "NebulaUI",
        FileName = "Configuration"
    },
    ToggleUIKeybind = "K",
    DebugMode = false,
    ActiveConnections = {},
    ActiveTweens = {},
    EventListeners = {},
    LoadingStates = {},
    HoverEffects = {}
}

-- Configuration System
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

-- Connection Tracker
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

-- Tween Manager
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

-- Modern Hover Effects System
local HoverEffect = {}
HoverEffect.__index = HoverEffect

function HoverEffect:Create(element, options)
    options = options or {}
    
    local theme = MODERN_THEMES[Nebula_Internal.CurrentTheme]
    local defaultColor = element.BackgroundColor3
    local hoverColor = options.HoverColor or theme.PRIMARY_LIGHT
    local scaleAmount = options.ScaleAmount or 1.02
    local shadowAmount = options.ShadowAmount or 0.15
    local duration = options.Duration or DURATIONS.Fast
    
    -- Store original properties
    local originalSize = element.Size
    local originalPosition = element.Position
    local originalColor = element.BackgroundColor3
    local originalTransparency = element.BackgroundTransparency
    
    -- Create shadow if not exists
    local shadow = element:FindFirstChild("Shadow")
    if not shadow then
        shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0, -5, 0, -5)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://5554236773"
        shadow.ImageColor3 = theme.SHADOW
        shadow.ImageTransparency = 0.7
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.ZIndex = element.ZIndex - 1
        shadow.Parent = element
    end
    
    -- Create gradient overlay if not exists
    local gradientOverlay = element:FindFirstChild("GradientOverlay")
    if not gradientOverlay then
        gradientOverlay = Instance.new("Frame")
        gradientOverlay.Name = "GradientOverlay"
        gradientOverlay.Size = UDim2.new(1, 0, 1, 0)
        gradientOverlay.Position = UDim2.new(0, 0, 0, 0)
        gradientOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        gradientOverlay.BackgroundTransparency = 0.9
        gradientOverlay.BorderSizePixel = 0
        gradientOverlay.ZIndex = element.ZIndex + 1
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = element:FindFirstChildOfClass("UICorner") and 
                             element:FindFirstChildOfClass("UICorner").CornerRadius or UDim.new(0, 8)
        corner.Parent = gradientOverlay
        
        gradientOverlay.Parent = element
    end
    
    -- Track hover state
    local isHovering = false
    
    -- Hover enter function
    local function onHoverEnter()
        if isHovering then return end
        isHovering = true
        
        local tweenInfo = TweenInfo.new(duration, EASING.SmoothOut)
        
        -- Scale animation
        local scaleTween = TweenService:Create(element, tweenInfo, {
            Size = UDim2.new(
                originalSize.X.Scale, 
                originalSize.X.Offset * scaleAmount, 
                originalSize.Y.Scale, 
                originalSize.Y.Offset * scaleAmount
            )
        })
        TweenManager:Track(scaleTween)
        scaleTween:Play()
        
        -- Color animation
        local colorTween = TweenService:Create(element, tweenInfo, {
            BackgroundColor3 = hoverColor
        })
        TweenManager:Track(colorTween)
        colorTween:Play()
        
        -- Shadow animation
        local shadowTween = TweenService:Create(shadow, tweenInfo, {
            ImageTransparency = 0.5 - shadowAmount
        })
        TweenManager:Track(shadowTween)
        shadowTween:Play()
        
        -- Gradient overlay animation
        local gradientTween = TweenService:Create(gradientOverlay, tweenInfo, {
            BackgroundTransparency = 0.8
        })
        TweenManager:Track(gradientTween)
        gradientTween:Play()
    end
    
    -- Hover leave function
    local function onHoverLeave()
        if not isHovering then return end
        isHovering = false
        
        local tweenInfo = TweenInfo.new(duration, EASING.SmoothOut)
        
        -- Scale animation
        local scaleTween = TweenService:Create(element, tweenInfo, {
            Size = originalSize
        })
        TweenManager:Track(scaleTween)
        scaleTween:Play()
        
        -- Color animation
        local colorTween = TweenService:Create(element, tweenInfo, {
            BackgroundColor3 = originalColor
        })
        TweenManager:Track(colorTween)
        colorTween:Play()
        
        -- Shadow animation
        local shadowTween = TweenService:Create(shadow, tweenInfo, {
            ImageTransparency = 0.7
        })
        TweenManager:Track(shadowTween)
        shadowTween:Play()
        
        -- Gradient overlay animation
        local gradientTween = TweenService:Create(gradientOverlay, tweenInfo, {
            BackgroundTransparency = 0.9
        })
        TweenManager:Track(gradientTween)
        gradientTween:Play()
    end
    
    -- Connect events
    local mouseEnter = ConnectionTracker:Track(element.MouseEnter:Connect(onHoverEnter))
    local mouseLeave = ConnectionTracker:Track(element.MouseLeave:Connect(onHoverLeave))
    
    -- Touch events for mobile
    if DeviceInfo.IsTouch then
        local touchBegan = ConnectionTracker:Track(element.TouchTap:Connect(function()
            onHoverEnter()
            delay(duration * 2, function()
                onHoverLeave()
            end)
        end))
    end
    
    -- Return cleanup function
    return function()
        if mouseEnter then mouseEnter:Disconnect() end
        if mouseLeave then mouseLeave:Disconnect() end
        if shadow then shadow:Destroy() end
        if gradientOverlay then gradientOverlay:Destroy() end
    end
end

-- Loading UI System
local LoadingUI = {}
LoadingUI.__index = LoadingUI

function LoadingUI:CreateSpinner(parent, options)
    options = options or {}
    local size = options.Size or UDim2.new(0, 24, 0, 24)
    local color = options.Color or MODERN_THEMES[Nebula_Internal.CurrentTheme].PRIMARY
    local duration = options.Duration or 2
    
    local spinner = Instance.new("ImageLabel")
    spinner.Name = "Spinner"
    spinner.Size = size
    spinner.BackgroundTransparency = 1
    spinner.Image = FEATHER_ICONS.spinner
    spinner.ImageColor3 = color
    spinner.Parent = parent
    
    local rotationTween = TweenService:Create(spinner, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Infinite, -1), {
        Rotation = 360
    })
    TweenManager:Track(rotationTween)
    rotationTween:Play()
    
    return spinner
end

function LoadingUI:CreateProgressBar(parent, options)
    options = options or {}
    local size = options.Size or UDim2.new(1, 0, 0, 4)
    local position = options.Position or UDim2.new(0, 0, 0, 0)
    local color = options.Color or MODERN_THEMES[Nebula_Internal.CurrentTheme].PRIMARY
    local indeterminate = options.Indeterminate or false
    
    local container = Instance.new("Frame")
    container.Name = "ProgressBar"
    container.Size = size
    container.Position = position
    container.BackgroundColor3 = MODERN_THEMES[Nebula_Internal.CurrentTheme].OUTLINE
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = container
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = color
    fill.BorderSizePixel = 0
    fill.Parent = container
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    if indeterminate then
        local indeterminateTween = TweenService:Create(fill, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0.3, 0, 0, 0)
        })
        TweenManager:Track(indeterminateTween)
        indeterminateTween:Play()
    end
    
    return {
        Container = container,
        Fill = fill,
        SetProgress = function(self, value)
            value = math.clamp(value, 0, 1)
            fill:TweenSize(
                UDim2.new(value, 0, 1, 0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Cubic,
                0.3,
                true
            )
        end
    }
end

function LoadingUI:CreateSkeleton(parent, options)
    options = options or {}
    local width = options.Width or UDim.new(1, 0)
    local height = options.Height or UDim.new(0, 20)
    local position = options.Position or UDim2.new(0, 0, 0, 0)
    local cornerRadius = options.CornerRadius or UDim.new(0, 4)
    
    local skeleton = Instance.new("Frame")
    skeleton.Name = "Skeleton"
    skeleton.Size = UDim2.new(width, height)
    skeleton.Position = position
    skeleton.BackgroundColor3 = MODERN_THEMES[Nebula_Internal.CurrentTheme].OUTLINE
    skeleton.BorderSizePixel = 0
    skeleton.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = cornerRadius
    corner.Parent = skeleton
    
    local shimmer = Instance.new("Frame")
    shimmer.Name = "Shimmer"
    shimmer.Size = UDim2.new(0.5, 0, 1, 0)
    shimmer.Position = UDim2.new(-0.5, 0, 0, 0)
    shimmer.BackgroundTransparency = 0.2
    shimmer.BorderSizePixel = 0
    shimmer.Parent = skeleton
    
    local shimmerCorner = Instance.new("UICorner")
    shimmerCorner.CornerRadius = cornerRadius
    shimmerCorner.Parent = shimmer
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    gradient.Rotation = 90
    gradient.Parent = shimmer
    
    local shimmerTween = TweenService:Create(shimmer, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Position = UDim2.new(1, 0, 0, 0)
    })
    TweenManager:Track(shimmerTween)
    shimmerTween:Play()
    
    return skeleton
end

function LoadingUI:CreateLoadingOverlay(parent, options)
    options = options or {}
    local message = options.Message or "Loading..."
    local showSpinner = options.ShowSpinner ~= false
    local showProgress = options.ShowProgress or false
    
    local overlay = Instance.new("Frame")
    overlay.Name = "LoadingOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.3
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1000
    overlay.Parent = parent
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 200, 0, 100)
    container.Position = UDim2.new(0.5, -100, 0.5, -50)
    container.BackgroundColor3 = MODERN_THEMES[Nebula_Internal.CurrentTheme].SURFACE
    container.BorderSizePixel = 0
    container.ZIndex = overlay.ZIndex + 1
    container.Parent = overlay
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container
    
    local containerShadow = Instance.new("ImageLabel")
    containerShadow.Name = "Shadow"
    containerShadow.Size = UDim2.new(1, 20, 1, 20)
    containerShadow.Position = UDim2.new(0, -10, 0, -10)
    containerShadow.BackgroundTransparency = 1
    containerShadow.Image = "rbxassetid://5554236773"
    containerShadow.ImageColor3 = MODERN_THEMES[Nebula_Internal.CurrentTheme].SHADOW
    containerShadow.ImageTransparency = 0.5
    containerShadow.ScaleType = Enum.ScaleType.Slice
    containerShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    containerShadow.ZIndex = container.ZIndex - 1
    containerShadow.Parent = container
    
    if showSpinner then
        local spinner = LoadingUI:CreateSpinner(container, {
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(0.5, -16, 0, 20)
        })
    end
    
    if showProgress then
        local progressBar = LoadingUI:CreateProgressBar(container, {
            Size = UDim2.new(0.8, 0, 0, 4),
            Position = UDim2.new(0.1, 0, 0, 60)
        })
    end
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(0.8, 0, 0, 20)
    messageLabel.Position = UDim2.new(0.1, 0, 0, 70)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = MODERN_THEMES[Nebula_Internal.CurrentTheme].ON_SURFACE
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.SourceSans
    messageLabel.TextXAlignment = Enum.TextXAlignment.Center
    messageLabel.ZIndex = container.ZIndex + 1
    messageLabel.Parent = container
    
    return {
        Overlay = overlay,
        Container = container,
        MessageLabel = messageLabel,
        SetMessage = function(self, newMessage)
            messageLabel.Text = newMessage
        end,
        SetProgress = function(self, value)
            if progressBar then
                progressBar:SetProgress(value)
            end
        end,
        Destroy = function(self)
            overlay:Destroy()
        end
    }
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
    self._connections = {}
    self._activeTweens = {}
    self.IsDragging = false
    self.IsResizing = false
    self.DragStartPosition = nil
    self.StartSize = nil
    self.IsMinimized = false
    self.LoadingStates = {}
    
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
        mainFrame.Size = UDim2.new(0, 600, 0, 450)
        mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    end
    mainFrame.BackgroundColor3 = theme.SURFACE
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 10
    mainFrame.Visible = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Modern shadow with blur effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236773"
    shadow.ImageColor3 = theme.SHADOW
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    -- Glassmorphism effect
    local glassEffect = Instance.new("Frame")
    glassEffect.Name = "GlassEffect"
    glassEffect.Size = UDim2.new(1, 0, 1, 0)
    glassEffect.Position = UDim2.new(0, 0, 0, 0)
    glassEffect.BackgroundColor3 = theme.GLASS
    glassEffect.BackgroundTransparency = 0.9
    glassEffect.BorderSizePixel = 0
    glassEffect.ZIndex = mainFrame.ZIndex + 1
    
    local glassCorner = Instance.new("UICorner")
    glassCorner.CornerRadius = UDim.new(0, 12)
    glassCorner.Parent = glassEffect
    
    glassEffect.Parent = mainFrame
    
    -- Header with gradient
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = theme.PRIMARY
    header.BorderSizePixel = 0
    header.ZIndex = mainFrame.ZIndex + 2
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.PRIMARY),
        ColorSequenceKeypoint.new(1, theme.PRIMARY_LIGHT)
    }
    headerGradient.Parent = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    headerCorner.Parent = header
    
    if self.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(0, 12, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Image = FEATHER_ICONS[self.Icon] or self.Icon
        icon.ImageColor3 = theme.ON_PRIMARY
        icon.ZIndex = header.ZIndex + 1
        icon.Parent = header
    end
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = self.Icon and UDim2.new(1, -140, 1, 0) or UDim2.new(1, -100, 1, 0)
    title.Position = self.Icon and UDim2.new(0, 44, 0, 0) or UDim2.new(0, 16, 0, 0)
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
    closeButton.Size = UDim2.new(0, 32, 0, 32)
    closeButton.Position = UDim2.new(1, -38, 0.5, -16)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = FEATHER_ICONS.x
    closeButton.ImageColor3 = theme.ON_PRIMARY
    closeButton.ZIndex = header.ZIndex + 1
    closeButton.Parent = header
    
    -- Apply hover effect to close button
    HoverEffect:Create(closeButton, {
        HoverColor = theme.ERROR,
        ScaleAmount = 1.1
    })
    
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 32, 0, 32)
    minimizeButton.Position = UDim2.new(1, -76, 0.5, -16)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Image = FEATHER_ICONS.chevron_down
    minimizeButton.ImageColor3 = theme.ON_PRIMARY
    minimizeButton.ZIndex = header.ZIndex + 1
    minimizeButton.Parent = header
    
    -- Apply hover effect to minimize button
    HoverEffect:Create(minimizeButton, {
        HoverColor = theme.PRIMARY_LIGHT,
        ScaleAmount = 1.1
    })
    
    self:SetupDrag(header, mainFrame)
    self:SetupResize(mainFrame)
    
    ConnectionTracker:Track(closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end))
    
    ConnectionTracker:Track(minimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end))
    
    header.Parent = mainFrame
    
    -- Tab container with modern design
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = theme.SURFACE_VARIANT
    tabContainer.BorderSizePixel = 0
    tabContainer.ZIndex = mainFrame.ZIndex + 1
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 0, 0, 12)
    tabCorner.Parent = tabContainer
    
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
    tabLayout.Padding = UDim.new(0, SPACING.S)
    tabLayout.Parent = tabList
    
    ConnectionTracker:Track(tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if tabList then
            tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
        end
    end))
    
    tabList.Parent = tabContainer
    
    -- Content container with modern design
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -150, 1, -50)
    contentContainer.Position = UDim2.new(0, 150, 0, 50)
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
            startSize.X.Scale, math.max(500, startSize.X.Offset + delta.X),
            startSize.Y.Scale, math.max(400, startSize.Y.Offset + delta.Y)
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
            self.MainFrame.Size = UDim2.new(0, 600, 0, 0)
            self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
            
            local tweenInfo = TweenInfo.new(DURATIONS.PageTransition, EASING.Spring, Enum.EasingDirection.Out)
            local tween = TweenService:Create(self.MainFrame, tweenInfo, {
                Size = UDim2.new(0, 600, 0, 450)
            })
            
            TweenManager:Track(tween)
            table.insert(self._activeTweens, tween)
            tween:Play()
        else
            local tweenInfo = TweenInfo.new(DURATIONS.Normal, EASING.SmoothIn, Enum.EasingDirection.In)
            local tween = TweenService:Create(self.MainFrame, tweenInfo, {
                Size = UDim2.new(0, 600, 0, 0)
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
                self.MainFrame.Size = UDim2.new(0, 600, 0, 450)
            elseif self.MainFrame then
                self.MainFrame.Size = UDim2.new(0, 600, 0, 0)
            end
        end
    end
end

function Window:Minimize()
    if not self.MainFrame then return end
    
    self.IsMinimized = not self.IsMinimized
    local targetSize = self.IsMinimized and UDim2.new(0, 600, 0, 50) or UDim2.new(0, 600, 0, 450)
    
    local tween = TweenService:Create(self.MainFrame, TweenInfo.new(DURATIONS.Normal, EASING.SmoothOut, Enum.EasingDirection.Out), {
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
        _activeTweens = {},
        Badge = nil
    }
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    -- Create tab button with proper layout
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, -SPACING.S * 2, 0, 44)
    tabButton.Position = UDim2.new(0, SPACING.S, 0, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = tabButton
    
    -- Create layout for icon and text
    local layout = Instance.new("Frame")
    layout.Name = "Layout"
    layout.Size = UDim2.new(1, -SPACING.M * 2, 1, 0)
    layout.Position = UDim2.new(0, SPACING.M, 0, 0)
    layout.BackgroundTransparency = 1
    layout.Parent = tabButton
    
    local layoutList = Instance.new("UIListLayout")
    layoutList.FillDirection = Enum.FillDirection.Horizontal
    layoutList.Padding = UDim.new(0, SPACING.M)
    layoutList.VerticalAlignment = Enum.VerticalAlignment.Center
    layoutList.Parent = layout
    
    -- Add icon if provided
    if icon then
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = FEATHER_ICONS[icon] or icon
        tabIcon.ImageColor3 = theme.ON_SURFACE_VARIANT
        tabIcon.Parent = layout
    end
    
    -- Add text label
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = theme.ON_SURFACE_VARIANT
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.SourceSansSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextTruncate = Enum.TextTruncate.AtEnd
    textLabel.Parent = layout
    
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
    contentLayout.Padding = UDim.new(0, SPACING.S)
    contentLayout.Parent = contentFrame
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, SPACING.M)
    contentPadding.PaddingLeft = UDim.new(0, SPACING.M)
    contentPadding.PaddingRight = UDim.new(0, SPACING.M)
    contentPadding.PaddingBottom = UDim.new(0, SPACING.M)
    contentPadding.Parent = contentFrame
    
    tabButton.Parent = self.TabList
    contentFrame.Parent = self.ContentContainer
    
    tab.Button = tabButton
    tab.Content = contentFrame
    tab.TextLabel = textLabel
    tab.Icon = icon and tabButton:FindFirstChild("Layout"):FindFirstChild("Icon")
    
    table.insert(self.Tabs, tab)
    
    -- Apply hover effect to tab button
    local cleanupHover = HoverEffect:Create(tabButton, {
        HoverColor = theme.PRIMARY_CONTAINER,
        ScaleAmount = 1.01
    })
    
    table.insert(tab._connections, tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
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
            local hideTween = TweenService:Create(tab.Content, TweenInfo.new(DURATIONS.Normal, EASING.SmoothOut, Enum.EasingDirection.Out), {
                Position = UDim2.new(-0.1, 0, 0, 0)
            })
            
            if not tab._activeTweens then tab._activeTweens = {} end
            table.insert(tab._activeTweens, hideTween)
            hideTween:Play()
        end
        
        tab.Content.Visible = false
        tab.TextLabel.TextColor3 = MODERN_THEMES[self.ThemeName].ON_SURFACE_VARIANT
        tab.Button.BackgroundTransparency = 1
        
        if tab.Icon then
            tab.Icon.ImageColor3 = MODERN_THEMES[self.ThemeName].ON_SURFACE_VARIANT
        end
    end

    selectedTab.Content.Visible = true
    selectedTab.Content.Position = UDim2.new(1.1, 0, 0, 0)
    
    local showTween = TweenService:Create(selectedTab.Content, TweenInfo.new(DURATIONS.PageTransition, EASING.SmoothOut, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    if not selectedTab._activeTweens then selectedTab._activeTweens = {} end
    table.insert(selectedTab._activeTweens, showTween)
    showTween:Play()

    selectedTab.TextLabel.TextColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    selectedTab.Button.BackgroundTransparency = 0.7
    selectedTab.Button.BackgroundColor3 = MODERN_THEMES[self.ThemeName].PRIMARY_CONTAINER
    
    if selectedTab.Icon then
        selectedTab.Icon.ImageColor3 = MODERN_THEMES[self.ThemeName].PRIMARY
    end
end

function Window:CreateButton(tab, options)
    if not tab or not tab.Content then return nil end
    
    local theme = MODERN_THEMES[self.ThemeName]
    
    local button = Instance.new("TextButton")
    button.Name = options.Name or "Button"
    if Nebula_Internal.IsMobile then
        button.Size = UDim2.new(1, -SPACING.M * 2, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    else
        button.Size = UDim2.new(1, -SPACING.M * 2, 0, 44)
    end
    button.BackgroundColor3 = theme.PRIMARY
    button.TextColor3 = theme.ON_PRIMARY
    button.Text = options.Name or "Button"
    button.TextSize = Nebula_Internal.IsMobile and MOBILE_SETTINGS.FONT_SIZE_MEDIUM or 14
    button.Font = Enum.Font.SourceSansSemibold
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Apply modern hover effect
    HoverEffect:Create(button, {
        HoverColor = theme.PRIMARY_LIGHT,
        ScaleAmount = 1.02
    })
    
    if options.Icon then
        local layout = Instance.new("Frame")
        layout.Name = "Layout"
        layout.Size = UDim2.new(1, -SPACING.M * 2, 1, 0)
        layout.Position = UDim2.new(0, SPACING.M, 0, 0)
        layout.BackgroundTransparency = 1
        layout.Parent = button
        
        local layoutList = Instance.new("UIListLayout")
        layoutList.FillDirection = Enum.FillDirection.Horizontal
        layoutList.Padding = UDim.new(0, SPACING.S)
        layoutList.VerticalAlignment = Enum.VerticalAlignment.Center
        layoutList.Parent = layout
        
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.BackgroundTransparency = 1
        icon.Image = FEATHER_ICONS[options.Icon] or options.Icon
        icon.ImageColor3 = theme.ON_PRIMARY
        icon.Parent = layout
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Text"
        textLabel.Size = UDim2.new(1, -20, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = options.Name or "Button"
        textLabel.TextColor3 = theme.ON_PRIMARY
        textLabel.TextSize = Nebula_Internal.IsMobile and MOBILE_SETTINGS.FONT_SIZE_MEDIUM or 14
        textLabel.Font = Enum.Font.SourceSansSemibold
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = layout
        
        button.Text = ""
    end
    
    if options.Callback then
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
        toggleContainer.Size = UDim2.new(1, -SPACING.M * 2, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    else
        toggleContainer.Size = UDim2.new(1, -SPACING.M * 2, 0, 44)
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
    toggleSwitch.Size = UDim2.new(0, 48, 0, 24)
    toggleSwitch.Position = UDim2.new(1, -56, 0.5, -12)
    toggleSwitch.BackgroundColor3 = theme.OUTLINE
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.AutoButtonColor = false
    toggleSwitch.Text = ""
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch
    
    local toggleThumb = Instance.new("Frame")
    toggleThumb.Name = "Thumb"
    toggleThumb.Size = UDim2.new(0, 20, 0, 20)
    toggleThumb.Position = UDim2.new(0, 2, 0, 2)
    toggleThumb.BackgroundColor3 = theme.SURFACE
    toggleThumb.BorderSizePixel = 0
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = toggleThumb
    toggleThumb.Parent = toggleSwitch
    
    toggleSwitch.Parent = toggleContainer
    
    -- Apply hover effect to toggle switch
    HoverEffect:Create(toggleSwitch, {
        HoverColor = theme.PRIMARY_CONTAINER,
        ScaleAmount = 1.05
    })
    
    local isToggled = options.CurrentValue or false
    if options.Flag then
        isToggled = ConfigurationSystem:GetFlag(options.Flag, isToggled)
    end
    
    local function updateToggle()
        local tweenInfo = TweenInfo.new(DURATIONS.Normal, EASING.SmoothOut, Enum.EasingDirection.Out)
        
        local colorTween = TweenService:Create(toggleSwitch, tweenInfo, {
            BackgroundColor3 = isToggled and theme.PRIMARY or theme.OUTLINE
        })
        TweenManager:Track(colorTween)
        colorTween:Play()
        
        local positionTween = TweenService:Create(toggleThumb, tweenInfo, {
            Position = isToggled and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
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
        sliderContainer.Size = UDim2.new(1, -SPACING.M * 2, 0, 80)
    else
        sliderContainer.Size = UDim2.new(1, -SPACING.M * 2, 0, 70)
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
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 40)
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
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.Position = UDim2.new(0, -9, 0.5, -9)
    thumb.BackgroundColor3 = theme.PRIMARY
    thumb.BorderSizePixel = 0
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    thumb.Parent = track
    
    track.Parent = sliderContainer
    
    -- Apply hover effect to thumb
    HoverEffect:Create(thumb, {
        HoverColor = theme.PRIMARY_LIGHT,
        ScaleAmount = 1.2
    })
    
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
        thumb.Position = UDim2.new(percentage, -9, 0.5, -9)
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
        inputContainer.Size = UDim2.new(1, -SPACING.M * 2, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    else
        inputContainer.Size = UDim2.new(1, -SPACING.M * 2, 0, 44)
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
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = textBox
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, SPACING.M)
    padding.PaddingRight = UDim.new(0, SPACING.M)
    padding.Parent = textBox
    
    -- Apply hover effect to textbox
    HoverEffect:Create(textBox, {
        HoverColor = theme.SURFACE,
        ScaleAmount = 1.01
    })
    
    ConnectionTracker:Track(textBox.Focused:Connect(function()
        TweenService:Create(textBox, TweenInfo.new(DURATIONS.Fast, EASING.SmoothOut), {
            BackgroundColor3 = theme.SURFACE,
            TextColor3 = theme.ON_SURFACE
        }):Play()
    end))
    
    ConnectionTracker:Track(textBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(textBox, TweenInfo.new(DURATIONS.Fast, EASING.SmoothOut), {
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

function Window:ShowLoading(options)
    options = options or {}
    local message = options.Message or "Loading..."
    local showProgress = options.ShowProgress or false
    
    if self.LoadingOverlay then
        self.LoadingOverlay:SetMessage(message)
        if showProgress and options.Progress then
            self.LoadingOverlay:SetProgress(options.Progress)
        end
        return self.LoadingOverlay
    end
    
    self.LoadingOverlay = LoadingUI:CreateLoadingOverlay(self.MainFrame, {
        Message = message,
        ShowProgress = showProgress
    })
    
    return self.LoadingOverlay
end

function Window:HideLoading()
    if self.LoadingOverlay then
        self.LoadingOverlay:Destroy()
        self.LoadingOverlay = nil
    end
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
