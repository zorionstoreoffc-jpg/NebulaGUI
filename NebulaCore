-- Nebula GUI Script untuk Roblox
-- Enhanced version dengan fitur lengkap dan mobile support

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = nil
local isMobile = UserInputService.TouchEnabled

-- Enhanced Colors untuk tema Nebula
local NEBULA_COLORS = {
    BACKGROUND = Color3.fromRGB(15, 15, 30),
    FRAME = Color3.fromRGB(30, 30, 60),
    ACCENT = Color3.fromRGB(138, 43, 226), -- Purple nebula
    ACCENT2 = Color3.fromRGB(0, 191, 255),  -- Blue nebula
    ACCENT3 = Color3.fromRGB(147, 112, 219), -- Light purple
    TEXT = Color3.fromRGB(255, 255, 255),
    BUTTON = Color3.fromRGB(50, 50, 90),
    BUTTON_HOVER = Color3.fromRGB(70, 70, 120),
    SUCCESS = Color3.fromRGB(46, 204, 113),
    WARNING = Color3.fromRGB(241, 196, 15),
    ERROR = Color3.fromRGB(231, 76, 60)
}

-- Device optimization
local BUTTON_SIZE = isMobile and UDim2.new(0, 140, 0, 50) or UDim2.new(0, 120, 0, 40)
local FONT_SIZE = isMobile and 16 or 14
local ELEMENT_PADDING = isMobile and 10 or 5

-- Animation sequences
local function createPulseAnimation(frame)
    local pulse = RunService.Heartbeat:Connect(function()
        local time = tick()
        local alpha = (math.sin(time * 3) + 1) / 2
        frame.BackgroundColor3 = NEBULA_COLORS.ACCENT:Lerp(NEBULA_COLORS.ACCENT3, alpha)
    end)
    return pulse
end

-- Enhanced glow effect dengan multiple layers
function createEnhancedGlow(frame)
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
        glow.BackgroundColor3 = NEBULA_COLORS.ACCENT
        glow.BackgroundTransparency = 0.7 + (i * 0.1)
        glow.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = glow
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = NEBULA_COLORS.ACCENT2
        stroke.Thickness = 1
        stroke.Transparency = 0.5
        stroke.Parent = glow
        
        glow.Parent = glowContainer
    end
    
    glowContainer.Parent = frame
    return glowContainer
end

-- Notification system
local function showNotification(title, message, notificationType)
    if not gui then return end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 1, -100)
    notification.BackgroundColor3 = NEBULA_COLORS.FRAME
    notification.BorderSizePixel = 0
    notification.ZIndex = 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = notificationType == "SUCCESS" and NEBULA_COLORS.SUCCESS or 
                  notificationType == "WARNING" and NEBULA_COLORS.WARNING or 
                  notificationType == "ERROR" and NEBULA_COLORS.ERROR or
                  NEBULA_COLORS.ACCENT
    stroke.Thickness = 2
    stroke.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = stroke.Color
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.SciFi
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 35)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = NEBULA_COLORS.TEXT
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.SciFi
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = notification
    
    notification.Parent = gui
    
    -- Animate in
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 1, -180)
    })
    tweenIn:Play()
    
    -- Auto remove after 5 seconds
    delay(5, function()
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, -320, 1, -100)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Enhanced button dengan better hover effects
function createNebulaButton(text)
    local button = Instance.new("TextButton")
    button.Name = "NebulaButton"
    button.Size = BUTTON_SIZE
    button.BackgroundColor3 = NEBULA_COLORS.BUTTON
    button.Text = text
    button.TextColor3 = NEBULA_COLORS.TEXT
    button.TextSize = FONT_SIZE
    button.Font = Enum.Font.SciFi
    button.AutoButtonColor = false
    button.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = NEBULA_COLORS.ACCENT2
    stroke.Thickness = 2
    stroke.Parent = button
    
    -- Hover particle effect
    local particles = Instance.new("Frame")
    particles.Name = "Particles"
    particles.Size = UDim2.new(1, 0, 1, 0)
    particles.BackgroundTransparency = 1
    particles.Parent = button
    
    -- Enhanced hover effects
    button.MouseEnter:Connect(function()
        local tween1 = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = NEBULA_COLORS.BUTTON_HOVER,
            Size = BUTTON_SIZE + UDim2.new(0, 10, 0, 10)
        })
        
        local tween2 = TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = NEBULA_COLORS.ACCENT,
            Thickness = 3
        })
        
        tween1:Play()
        tween2:Play()
        
        -- Create ripple effect
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.BackgroundColor3 = NEBULA_COLORS.ACCENT2
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        
        local rippleCorner = Instance.new("UICorner")
        rippleCorner.CornerRadius = UDim.new(1, 0)
        rippleCorner.Parent = ripple
        
        ripple.Parent = particles
        
        local tweenRipple = TweenService:Create(ripple, TweenInfo.new(0.5), {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        tweenRipple:Play()
        tweenRipple.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
    
    button.MouseLeave:Connect(function()
        local tween1 = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = NEBULA_COLORS.BUTTON,
            Size = BUTTON_SIZE
        })
        
        local tween2 = TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = NEBULA_COLORS.ACCENT2,
            Thickness = 2
        })
        
        tween1:Play()
        tween2:Play()
    end)
    
    -- Enhanced click effects
    button.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = NEBULA_COLORS.ACCENT,
            Size = BUTTON_SIZE - UDim2.new(0, 5, 0, 5)
        })
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = NEBULA_COLORS.BUTTON_HOVER,
            Size = BUTTON_SIZE + UDim2.new(0, 10, 0, 10)
        })
        tween:Play()
    end)
    
    return button
