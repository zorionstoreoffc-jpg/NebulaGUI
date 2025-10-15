-- Nebula UI Library v3.0
-- Modern Mobile-First GUI Framework for Roblox
-- Inspired by Fluent UI Design Principles

local NebulaUI = {}
NebulaUI.__index = NebulaUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local player reference
local player = Players.LocalPlayer

-- Modern Color System (Fluent UI Inspired)
local MODERN_THEMES = {
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
local NebulaUI_Internal = {
    Windows = {},
    Toasts = {},
    CurrentTheme = "Modern",
    IsMobile = UserInputService.TouchEnabled,
    Version = "3.0.0"
}

-- Modern Toast Notification System
local ToastManager = {}
ToastManager.__index = ToastManager

function ToastManager.new(parentGUI)
    local self = setmetatable({}, ToastManager)
    self.Parent = parentGUI
    self.ActiveToasts = {}
    self.ToastQueue = {}
    return self
end

function ToastManager:ShowToast(options)
    table.insert(self.ToastQueue, options)
    self:ProcessQueue()
end

function ToastManager:ProcessQueue()
    if #self.ActiveToasts >= 3 or #self.ToastQueue == 0 then return end
    
    local toastOptions = table.remove(self.ToastQueue, 1)
    self:CreateToast(toastOptions)
end

function ToastManager:CreateToast(options)
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(0.8, 0, 0, 72)
    toast.Position = UDim2.new(0.1, 0, 0.7, -80)
    toast.BackgroundColor3 = MODERN_THEMES[NebulaUI_Internal.CurrentTheme].SURFACE
    toast.BackgroundTransparency = 0
    toast.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, MOBILE_SETTINGS.CORNER_RADIUS)
    corner.Parent = toast
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236773"
    shadow.ImageColor3 = MODERN_THEMES[NebulaUI_Internal.CurrentTheme].SHADOW
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = toast.ZIndex - 1
    shadow.Parent = toast
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 16, 0, 16)
    icon.BackgroundTransparency = 1
    icon.Image = self:GetIconForType(options.Type or "INFO")
    icon.ImageColor3 = self:GetColorForType(options.Type or "INFO")
    icon.ZIndex = toast.ZIndex + 1
    icon.Parent = toast
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 0, 24)
    title.Position = UDim2.new(0, 56, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = options.Title or "Notification"
    title.TextColor3 = MODERN_THEMES[NebulaUI_Internal.CurrentTheme].ON_SURFACE
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = toast.ZIndex + 1
    title.Parent = toast
    
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -60, 0, 20)
    message.Position = UDim2.new(0, 56, 0, 40)
    message.BackgroundTransparency = 1
    message.Text = options.Content or ""
    message.TextColor3 = MODERN_THEMES[NebulaUI_Internal.CurrentTheme].ON_SURFACE_VARIANT
    message.TextSize = 14
    message.Font = Enum.Font.SourceSans
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.ZIndex = toast.ZIndex + 1
    message.Parent = toast
    
    toast.Parent = self.Parent
    
    -- Animate In
    toast.Position = UDim2.new(0.1, 0, 0.7, 0)
    local tweenIn = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.1, 0, 0.7, -80)
    })
    tweenIn:Play()
    
    table.insert(self.ActiveToasts, toast)
    
    -- Auto dismiss
    local duration = options.Duration or 4
    delay(duration, function()
        self:DismissToast(toast)
    end)
    
    return toast
end

function ToastManager:DismissToast(toast)
    local tweenOut = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.1, 0, 0.7, -60)
    })
    
    for _, child in ipairs(toast:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("ImageLabel") then
            TweenService:Create(child, TweenInfo.new(0.3), {
                TextTransparency = 1,
                ImageTransparency = 1
            }):Play()
        end
    end
    
    tweenOut:Play()
    tweenOut.Completed:Wait()
    
    for i, activeToast in ipairs(self.ActiveToasts) do
        if activeToast == toast then
            table.remove(self.ActiveToasts, i)
            break
        end
    end
    
    toast:Destroy()
    self:ProcessQueue()
end

function ToastManager:GetIconForType(toastType)
    local icons = {
        SUCCESS = "rbxassetid://6026568263",
        WARNING = "rbxassetid://6026568243",
        ERROR = "rbxassetid://6026568278",
        INFO = "rbxassetid://6026568208"
    }
    return icons[toastType] or icons.INFO
end

function ToastManager:GetColorForType(toastType)
    local theme = MODERN_THEMES[NebulaUI_Internal.CurrentTheme]
    local colors = {
        SUCCESS = theme.SUCCESS,
        WARNING = theme.WARNING,
        ERROR = theme.ERROR,
        INFO = theme.PRIMARY
    }
    return colors[toastType] or colors.INFO
end

-- Enhanced Sidebar Navigation
function NebulaUI:CreateWindow(options)
    options = options or {}
    
    local window = {
        Name = options.Name or "NebulaWindow",
        Title = options.Title or "Nebula UI",
        ThemeName = options.Theme or "Modern",
        Tabs = {},
        Flags = {},
        IsOpen = false
    }
    
    setmetatable(window, self)
    
    -- Apply theme
    window.Theme = MODERN_THEMES[window.ThemeName]
    window:BuildModernGUI()
    
    table.insert(NebulaUI_Internal.Windows, window)
    
    return window
end

function NebulaUI:BuildModernGUI()
    -- Main GUI Container
    local gui = Instance.new("ScreenGui")
    gui.Name = self.Name
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    -- Sidebar Navigation
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(MOBILE_SETTINGS.SIDEBAR_WIDTH, 0, 1, 0)
    sidebar.Position = UDim2.new(-1, 0, 0, 0)
    sidebar.BackgroundColor3 = self.Theme.SURFACE
    sidebar.BorderSizePixel = 0
    sidebar.ClipsDescendants = true
    sidebar.ZIndex = 10
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, MOBILE_SETTINGS.CORNER_RADIUS)
    sidebarCorner.Parent = sidebar
    
    local sidebarShadow = Instance.new("ImageLabel")
    sidebarShadow.Name = "SidebarShadow"
    sidebarShadow.Size = UDim2.new(1, 40, 1, 40)
    sidebarShadow.Position = UDim2.new(0, -20, 0, -20)
    sidebarShadow.BackgroundTransparency = 1
    sidebarShadow.Image = "rbxassetid://5554236773"
    sidebarShadow.ImageColor3 = self.Theme.SHADOW
    sidebarShadow.ImageTransparency = 0.9
    sidebarShadow.ScaleType = Enum.ScaleType.Slice
    sidebarShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    sidebarShadow.ZIndex = sidebar.ZIndex - 1
    sidebarShadow.Parent = sidebar
    
    -- Header Section
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 120)
    header.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -40, 0, 32)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = self.Theme.ON_SURFACE
    title.TextSize = 24
    title.Font = Enum.Font.SourceSansSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 55)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "v" .. NebulaUI_Internal.Version
    subtitle.TextColor3 = self.Theme.ON_SURFACE_VARIANT
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.SourceSans
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    header.Parent = sidebar
    
    -- Tab Buttons Container
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, -140)
    tabList.Position = UDim2.new(0, 0, 0, 120)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 3
    tabList.ScrollBarImageColor3 = self.Theme.OUTLINE
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = tabList
    listLayout.Padding = UDim.new(0, 8)
    
    tabList.Parent = sidebar
    
    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -60, 1, -40)
    contentArea.Position = UDim2.new(0, 30, 0, 20)
    contentArea.BackgroundTransparency = 1
    contentArea.Visible = false
    
    contentArea.Parent = gui
    
    -- Overlay for mobile
    local overlay = Instance.new("TextButton")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = self.Theme.SHADOW
    overlay.BackgroundTransparency = 0.7
    overlay.Text = ""
    overlay.AutoButtonColor = false
    overlay.Visible = false
    overlay.ZIndex = 5
    
    overlay.MouseButton1Click:Connect(function()
        self:ToggleSidebar()
    end)
    
    overlay.Parent = gui
    
    -- Mobile Menu Button
    local menuButton = self:CreateModernButton({
        Text = "☰",
        Size = UDim2.new(0, 56, 0, 56),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Theme.PRIMARY
    })
    menuButton.ZIndex = 20
    menuButton.Parent = gui
    
    menuButton.MouseButton1Click:Connect(function()
        self:ToggleSidebar()
    end)
    
    -- Store references
    self.GUI = gui
    self.Sidebar = sidebar
    self.TabList = tabList
    self.ContentArea = contentArea
    self.Overlay = overlay
    self.MenuButton = menuButton
    self.ToastManager = ToastManager.new(gui)
    
    gui.Parent = player.PlayerGui
end