end

-- Slider component
function createNebulaSlider(name, min, max, default, callback)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = name .. "Slider"
    sliderContainer.Size = UDim2.new(1, -20, 0, 60)
    sliderContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = NEBULA_COLORS.TEXT
    label.TextSize = FONT_SIZE
    label.Font = Enum.Font.SciFi
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = NEBULA_COLORS.BUTTON
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = NEBULA_COLORS.ACCENT
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new((default - min) / (max - min), -10, 0, -7)
    thumb.BackgroundColor3 = NEBULA_COLORS.ACCENT2
    thumb.Text = ""
    thumb.AutoButtonColor = false
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 10)
    thumbCorner.Parent = thumb
    
    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Color = NEBULA_COLORS.TEXT
    thumbStroke.Thickness = 2
    thumbStroke.Parent = thumb
    
    fill.Parent = track
    track.Parent = sliderContainer
    thumb.Parent = track
    
    -- Slider functionality
    local isSliding = false
    
    local function updateValue(value)
        local percent = math.clamp((value - min) / (max - min), 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, -10, 0, -7)
        label.Text = name .. ": " .. math.floor(value)
        callback(value)
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
            updateValue(value)
        end
    end)
    
    return sliderContainer
end

-- Toggle component
function createNebulaToggle(name, default, callback)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = name .. "Toggle"
    toggleContainer.Size = UDim2.new(1, -20, 0, 40)
    toggleContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = NEBULA_COLORS.TEXT
    label.TextSize = FONT_SIZE
    label.Font = Enum.Font.SciFi
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0, 5)
    toggleButton.BackgroundColor3 = default and NEBULA_COLORS.SUCCESS or NEBULA_COLORS.BUTTON
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.TextColor3 = NEBULA_COLORS.TEXT
    toggleButton.TextSize = FONT_SIZE
    toggleButton.Font = Enum.Font.SciFi
    toggleButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = NEBULA_COLORS.ACCENT2
    stroke.Thickness = 2
    stroke.Parent = toggleButton
    
    toggleButton.Parent = toggleContainer
    
    local isToggled = default
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.Text = isToggled and "ON" or "OFF"
        
        local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and NEBULA_COLORS.SUCCESS or NEBULA_COLORS.BUTTON
        })
        tween:Play()
        
        callback(isToggled)
    end)
    
    return toggleContainer
end

-- Fungsi utama untuk membuat GUI
function createNebulaGUI()
    if gui then
        gui:Destroy()
    end
    
    gui = Instance.new("ScreenGui")
    gui.Name = "NebulaGUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = isMobile and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 400, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
    mainFrame.BackgroundColor3 = NEBULA_COLORS.BACKGROUND
    mainFrame.BorderSizePixel = 0
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = NEBULA_COLORS.ACCENT
    mainStroke.Thickness = 3
    mainStroke.Parent = mainFrame
    
    createEnhancedGlow(mainFrame)
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = NEBULA_COLORS.FRAME
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "NEBULA HUB v2.0"
    titleLabel.TextColor3 = NEBULA_COLORS.TEXT
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.SciFi
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeButton = createNebulaButton("X")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = NEBULA_COLORS.ERROR
    
    closeButton.MouseButton1Click:Connect(function()
        gui.Enabled = false
        showNotification("Nebula Hub", "GUI Disabled - Press F9 to reopen", "WARNING")
    end)
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    
    createEnhancedTabSystem(contentFrame)
    
    titleLabel.Parent = titleBar
    closeButton.Parent = titleBar
    titleBar.Parent = mainFrame
    contentFrame.Parent = mainFrame
    mainFrame.Parent = gui
    
    makeDraggable(titleBar, mainFrame)
    
    showNotification("Nebula Hub", "Welcome to Nebula Hub! Loaded successfully.", "SUCCESS")
    
    return gui