function NebulaUI:CreateModernButton(options)
    options = options or {}
    
    local button = Instance.new("TextButton")
    button.Name = options.Name or "ModernButton"
    button.Size = options.Size or UDim2.new(1, -40, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    button.BackgroundColor3 = options.BackgroundColor3 or self.Theme.SURFACE_VARIANT
    button.Text = options.Text or "Button"
    button.TextColor3 = options.TextColor3 or self.Theme.ON_SURFACE
    button.TextSize = 16
    button.Font = Enum.Font.SourceSansSemibold
    button.AutoButtonColor = false
    button.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, MOBILE_SETTINGS.CORNER_RADIUS)
    corner.Parent = button
    
    -- Ripple effect
    local function createRipple(input)
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0, input.Position.X - button.AbsolutePosition.X, 0, input.Position.Y - button.AbsolutePosition.Y)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = Color3.new(1, 1, 1)
        ripple.BackgroundTransparency = 0.8
        ripple.BorderSizePixel = 0
        ripple.ZIndex = button.ZIndex + 1
        
        local rippleCorner = Instance.new("UICorner")
        rippleCorner.CornerRadius = UDim.new(1, 0)
        rippleCorner.Parent = ripple
        
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
    
    -- Interaction effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = (options.BackgroundColor3 or self.Theme.SURFACE_VARIANT):Lerp(self.Theme.PRIMARY, 0.1)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = options.BackgroundColor3 or self.Theme.SURFACE_VARIANT
        }):Play()
    end)
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            createRipple(input)
            TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = (options.BackgroundColor3 or self.Theme.SURFACE_VARIANT):Lerp(self.Theme.PRIMARY, 0.2)
            }):Play()
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = options.BackgroundColor3 or self.Theme.SURFACE_VARIANT
            }):Play()
        end
    end)
    
    if options.Callback then
        button.MouseButton1Click:Connect(function()
            pcall(options.Callback)
        end)
    end
    
    return button
end

function NebulaUI:CreateTab(options)
    options = options or {}
    
    local tab = {
        Name = options.Name or "Tab",
        Icon = options.Icon,
        Content = nil,
        Window = self
    }
    
    -- Create sidebar tab button
    local tabButton = self:CreateModernButton({
        Name = tab.Name .. "Tab",
        Text = tab.Name,
        BackgroundColor3 = self.Theme.SURFACE_VARIANT
    })
    
    tabButton.Parent = self.TabList
    
    -- Create content frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = tab.Name .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = self.Theme.OUTLINE
    contentFrame.Visible = false
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentFrame
    contentLayout.Padding = UDim.new(0, 12)
    
    contentFrame.Parent = self.ContentArea
    
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

function NebulaUI:SelectTab(selectedTab)
    for _, tab in ipairs(self.Tabs) do
        tab.Content.Visible = false
        TweenService:Create(tab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.SURFACE_VARIANT
        }):Play()
    end
    
    selectedTab.Content.Visible = true
    TweenService:Create(selectedTab.Button, TweenInfo.new(0.2), {
        BackgroundColor3 = self.Theme.PRIMARY
    }):Play()
    
    self.ContentArea.Visible = true
    self:ToggleSidebar(false)
    
    self.ToastManager:ShowToast({
        Title = "Navigation",
        Content = "Switched to " .. selectedTab.Name,
        Type = "INFO",
        Duration = 2
    })
end

function NebulaUI:ToggleSidebar(forceState)
    if forceState == nil then
        forceState = not self.IsOpen
    end
    
    self.IsOpen = forceState
    
    if self.IsOpen then
        self.Overlay.Visible = true
        TweenService:Create(self.Sidebar, TweenInfo.new(MOBILE_SETTINGS.ANIMATION_DURATION, Enum.EasingStyle.Cubic), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    else
        TweenService:Create(self.Sidebar, TweenInfo.new(MOBILE_SETTINGS.ANIMATION_DURATION, Enum.EasingStyle.Cubic), {
            Position = UDim2.new(-1, 0, 0, 0)
        }):Play()
        
        delay(MOBILE_SETTINGS.ANIMATION_DURATION, function()
            self.Overlay.Visible = false
        end)
    end
end

-- Modern UI Components
function NebulaUI:AddButton(tabContent, options)
    local button = self:CreateModernButton(options)
    button.Parent = tabContent
    return button
end

function NebulaUI:AddToggle(tabContent, options)
    options = options or {}
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = options.Name or "Toggle"
    toggleContainer.Size = UDim2.new(1, 0, 0, MOBILE_SETTINGS.ELEMENT_HEIGHT)
    toggleContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Text or options.Name or "Toggle"
    label.TextColor3 = self.Theme.ON_SURFACE
    label.TextSize = 16
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "Switch"
    toggleSwitch.Size = UDim2.new(0, 52, 0, 28)
    toggleSwitch.Position = UDim2.new(1, -60, 0.5, -14)
    toggleSwitch.BackgroundColor3 = self.Theme.OUTLINE
    toggleSwitch.BorderSizePixel = 0
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch
    
    local toggleThumb = Instance.new("Frame")
    toggleThumb.Name = "Thumb"
    toggleThumb.Size = UDim2.new(0, 24, 0, 24)
    toggleThumb.Position = UDim2.new(0, 2, 0, 2)
    toggleThumb.BackgroundColor3 = self.Theme.SURFACE
    toggleThumb.BorderSizePixel = 0
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = toggleThumb
    
    toggleThumb.Parent = toggleSwitch
    toggleSwitch.Parent = toggleContainer
    
    local isToggled = options.Default or false
    
    local function updateToggle()
        TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and self.Theme.PRIMARY or self.Theme.OUTLINE
        }):Play()
        
        TweenService:Create(toggleThumb, TweenInfo.new(0.2), {
            Position = isToggled and UDim2.new(1, -26, 0, 2) or UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = isToggled and self.Theme.ON_PRIMARY or self.Theme.SURFACE
        }):Play()
        
        if options.Callback then
            pcall(options.Callback, isToggled)
        end
    end
    
    toggleSwitch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isToggled = not isToggled
            updateToggle()
        end
    end)
    
    updateToggle()
    toggleContainer.Parent = tabContent
    
    return toggleContainer
end

function NebulaUI:AddSlider(tabContent, options)
    options = options or {}
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = options.Name or "Slider"
    sliderContainer.Size = UDim2.new(1, 0, 0, 80)
    sliderContainer.BackgroundTransparency = 1
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 24)
    header.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Text or options.Name or "Slider"
    label.TextColor3 = self.Theme.ON_SURFACE
    label.TextSize = 16
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = header
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(options.Default or options.Min or 0)
    valueLabel.TextColor3 = self.Theme.ON_SURFACE_VARIANT
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = header
    
    header.Parent = sliderContainer
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 40)
    track.BackgroundColor3 = self.Theme.OUTLINE
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((options.Default or options.Min or 0) / (options.Max or 100), 0, 1, 0)
    fill.BackgroundColor3 = self.Theme.PRIMARY
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 24, 0, 24)
    thumb.BackgroundColor3 = self.Theme.SURFACE
    thumb.Text = ""
    thumb.AutoButtonColor = false
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local thumbShadow = Instance.new("ImageLabel")
    thumbShadow.Name = "Shadow"
    thumbShadow.Size = UDim2.new(1, 10, 1, 10)
    thumbShadow.Position = UDim2.new(0, -5, 0, -5)
    thumbShadow.BackgroundTransparency = 1
    thumbShadow.Image = "rbxassetid://5554236773"
    thumbShadow.ImageColor3 = self.Theme.SHADOW
    thumbShadow.ImageTransparency = 0.8
    thumbShadow.ScaleType = Enum.ScaleType.Slice
    thumbShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    thumbShadow.Parent = thumb
    
    fill.Parent = track
    thumb.Parent = track
    track.Parent = sliderContainer
    
    -- Slider functionality
    local min = options.Min or 0
    local max = options.Max or 100
    local currentValue = options.Default or min
    
    local function updateValue(value)
        currentValue = math.clamp(value, min, max)
        local percent = (currentValue - min) / (max - min)
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, -12, 0.5, -12)
        valueLabel.Text = tostring(currentValue) .. (options.Suffix or "")
        
        if options.Callback then
            pcall(options.Callback, currentValue)
        end
    end
    
    local isSliding = false
    
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
    
    updateValue(currentValue)
    sliderContainer.Parent = tabContent
    
    return sliderContainer
end

function NebulaUI:AddLabel(tabContent, options)
    options = options or {}
    
    local label = Instance.new("TextLabel")
    label.Name = options.Name or "Label"
    label.Size = UDim2.new(1, 0, 0, options.Height or 40)
    label.BackgroundTransparency = 1
    label.Text = options.Text or "Label"
    label.TextColor3 = options.Color or self.Theme.ON_SURFACE_VARIANT
    label.TextSize = options.TextSize or 14
    label.Font = options.Font or Enum.Font.SourceSans
    label.TextXAlignment = options.Alignment or Enum.TextXAlignment.Left
    label.TextWrapped = true
    
    label.Parent = tabContent
    return label
end

function NebulaUI:AddSection(tabContent, options)
    options = options or {}
    
    local section = Instance.new("Frame")
    section.Name = options.Name or "Section"
    section.Size = UDim2.new(1, 0, 0, 60)
    section.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "SectionLabel"
    label.Size = UDim2.new(1, 0, 0, 24)
    label.Position = UDim2.new(0, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = options.Text or options.Name or "Section"
    label.TextColor3 = self.Theme.ON_SURFACE
    label.TextSize = 18
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0, 50)
    divider.BackgroundColor3 = self.Theme.OUTLINE
    divider.BorderSizePixel = 0
    
    label.Parent = section
    divider.Parent = section
    section.Parent = tabContent
    
    return section
end

-- Public API Methods
function NebulaUI:ShowToast(options)
    self.ToastManager:ShowToast(options)
end

function NebulaUI:SetTheme(themeName)
    if MODERN_THEMES[themeName] then
        NebulaUI_Internal.CurrentTheme = themeName
        self.Theme = MODERN_THEMES[themeName]
        -- Theme update logic would go here
    end
end

function NebulaUI:Destroy()
    if self.GUI then
        self.GUI:Destroy()
    end
end

-- Make library available globally
getgenv().NebulaUI = NebulaUI

return NebulaUI