end

-- Enhanced tab system dengan lebih banyak fitur
function createEnhancedTabSystem(parent)
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
    tabButtonsFrame.BackgroundTransparency = 1
    
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent"
    tabContentFrame.Size = UDim2.new(1, 0, 1, -50)
    tabContentFrame.Position = UDim2.new(0, 0, 0, 50)
    tabContentFrame.BackgroundTransparency = 1
    
    local tabs = {
        {name = "HOME", content = createEnhancedHomeTab()},
        {name = "PLAYER", content = createPlayerTab()},
        {name = "VISUALS", content = createVisualsTab()},
        {name = "SCRIPTS", content = createEnhancedScriptsTab()},
        {name = "SETTINGS", content = createEnhancedSettingsTab()}
    }
    
    local currentTab = nil
    
    for i, tab in ipairs(tabs) do
        local tabButton = createNebulaButton(tab.name)
        tabButton.Size = UDim2.new(1/#tabs, -10, 0, 35)
        tabButton.Position = UDim2.new((i-1) * (1/#tabs), 5, 0, 0)
        tabButton.Parent = tabButtonsFrame
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            tab.content.Visible = true
            currentTab = tab.content
            showNotification("Tab Changed", "Now viewing: " .. tab.name, "SUCCESS")
        end)
        
        tab.content.Parent = tabContentFrame
        tab.content.Visible = false
    end
    
    if #tabs > 0 then
        tabs[1].content.Visible = true
        currentTab = tabs[1].content
    end
    
    tabButtonsFrame.Parent = parent
    tabContentFrame.Parent = parent
end

function createEnhancedHomeTab()
    local frame = Instance.new("Frame")
    frame.Name = "HomeTab"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.Padding = UDim.new(0, ELEMENT_PADDING)
    
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, 0, 0, 60)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "NEBULA HUB"
    welcomeLabel.TextColor3 = NEBULA_COLORS.ACCENT2
    welcomeLabel.TextSize = 24
    welcomeLabel.Font = Enum.Font.SciFi
    welcomeLabel.Parent = scrollFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Advanced GUI • Mobile Optimized"
    subtitle.TextColor3 = NEBULA_COLORS.TEXT
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.SciFi
    subtitle.Parent = scrollFrame
    
    local quickActions = Instance.new("TextLabel")
    quickActions.Size = UDim2.new(1, 0, 0, 30)
    quickActions.BackgroundTransparency = 1
    quickActions.Text = "Quick Actions:"
    quickActions.TextColor3 = NEBULA_COLORS.ACCENT
    quickActions.TextSize = 16
    quickActions.Font = Enum.Font.SciFi
    quickActions.TextXAlignment = Enum.TextXAlignment.Left
    quickActions.Parent = scrollFrame
    
    local testButton = createNebulaButton("TEST NOTIFICATION")
    testButton.Parent = scrollFrame
    
    testButton.MouseButton1Click:Connect(function()
        showNotification("Test", "This is a test notification!", "SUCCESS")
    end)
    
    local statsButton = createNebulaButton("SHOW STATS")
    statsButton.Parent = scrollFrame
    
    statsButton.MouseButton1Click:Connect(function()
        local fps = math.floor(1/RunService.RenderStepped:Wait())
        showNotification("System Info", "FPS: " .. fps .. " | Mobile: " .. tostring(isMobile), "SUCCESS")
    end)
    
    scrollFrame.Parent = frame
    return frame
end

function createPlayerTab()
    local frame = Instance.new("Frame")
    frame.Name = "PlayerTab"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.Padding = UDim.new(0, ELEMENT_PADDING)
    
    local speedSlider = createNebulaSlider("WalkSpeed", 16, 100, 16, function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end)
    speedSlider.Parent = scrollFrame
    
    local jumpSlider = createNebulaSlider("JumpPower", 50, 200, 50, function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end)
    jumpSlider.Parent = scrollFrame
    
    local resetButton = createNebulaButton("RESET STATS")
    resetButton.Parent = scrollFrame
    
    resetButton.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            player.Character.Humanoid.JumpPower = 50
            showNotification("Player", "Stats reset to default", "SUCCESS")
        end
    end)
    
    scrollFrame.Parent = frame
    return frame
end

function createVisualsTab()
    local frame = Instance.new("Frame")
    frame.Name = "VisualsTab"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.Padding = UDim.new(0, ELEMENT_PADDING)
    
    local espToggle = createNebulaToggle("ESP", false, function(value)
        showNotification("Visuals", "ESP: " .. tostring(value), value and "SUCCESS" or "WARNING")
    end)
    espToggle.Parent = scrollFrame
    
    local tracersToggle = createNebulaToggle("Tracers", false, function(value)
        showNotification("Visuals", "Tracers: " .. tostring(value), value and "SUCCESS" or "WARNING")
    end)
    tracersToggle.Parent = scrollFrame
    
    local chamsToggle = createNebulaToggle("Chams", false, function(value)
        showNotification("Visuals", "Chams: " .. tostring(value), value and "SUCCESS" or "WARNING")
    end)
    chamsToggle.Parent = scrollFrame
    
    scrollFrame.Parent = frame
    return frame
end

function createEnhancedScriptsTab()
    local frame = Instance.new("Frame")
    frame.Name = "ScriptsTab"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.Padding = UDim.new(0, ELEMENT_PADDING)
    
    local scripts = {
        {"INFINITE JUMP", "Adds infinite jump capability"},
        {"SPEED HACK", "Increases movement speed"},
        {"NO CLIP", "Walk through walls"},
        {"FLY SCRIPT", "Fly around the map"},
        {"ANIMATION HACK", "Custom animations"},
        {"AIM ASSIST", "Improved aiming"},
        {"X-RAY VISION", "See through walls"},
        {"AUTO FARM", "Automated farming"}
    }
    
    for i, scriptData in ipairs(scripts) do
        local scriptButton = createNebulaButton(scriptData[1])
        scriptButton.Parent = scrollFrame
        
        scriptButton.MouseButton1Click:Connect(function()
            showNotification("Script", "Executing: " .. scriptData[1], "SUCCESS")
            print("Script executed: " .. scriptData[1])
        end)
    end
    
    scrollFrame.Parent = frame
    return frame
end

function createEnhancedSettingsTab()
    local frame = Instance.new("Frame")
    frame.Name = "SettingsTab"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.Padding = UDim.new(0, ELEMENT_PADDING)
    
    local soundToggle = createNebulaToggle("Sound Effects", true, function(value)
        showNotification("Settings", "Sound Effects: " .. tostring(value), "SUCCESS")
    end)
    soundToggle.Parent = scrollFrame
    
    local notificationsToggle = createNebulaToggle("Notifications", true, function(value)
        showNotification("Settings", "Notifications: " .. tostring(value), "SUCCESS")
    end)
    notificationsToggle.Parent = scrollFrame
    
    local uiScaleSlider = createNebulaSlider("UI Scale", 80, 120, 100, function(value)
        local scale = value / 100
        gui.MainFrame.Size = UDim2.new(0, 400 * scale, 0, 550 * scale)
    end)
    uiScaleSlider.Parent = scrollFrame
    
    local themeButton = createNebulaButton("CHANGE THEME")
    themeButton.Parent = scrollFrame
    
    themeButton.MouseButton1Click:Connect(function()
        showNotification("Settings", "Theme change coming soon!", "WARNING")
    end)
    
    scrollFrame.Parent = frame
    return frame
end

-- Drag functionality (tetap sama)
function makeDraggable(dragHandle, mainFrame)
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

-- Keybind untuk toggle GUI (F9)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        if gui then
            local wasEnabled = gui.Enabled
            gui.Enabled = not gui.Enabled
            if gui.Enabled and not wasEnabled then
                showNotification("Nebula Hub", "GUI Enabled", "SUCCESS")
            end
        else
            createNebulaGUI()
        end
    end
end)

-- Mobile support: tambah button di corner jika mobile
if isMobile then
    spawn(function()
        wait(2)
        local mobileButton = createNebulaButton("☰")
        mobileButton.Size = UDim2.new(0, 50, 0, 50)
        mobileButton.Position = UDim2.new(0, 20, 0, 20)
        mobileButton.ZIndex = 100
        mobileButton.Parent = player.PlayerGui
        
        mobileButton.MouseButton1Click:Connect(function()
            if gui then
                gui.Enabled = not gui.Enabled
            else
                createNebulaGUI()
            end
        end)
    end)
end

-- Inisialisasi GUI
createNebulaGUI()

print("Nebula GUI loaded! Press F9 to toggle" .. (isMobile and " or use mobile button" or ""))
