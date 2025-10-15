-- Nebula UI Library v4.0
-- Modern Mobile-First GUI Framework for Roblox
-- Enhanced with Advanced Animations, Debug System & Performance Optimizations
-- STABILITY-ENHANCED VERSION

local NebulaUI = {}
NebulaUI.__index = NebulaUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

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

-- Advanced Animation System (Rayfield Inspired)
local ENHANCED_ANIMATIONS = {
    EASING_STYLES = {
        SMOOTH = Enum.EasingStyle.Quint,
        BOUNCY = Enum.EasingStyle.Back,
        SPRINGY = Enum.EasingStyle.Elastic,
        SHARP = Enum.EasingStyle.Cubic
    },
    
    PRESETS = {
        SIDEBAR_OPEN = {
            Time = 0.4,
            Style = Enum.EasingStyle.Quint,
            Direction = Enum.EasingDirection.Out
        },
        BUTTON_HOVER = {
            Time = 0.2,
            Style = Enum.EasingStyle.Cubic,
            Direction = Enum.EasingDirection.Out
        },
        TOAST_SLIDE = {
            Time = 0.5,
            Style = Enum.EasingStyle.Back,
            Direction = Enum.EasingDirection.Out
        },
        RIPPLE_EFFECT = {
            Time = 0.6,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        }
    }
}

-- Internal State dengan weak tables untuk memory management
local NebulaUI_Internal = {
    Windows = {},
    Toasts = {},
    CurrentTheme = "Modern",
    IsMobile = UserInputService.TouchEnabled,
    Version = "4.0.0",
    EventSystem = {},
    ComponentRegistry = {},
    AssetCache = {},
    ConnectionPool = setmetatable({}, {__mode = "v"}),
    PerformanceMetrics = {},
    RateLimiters = {},
    StateStores = {},
    Localization = {},
    GestureRecognizers = {},
    DebugOverlay = nil,
    CleanupRegistry = setmetatable({}, {__mode = "v"}),
    ActiveTweens = setmetatable({}, {__mode = "v"})
}

-- Enhanced Debug System
local DebugSystem = {
    Enabled = true,
    LogLevel = "INFO", -- DEBUG, INFO, WARN, ERROR
    PerformanceMetrics = {}
}

-- Centralized Error Handling System
local ErrorHandler = {
    CriticalErrors = {},
    NonCriticalErrors = {}
}

function ErrorHandler:RegisterError(errorType, message, context)
    local errorId = HttpService:GenerateGUID(false)
    local errorInfo = {
        Id = errorId,
        Type = errorType,
        Message = message,
        Context = context,
        Timestamp = tick(),
        StackTrace = debug.traceback()
    }
    
    if errorType == "CRITICAL" then
        self.CriticalErrors[errorId] = errorInfo
    else
        self.NonCriticalErrors[errorId] = errorInfo
    end
    
    return errorId
end

function ErrorHandler:GetErrorReport()
    return {
        CriticalErrors = self.CriticalErrors,
        NonCriticalErrors = self.NonCriticalErrors,
        TotalErrors = table.count(self.CriticalErrors) + table.count(self.NonCriticalErrors)
    }
end

-- Input Validation System dengan sanitization
local ValidationSystem = {
    Types = {
        STRING = "string",
        NUMBER = "number",
        TABLE = "table",
        FUNCTION = "function",
        BOOLEAN = "boolean",
        USERDATA = "userdata"
    }
}

function ValidationSystem:Validate(input, expectedType, options)
    options = options or {}
    
    if type(input) ~= expectedType then
        return false, string.format("Expected %s, got %s", expectedType, type(input))
    end
    
    if expectedType == self.Types.STRING and options.notEmpty then
        if #input == 0 then
            return false, "String cannot be empty"
        end
    end
    
    if expectedType == self.Types.NUMBER then
        if options.min and input < options.min then
            return false, string.format("Number must be >= %d", options.min)
        end
        if options.max and input > options.max then
            return false, string.format("Number must be <= %d", options.max)
        end
    end
    
    if expectedType == self.Types.TABLE and options.keys then
        for _, key in ipairs(options.keys) do
            if input[key] == nil then
                return false, string.format("Missing required key: %s", key)
            end
        end
    end
    
    return true, "Valid"
end

function ValidationSystem:SanitizeInput(input, inputType, options)
    options = options or {}
    
    if inputType == self.Types.STRING then
        -- Sanitize string inputs
        input = tostring(input)
        -- Remove potentially dangerous characters
        input = string.gsub(input, "[<>\"']", "")
        
        if options.maxLength and #input > options.maxLength then
            input = string.sub(input, 1, options.maxLength)
        end
    elseif inputType == self.Types.NUMBER then
        -- Sanitize number inputs
        input = tonumber(input) or 0
        if options.min then input = math.max(input, options.min) end
        if options.max then input = math.min(input, options.max) end
    end
    
    return input
end

-- Enhanced Event System dengan thread safety
local EventSystem = {}
EventSystem.__index = EventSystem

function EventSystem.new()
    local self = setmetatable({}, EventSystem)
    self._listeners = {}
    self._events = {}
    self._firing = false
    self._pendingOperations = {}
    return self
end

function EventSystem:Fire(eventName, ...)
    if not self._listeners[eventName] then return end
    
    -- Gunakan shallow copy untuk iteration
    local listeners = {}
    for id, callback in pairs(self._listeners[eventName]) do
        listeners[id] = callback
    end
    
    self._firing = true
    
    for callbackId, callback in pairs(listeners) do
        if self._listeners[eventName] and self._listeners[eventName][callbackId] then
            local success, result = pcall(callback, ...)
            if not success then
                NebulaUI:HandleError("NON_CRITICAL", string.format("Event callback error in %s: %s", eventName, result), "EventSystem:Fire")
            end
        end
    end
    
    self._firing = false
    self:ProcessPendingOperations()
end

function EventSystem:ProcessPendingOperations()
    if #self._pendingOperations > 0 then
        for _, operation in ipairs(self._pendingOperations) do
            if operation.type == "connect" then
                self:RawConnect(operation.eventName, operation.callback)
            elseif operation.type == "disconnect" then
                if self._listeners[operation.eventName] then
                    self._listeners[operation.eventName][operation.callbackId] = nil
                end
            end
        end
        self._pendingOperations = {}
    end
end

function EventSystem:RawConnect(eventName, callback)
    if not self._listeners[eventName] then
        self._listeners[eventName] = {}
    end
    
    local callbackId = HttpService:GenerateGUID(false)
    self._listeners[eventName][callbackId] = callback
    
    return callbackId
end

function EventSystem:Connect(eventName, callback)
    local valid, errorMsg = ValidationSystem:Validate(eventName, ValidationSystem.Types.STRING)
    if not valid then
        error("Event name must be a string: " .. errorMsg)
    end
    
    local valid, errorMsg = ValidationSystem:Validate(callback, ValidationSystem.Types.FUNCTION)
    if not valid then
        error("Callback must be a function: " .. errorMsg)
    end
    
    if self._firing then
        local callbackId = HttpService:GenerateGUID(false)
        table.insert(self._pendingOperations, {
            type = "connect",
            eventName = eventName,
            callback = callback,
            callbackId = callbackId
        })
        return {
            Disconnect = function()
                table.insert(self._pendingOperations, {
                    type = "disconnect",
                    eventName = eventName,
                    callbackId = callbackId
                })
            end
        }
    else
        local callbackId = self:RawConnect(eventName, callback)
        
        return {
            Disconnect = function()
                if not self._firing then
                    if self._listeners[eventName] then
                        self._listeners[eventName][callbackId] = nil
                    end
                else
                    table.insert(self._pendingOperations, {
                        type = "disconnect",
                        eventName = eventName,
                        callbackId = callbackId
                    })
                end
            end
        }
    end
end

-- Performance monitoring dengan metrics collection
function NebulaUI:MeasurePerformance(funcName, func)
    local startTime = tick()
    local success, result = pcall(func)
    local endTime = tick()
    local executionTime = endTime - startTime
    
    -- Collect performance metrics
    if not DebugSystem.PerformanceMetrics[funcName] then
        DebugSystem.PerformanceMetrics[funcName] = {
            callCount = 0,
            totalTime = 0,
            averageTime = 0,
            maxTime = 0,
            minTime = math.huge
        }
    end
    
    local metrics = DebugSystem.PerformanceMetrics[funcName]
    metrics.callCount = metrics.callCount + 1
    metrics.totalTime = metrics.totalTime + executionTime
    metrics.averageTime = metrics.totalTime / metrics.callCount
    metrics.maxTime = math.max(metrics.maxTime, executionTime)
    metrics.minTime = math.min(metrics.minTime, executionTime)
    
    self:DebugLog(string.format("%s executed in %.3f seconds", funcName, executionTime), "DEBUG")
    
    if not success then
        self:HandleError("NON_CRITICAL", string.format("Error in %s: %s", funcName, result), "MeasurePerformance")
    end
    
    return result
end

-- Enhanced debug logging dengan log levels
function NebulaUI:DebugLog(message, level)
    if not DebugSystem.Enabled then return end
    
    level = level or "INFO"
    local levelWeights = {DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4}
    local currentWeight = levelWeights[DebugSystem.LogLevel] or 2
    local messageWeight = levelWeights[level] or 2
    
    if messageWeight < currentWeight then return end
    
    local timestamp = DateTime.now():FormatLocalTime("LTS", "id-ID")
    local logMessage = string.format("[%s] [%s] %s", timestamp, level, message)
    
    print(logMessage)
    
    -- Untuk error yang critical, tampilkan toast juga
    if level == "ERROR" then
        self:ShowToast({
            Title = "System Error",
            Content = message,
            Type = "ERROR", 
            Duration = 5
        })
    end
end

-- Centralized Error Handling
function NebulaUI:HandleError(errorType, message, context)
    local errorId = ErrorHandler:RegisterError(errorType, message, context)
    
    self:DebugLog(string.format("%s ERROR: %s - %s", errorType, message, context), "ERROR")
    
    if errorType == "CRITICAL" then
        self:EmergencyCleanup()
    end
    
    return errorId
end

function NebulaUI:EmergencyCleanup()
    self:DebugLog("Performing emergency cleanup...", "WARN")
    
    -- Cancel all active tweens
    if NebulaUI_Internal.ActiveTweens then
        for tweenId, tweenData in pairs(NebulaUI_Internal.ActiveTweens) do
            if tweenData and tweenData.Cancel then
                pcall(tweenData.Cancel)
            end
        end
        NebulaUI_Internal.ActiveTweens = {}
    end
    
    -- Clear connection pool
    if NebulaUI_Internal.ConnectionPool then
        for _, connection in ipairs(NebulaUI_Internal.ConnectionPool) do
            pcall(function() connection:Disconnect() end)
        end
        NebulaUI_Internal.ConnectionPool = {}
    end
    
    -- Force garbage collection
    task.defer(function()
        wait(1)
        collectgarbage("collect")
    end)
end

-- Virtualized Scrolling System dengan Object Pooling
local VirtualList = {}
VirtualList.__index = VirtualList

function VirtualList.new(parent, options)
    local self = setmetatable({}, VirtualList)
    
    self.Parent = parent
    self.ItemHeight = options.ItemHeight or 40
    self.TotalItems = options.TotalItems or 0
    self.VisibleRange = 10
    self.RenderItem = options.RenderItem
    self.UpdateItem = options.UpdateItem
    
    self:Initialize()
    return self
end

function VirtualList:Initialize()
    self.ScrollingFrame = Instance.new("ScrollingFrame")
    self.ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ScrollingFrame.BackgroundTransparency = 1
    self.ScrollingFrame.ScrollBarThickness = 4
    self.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ScrollingFrame.Parent = self.Parent
    
    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Parent = self.ScrollingFrame
    
    self.RenderedItems = {}
    self.Data = {}
    self.ObjectPool = {}
    self.ActiveItems = {}
    
    -- Pre-create items untuk pool
    self:InitializeObjectPool(10)
    
    self.ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        self:UpdateVisibleItems()
    end)
end

function VirtualList:InitializeObjectPool(count)
    for i = 1, count do
        local item = self:CreatePooledItem()
        table.insert(self.ObjectPool, item)
    end
end

function VirtualList:CreatePooledItem()
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, self.ItemHeight)
    item.BackgroundTransparency = 1
    item.Visible = false
    return item
end

function VirtualList:GetFromPool()
    if #self.ObjectPool > 0 then
        local item = table.remove(self.ObjectPool, 1)
        item.Visible = true
        return item
    else
        return self:CreatePooledItem()
    end
end

function VirtualList:ReturnToPool(item)
    item.Visible = false
    table.insert(self.ObjectPool, item)
end

function VirtualList:SetData(data)
    self.Data = data
    self.TotalItems = #data
    
    -- Return all active items to pool
    for i, item in pairs(self.ActiveItems) do
        self:ReturnToPool(item)
        self.ActiveItems[i] = nil
    end
    
    self:UpdateVisibleItems()
end

function VirtualList:UpdateVisibleItems()
    local scrollPosition = self.ScrollingFrame.CanvasPosition.Y
    local startIndex = math.floor(scrollPosition / self.ItemHeight) + 1
    local endIndex = math.min(startIndex + self.VisibleRange, self.TotalItems)
    
    -- Reuse or create items
    for i = startIndex, endIndex do
        if not self.ActiveItems[i] then
            local item = self:GetFromPool()
            if self.RenderItem then
                self:RenderItem(item, i, self.Data[i])
            end
            item.Position = UDim2.new(0, 0, 0, (i-1) * self.ItemHeight)
            item.Parent = self.ScrollingFrame
            self.ActiveItems[i] = item
        elseif self.UpdateItem then
            self:UpdateItem(self.ActiveItems[i], i, self.Data[i])
        end
    end
    
    -- Clean up items outside visible range
    for i, item in pairs(self.ActiveItems) do
        if i < startIndex or i > endIndex then
            self:ReturnToPool(item)
            self.ActiveItems[i] = nil
        end
    end
end

-- Robust Tween System dengan cancellation support
function NebulaUI:CreateRobustTween(object, tweenInfo, goals, callback)
    if not object or object.Parent == nil then
        self:DebugLog("Cannot create tween for destroyed object", "WARN")
        return nil
    end
    
    local tweenId = HttpService:GenerateGUID(false)
    
    local success, tween = pcall(function()
        return TweenService:Create(object, tweenInfo, goals)
    end)
    
    if not success then
        self:HandleError("NON_CRITICAL", "Failed to create tween for object: " .. tostring(object:GetFullName()), "CreateRobustTween")
        return nil
    end
    
    local tweenData = {
        id = tweenId,
        object = object,
        tweenInfo = tweenInfo,
        goals = goals,
        callback = callback,
        startTime = tick(),
        completed = false
    }
    
    -- Store tween reference
    NebulaUI_Internal.ActiveTweens[tweenId] = tweenData
    
    local function cleanup()
        NebulaUI_Internal.ActiveTweens[tweenId] = nil
    end
    
    local connection
    connection = tween.Completed:Connect(function()
        tweenData.completed = true
        if callback then
            pcall(callback)
        end
        cleanup()
        if connection then
            connection:Disconnect()
        end
    end)
    
    local successPlay, playResult = pcall(function()
        tween:Play()
    end)
    
    if not successPlay then
        self:HandleError("NON_CRITICAL", "Tween play failed: " .. playResult, "CreateRobustTween")
        cleanup()
        return nil
    end
    
    local tweenController = {
        Cancel = function()
            if not tweenData.completed then
                pcall(function() 
                    tween:Cancel() 
                    if connection then
                        connection:Disconnect()
                    end
                end)
                cleanup()
            end
        end,
        Pause = function()
            if not tweenData.completed then
                pcall(function() tween:Pause() end)
            end
        end,
        Play = function()
            if not tweenData.completed then
                pcall(function() tween:Play() end)
            end
        end,
        GetProgress = function()
            if tweenData.completed then
                return 1
            else
                local elapsed = tick() - tweenData.startTime
                return math.min(elapsed / tweenInfo.Time, 1)
            end
        end
    }
    
    tweenData.Controller = tweenController
    
    return tweenController
end

-- Spring Animation System
function NebulaUI:CreateSpringAnimation(target, property, targetValue, options)
    options = options or {}
    local spring = options.spring or 30
    local damping = options.damping or 0.7
    local precision = options.precision or 0.01
    
    local connection
    local current = target[property]
    local velocity = 0
    local active = true
    
    local function update(dt)
        if not active or not target or target.Parent == nil then
            if connection then
                connection:Disconnect()
            end
            return
        end
        
        local force = spring * (targetValue - current)
        velocity = velocity + force * dt
        velocity = velocity * (1 - damping * dt)
        current = current + velocity * dt
        
        if math.abs(velocity) < precision and math.abs(targetValue - current) < precision then
            current = targetValue
            if connection then
                connection:Disconnect()
            end
        end
        
        pcall(function()
            target[property] = current
        end)
    end
    
    connection = RunService.Heartbeat:Connect(update)
    
    return {
        Stop = function()
            active = false
            if connection then
                connection:Disconnect()
            end
        end,
        SetTarget = function(newTarget)
            targetValue = newTarget
        end,
        Destroy = function()
            active = false
            if connection then
                connection:Disconnect()
            end
        end
    }
end

-- Sequence animations untuk flow yang lebih smooth
function NebulaUI:CreateAnimationSequence(animations)
    local function executeNext(index)
        if index > #animations then return end
        
        local anim = animations[index]
        local tween = self:CreateRobustTween(anim.object, anim.tweenInfo, anim.goals, function()
            executeNext(index + 1)
        end)
    end
    
    executeNext(1)
end

-- Debounced Event System
function NebulaUI:CreateDebouncedCallback(callback, delay)
    delay = delay or 0.1
    local lastCall = 0
    local pending = false
    
    return function(...)
        local now = tick()
        if now - lastCall >= delay and not pending then
            lastCall = now
            pending = true
            local success, result = pcall(callback, ...)
            pending = false
            if not success then
                self:HandleError("NON_CRITICAL", "Debounced callback error: " .. result, "CreateDebouncedCallback")
            end
        end
    end
end

-- Memory Leak Prevention dengan Safe Connections menggunakan weak tables
function NebulaUI:CreateSafeConnection(signal, callback)
    local connection = signal:Connect(function(...)
        if not self._destroyed then
            local success, result = pcall(callback, ...)
            if not success then
                self:HandleError("NON_CRITICAL", "Connection callback error: " .. result, "CreateSafeConnection")
            end
        end
    end)
    
    -- Gunakan weak table untuk mencegah memory leak
    table.insert(NebulaUI_Internal.ConnectionPool, connection)
    return connection
end

-- Asset Caching System dengan size limit
function NebulaUI:InitializeAssetCache()
    NebulaUI_Internal.AssetCache = setmetatable({}, {
        __index = function(t, key)
            return rawget(t, key) or "rbxassetid://" .. key
        end
    })
    
    NebulaUI_Internal.CacheMetadata = {
        lastAccess = {},
        size = 0,
        maxSize = 100 -- Maximum 100 cached assets
    }
end

function NebulaUI:GetCachedAsset(assetId)
    if not NebulaUI_Internal.CacheMetadata then
        self:InitializeAssetCache()
    end
    
    NebulaUI_Internal.CacheMetadata.lastAccess[assetId] = tick()
    
    -- Cleanup cache jika terlalu besar
    self:CleanupAssetCache()
    
    return NebulaUI_Internal.AssetCache[assetId]
end

function NebulaUI:CleanupAssetCache()
    local metadata = NebulaUI_Internal.CacheMetadata
    if metadata.size <= metadata.maxSize then return end
    
    -- Hapus assets yang paling jarang diakses
    local assetsToRemove = {}
    for assetId, lastAccess in pairs(metadata.lastAccess) do
        table.insert(assetsToRemove, {assetId = assetId, lastAccess = lastAccess})
    end
    
    table.sort(assetsToRemove, function(a, b) 
        return a.lastAccess < b.lastAccess 
    end)
    
    local removeCount = metadata.size - metadata.maxSize
    for i = 1, math.min(removeCount, #assetsToRemove) do
        local assetId = assetsToRemove[i].assetId
        NebulaUI_Internal.AssetCache[assetId] = nil
        metadata.lastAccess[assetId] = nil
        metadata.size = metadata.size - 1
    end
end

-- Render Batching System
function NebulaUI:BatchUpdates(callback)
    RunService.Heartbeat:Wait() -- Wait for next frame
    local success, result = pcall(callback)
    if not success then
        self:HandleError("NON_CRITICAL", "Batch update error: " .. result, "BatchUpdates")
    end
end

-- Haptic Feedback System (Simulated)
function NebulaUI:ProvideHapticFeedback(intensity)
    if not UserInputService.TouchEnabled then return end
    
    intensity = intensity or 0.5
    self:DebugLog(string.format("Haptic feedback: intensity %.1f", intensity), "DEBUG")
    
    -- Simulate haptic with visual feedback
    if self.GUI and self.GUI:FindFirstChild("HapticIndicator") then
        local indicator = self.GUI.HapticIndicator
        indicator.BackgroundTransparency = 0.8
        self:CreateRobustTween(indicator, TweenInfo.new(0.1), {
            BackgroundTransparency = 1
        })
    end
end

-- Modern Toast Notification System dengan Mutex Lock
local ToastManager = {}
ToastManager.__index = ToastManager

function ToastManager.new(parentGUI)
    local self = setmetatable({}, ToastManager)
    self.Parent = parentGUI
    self.ActiveToasts = {}
    self.ToastQueue = {}
    self.MaxToasts = 3
    self._processing = false
    self._mutex = false
    return self
end

function ToastManager:AcquireMutex()
    local startTime = tick()
    while self._mutex and tick() - startTime < 5 do -- 5 second timeout
        wait(0.01)
    end
    if self._mutex then
        return false
    end
    self._mutex = true
    return true
end

function ToastManager:ReleaseMutex()
    self._mutex = false
end

function ToastManager:ShowToast(options)
    assert(type(options) == "table", "Toast options must be a table")
    assert(options.Title and type(options.Title) == "string", "Toast title is required")
    
    -- Thread safety dengan mutex
    if not self:AcquireMutex() then
        NebulaUI:HandleError("NON_CRITICAL", "Could not acquire toast mutex", "ToastManager:ShowToast")
        return
    end
    
    local success, result = pcall(function()
        table.insert(self.ToastQueue, options)
        self:ProcessQueue()
    end)
    
    self:ReleaseMutex()
    
    if not success then
        NebulaUI:HandleError("NON_CRITICAL", "Toast show error: " .. result, "ToastManager:ShowToast")
    end
end

function ToastManager:ProcessQueue()
    if #self.ActiveToasts >= self.MaxToasts or #self.ToastQueue == 0 then return end
    
    local toastOptions = table.remove(self.ToastQueue, 1)
    self:CreateToast(toastOptions)
end

function ToastManager:CreateToast(options)
    local theme = MODERN_THEMES[NebulaUI_Internal.CurrentTheme]
    
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(0.8, 0, 0, 72)
    toast.Position = UDim2.new(0.1, 0, 0.7, -80)
    toast.BackgroundColor3 = theme.SURFACE
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
    shadow.Image = NebulaUI:GetCachedAsset("5554236773")
    shadow.ImageColor3 = theme.SHADOW
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
    title.Text = NebulaUI:SafeText(options.Title or "Notification")
    title.TextColor3 = theme.ON_SURFACE
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
    message.Text = NebulaUI:SafeText(options.Content or "")
    message.TextColor3 = theme.ON_SURFACE_VARIANT
    message.TextSize = 14
    message.Font = Enum.Font.SourceSans
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.ZIndex = toast.ZIndex + 1
    message.Parent = toast
    
    -- Close button for manual dismissal
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 16)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = NebulaUI:GetCachedAsset("6031094678")
    closeButton.ImageColor3 = theme.ON_SURFACE_VARIANT
    closeButton.ZIndex = toast.ZIndex + 1
    closeButton.Parent = toast
    
    toast.Parent = self.Parent
    
    -- Animate In dengan advanced easing
    toast.Position = UDim2.new(0.1, 0, 0.7, 0)
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local tweenIn = NebulaUI:CreateRobustTween(toast, tweenInfo, {
        Position = UDim2.new(0.1, 0, 0.7, -80)
    })
    
    table.insert(self.ActiveToasts, toast)
    
    -- Setup close button
    closeButton.MouseButton1Click:Connect(function()
        self:DismissToast(toast)
    end)
    
    -- Auto dismiss dengan task.delay
    local duration = options.Duration or 4
    if duration > 0 then
        task.delay(duration, function()
            if toast and toast.Parent then
                self:DismissToast(toast)
            end
        end)
    end
    
    return toast
end

function ToastManager:DismissToast(toast)
    if not toast or not toast.Parent then return end
    
    local tweenOut = NebulaUI:CreateRobustTween(toast, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.1, 0, 0.7, -60)
    })
    
    for _, child in ipairs(toast:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("ImageLabel") or child:IsA("ImageButton") then
            NebulaUI:CreateRobustTween(child, TweenInfo.new(0.3), {
                TextTransparency = 1,
                ImageTransparency = 1
            })
        end
    end
    
    if tweenOut then
        tweenOut.Completed:Wait()
    end
    
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
        SUCCESS = NebulaUI:GetCachedAsset("6026568263"),
        WARNING = NebulaUI:GetCachedAsset("6026568243"),
        ERROR = NebulaUI:GetCachedAsset("6026568278"),
        INFO = NebulaUI:GetCachedAsset("6026568208")
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

-- Context Menu System
local ContextMenu = {}
ContextMenu.__index = ContextMenu

function ContextMenu.new(options)
    local self = setmetatable({}, ContextMenu)
    self.Options = options or {}
    self.MenuItems = {}
    self.IsOpen = false
    return self
end

function ContextMenu:AddItem(text, callback, icon)
    table.insert(self.MenuItems, {
        Text = text,
        Callback = callback,
        Icon = icon
    })
end

function ContextMenu:Show(position, parent)
    if self.IsOpen then return end
    
    self.IsOpen = true
    local theme = MODERN_THEMES[NebulaUI_Internal.CurrentTheme]
    
    self.MenuFrame = Instance.new("Frame")
    self.MenuFrame.Size = UDim2.new(0, 200, 0, #self.MenuItems * 40)
    self.MenuFrame.Position = UDim2.new(0, position.X, 0, position.Y)
    self.MenuFrame.BackgroundColor3 = theme.SURFACE
    self.MenuFrame.BorderSizePixel = 0
    self.MenuFrame.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MenuFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = NebulaUI:GetCachedAsset("5554236773")
    shadow.ImageColor3 = theme.SHADOW
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = self.MenuFrame.ZIndex - 1
    shadow.Parent = self.MenuFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = self.MenuFrame
    
    for i, item in ipairs(self.MenuItems) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundTransparency = 1
        button.Text = "  " .. item.Text
        button.TextColor3 = theme.ON_SURFACE
        button.TextSize = 14
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.ZIndex = 1001
        
        button.MouseEnter:Connect(function()
            button.BackgroundTransparency = 0.9
            button.BackgroundColor3 = theme.PRIMARY
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundTransparency = 1
        end)
        
        button.MouseButton1Click:Connect(function()
            if item.Callback then
                pcall(item.Callback)
            end
            self:Hide()
        end)
        
        button.Parent = self.MenuFrame
    end
    
    self.MenuFrame.Parent = parent
    
    -- Auto-close when clicking outside
    self.CloseConnection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local absolutePos = self.MenuFrame.AbsolutePosition
            local absoluteSize = self.MenuFrame.AbsoluteSize
            
            if not (mousePos.X >= absolutePos.X and mousePos.X <= absolutePos.X + absoluteSize.X and
                   mousePos.Y >= absolutePos.Y and mousePos.Y <= absolutePos.Y + absoluteSize.Y) then
                self:Hide()
            end
        end
    end)
end

function ContextMenu:Hide()
    if not self.IsOpen then return end
    
    self.IsOpen = false
    if self.CloseConnection then
        self.CloseConnection:Disconnect()
    end
    if self.MenuFrame then
        self.MenuFrame:Destroy()
    end
end

-- Tooltip System
local TooltipManager = {}
TooltipManager.__index = TooltipManager

function TooltipManager.new(parent)
    local self = setmetatable({}, TooltipManager)
    self.Parent = parent
    self.ActiveTooltip = nil
    return self
end

function TooltipManager:ShowTooltip(element, content, position)
    if self.ActiveTooltip then
        self.ActiveTooltip:Destroy()
    end
    
    local theme = MODERN_THEMES[NebulaUI_Internal.CurrentTheme]
    
    self.ActiveTooltip = Instance.new("Frame")
    self.ActiveTooltip.Size = UDim2.new(0, 200, 0, 60)
    self.ActiveTooltip.Position = position or UDim2.new(0, element.AbsolutePosition.X, 0, element.AbsolutePosition.Y - 70)
    self.ActiveTooltip.BackgroundColor3 = theme.SURFACE
    self.ActiveTooltip.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.ActiveTooltip
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = NebulaUI:GetCachedAsset("5554236773")
    shadow.ImageColor3 = theme.SHADOW
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = self.ActiveTooltip.ZIndex - 1
    shadow.Parent = self.ActiveTooltip
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = NebulaUI:SafeText(content)
    label.TextColor3 = theme.ON_SURFACE
    label.TextSize = 12
    label.TextWrapped = true
    label.ZIndex = 1001
    label.Parent = self.ActiveTooltip
    
    self.ActiveTooltip.Parent = self.Parent
    
    -- Auto-hide after delay
    task.delay(4, function()
        if self.ActiveTooltip then
            self.ActiveTooltip:Destroy()
            self.ActiveTooltip = nil
        end
    end)
end

function TooltipManager:HideTooltip()
    if self.ActiveTooltip then
        self.ActiveTooltip:Destroy()
        self.ActiveTooltip = nil
    end
end

-- Reactive State Management System
function NebulaUI:CreateReactiveStore(initialState)
    local store = {
        state = initialState or {},
        subscribers = {},
        _isUpdating = false,
        _updateQueue = {},
        history = {},
        maxHistory = 50
    }
    
    function store:setState(updater, action)
        if self._isUpdating then
            table.insert(self._updateQueue, {updater, action})
            return
        end
        
        self._isUpdating = true
        local oldState = self.state
        local newState = typeof(updater) == "function" and updater(oldState) or updater
        
        -- Deep comparison untuk prevent unnecessary updates
        if not self:deepEqual(oldState, newState) then
            self.state = newState
            
            -- Add to history
            table.insert(self.history, {
                state = oldState,
                action = action,
                timestamp = tick()
            })
            
            -- Trim history
            if #self.history > self.maxHistory then
                table.remove(self.history, 1)
            end
            
            self:notifySubscribers(oldState, newState, action)
        end
        
        self._isUpdating = false
        self:processQueue()
    end
    
    function store:processQueue()
        if #self._updateQueue > 0 and not self._isUpdating then
            local nextUpdate = table.remove(self._updateQueue, 1)
            self:setState(unpack(nextUpdate))
        end
    end
    
    function store:deepEqual(a, b)
        if a == b then return true end
        if typeof(a) ~= typeof(b) then return false end
        
        if typeof(a) == "table" then
            for key, value in pairs(a) do
                if not self:deepEqual(value, b[key]) then
                    return false
                end
            end
            for key, value in pairs(b) do
                if a[key] == nil then
                    return false
                end
            end
            return true
        end
        
        return a == b
    end
    
    function store:notifySubscribers(oldState, newState, action)
        for _, callback in ipairs(self.subscribers) do
            pcall(callback, newState, oldState, action)
        end
    end
    
    function store:getState()
        return self.state
    end
    
    function store:subscribe(callback)
        table.insert(self.subscribers, callback)
        return function()
            for i, sub in ipairs(self.subscribers) do
                if sub == callback then
                    table.remove(self.subscribers, i)
                    break
                end
            end
        end
    end
    
    function store:undo()
        if #self.history > 0 then
            local last = table.remove(self.history)
            self:setState(last.state, "UNDO")
        end
    end
    
    NebulaUI_Internal.StateStores[HttpService:GenerateGUID(false)] = store
    return store
end

-- Error Boundary System untuk Component Creation
function NebulaUI:CreateComponentWithErrorBoundary(componentType, creationFunc, fallbackFunc)
    return function(...)
        local success, component = xpcall(creationFunc, function(err)
            self:HandleError("NON_CRITICAL", 
                string.format("Failed to create %s: %s", componentType, err),
                debug.traceback())
            
            -- Return fallback component
            if fallbackFunc then
                return fallbackFunc(...)
            end
            
            return self:CreateErrorComponent(componentType, err)
        end, ...)
        
        return component
    end
end

function NebulaUI:CreateErrorComponent(componentType, errorMessage)
    local errorFrame = Instance.new("Frame")
    errorFrame.Size = UDim2.new(1, 0, 0, 40)
    errorFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, -10)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = string.format("Error creating %s: %s", componentType, errorMessage)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextWrapped = true
    label.Parent = errorFrame
    
    return errorFrame
end

-- Enhanced Window Creation dengan Error Boundary
function NebulaUI:SecureCreateWindow(options)
    -- Validate dan sanitize semua input
    options = options or {}
    options.Name = ValidationSystem:SanitizeInput(options.Name, ValidationSystem.Types.STRING, {maxLength = 50}) or "NebulaWindow"
    options.Title = ValidationSystem:SanitizeInput(options.Title, ValidationSystem.Types.STRING, {maxLength = 100}) or "Nebula UI"
    options.Theme = options.Theme or "Modern"
    
    return self:CreateWindow(options)
end

function NebulaUI:CreateWindow(options)
    local valid, errorMsg = ValidationSystem:Validate(options, ValidationSystem.Types.TABLE, {optional = true})
    if not valid then
        error("Options must be a table or nil: " .. errorMsg)
    end
    
    return self:MeasurePerformance("CreateWindow", function()
        options = options or {}
        
        local window = {
            Name = options.Name or "NebulaWindow",
            Title = options.Title or "Nebula UI",
            ThemeName = options.Theme or "Modern",
            Tabs = {},
            Flags = {},
            IsOpen = false,
            _connections = setmetatable({}, {__mode = "v"}),
            _destroyed = false,
            _cleanupRegistry = setmetatable({}, {__mode = "v"}),
            _activeTweens = setmetatable({}, {__mode = "v"})
        }
        
        setmetatable(window, self)
        
        -- Apply theme
        window.Theme = MODERN_THEMES[window.ThemeName]
        window.EventSystem = EventSystem.new()
        
        -- Build GUI dengan error boundary
        local success, result = xpcall(function()
            window:BuildModernGUI()
        end, function(err)
            window:HandleError("CRITICAL", "Failed to build GUI: " .. err, "CreateWindow")
            return false
        end)
        
        if not success then
            window:HandleError("CRITICAL", "Window creation failed", "CreateWindow")
            return nil
        end
        
        table.insert(NebulaUI_Internal.Windows, window)
        
        self:DebugLog(string.format("Window '%s' created successfully", window.Name), "INFO")
        
        return window
    end)
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
    sidebarShadow.Image = self:GetCachedAsset("5554236773")
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
    title.Text = self:SafeText(self.Title)
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
    
    local overlayConnection = self:CreateSafeConnection(overlay.MouseButton1Click, function()
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
    
    local menuConnection = self:CreateSafeConnection(menuButton.MouseButton1Click, function()
        self:ToggleSidebar()
    end)
    
    -- Haptic feedback indicator (hidden by default)
    local hapticIndicator = Instance.new("Frame")
    hapticIndicator.Name = "HapticIndicator"
    hapticIndicator.Size = UDim2.new(1, 0, 1, 0)
    hapticIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
    hapticIndicator.BackgroundTransparency = 1
    hapticIndicator.ZIndex = 1000
    hapticIndicator.Parent = gui
    
    -- Gesture recognition for swipe to close
    if UserInputService.TouchEnabled then
        self:SetupGestureRecognition(sidebar)
    end
    
    -- Keyboard avoidance for mobile
    self:SetupKeyboardAvoidance()
    
    -- Store references
    self.GUI = gui
    self.Sidebar = sidebar
    self.TabList = tabList
    self.ContentArea = contentArea
    self.Overlay = overlay
    self.MenuButton = menuButton
    self.ToastManager = ToastManager.new(gui)
    self.TooltipManager = TooltipManager.new(gui)
    
    gui.Parent = player.PlayerGui
    
    self:DebugLog(string.format("Modern GUI built for window '%s'", self.Name), "INFO")
end

-- Gesture Recognition System
function NebulaUI:SetupGestureRecognition(sidebar)
    local touchStartPosition = nil
    local touchStartTime = 0
    
    local touchStartConnection = UserInputService.TouchStarted:Connect(function(input, processed)
        if processed then return end
        
        touchStartPosition = input.Position
        touchStartTime = tick()
    end)
    
    local touchEndConnection = UserInputService.TouchEnded:Connect(function(input, processed)
        if processed or not touchStartPosition then return end
        
        local touchEndPosition = input.Position
        local touchDuration = tick() - touchStartTime
        local deltaX = touchEndPosition.X - touchStartPosition.X
        local deltaY = math.abs(touchEndPosition.Y - touchStartPosition.Y)
        
        -- Swipe right to open, left to close
        if touchDuration < 0.5 and deltaY < 50 then
            if deltaX > 50 then -- Swipe right
                self:ToggleSidebar(true)
            elseif deltaX < -50 then -- Swipe left
                self:ToggleSidebar(false)
            end
        end
        
        touchStartPosition = nil
    end)
    
    table.insert(self._connections, touchStartConnection)
    table.insert(self._connections, touchEndConnection)
end

-- Keyboard Avoidance System
function NebulaUI:SetupKeyboardAvoidance()
    if not UserInputService.TouchEnabled then return end
    
    local keyboardConnection = UserInputService:GetPropertyChangedSignal("KeyboardHeight"):Connect(function()
        local keyboardHeight = UserInputService.KeyboardHeight
        
        if keyboardHeight > 0 then
            -- Keyboard is shown, adjust UI
            self:CreateRobustTween(self.ContentArea, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 30, 0, 20 - keyboardHeight / 2)
            })
        else
            -- Keyboard is hidden, restore position
            self:CreateRobustTween(self.ContentArea, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 30, 0, 20)
            })
        end
    end)
    
    table.insert(self._connections, keyboardConnection)
end

-- Enhanced ripple effect dengan konfigurasi yang lebih baik
function NebulaUI:CreateRippleEffect(button, input)
    local ripple = Instance.new("Frame")
    ripple.Name = "AdvancedRipple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, input.Position.X - button.AbsolutePosition.X, 0, input.Position.Y - button.AbsolutePosition.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    
    ripple.Parent = button
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    local tweenInfo = TweenInfo.new(
        0.6, 
        Enum.EasingStyle.Quad, 
        Enum.EasingDirection.Out
    )
    
    self:CreateRobustTween(ripple, tweenInfo, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, function()
        ripple:Destroy()
    end)
end

-- Secure Component Creation dengan Error Boundary
NebulaUI.SecureAddButton = NebulaUI:CreateComponentWithErrorBoundary("Button", function(self, tabContent, options)
    return self:AddButton(tabContent, options)
end)

NebulaUI.SecureAddToggle = NebulaUI:CreateComponentWithErrorBoundary("Toggle", function(self, tabContent, options)
    return self:AddToggle(tabContent, options)
end)

NebulaUI.SecureAddDropdown = NebulaUI:CreateComponentWithErrorBoundary("Dropdown", function(self, tabContent, options)
    return self:AddDropdown(tabContent, options)
end)

function NebulaUI:CreateModernButton(options)
    options = options or {}
    
    local button = Instance.new("TextButton")
    button.Name = options.Name or "ModernButton"
    button.Size = options.Size or UDim2.new(1, -40, 0, math.max(MOBILE_SETTINGS.ELEMENT_HEIGHT, MOBILE_SETTINGS.TOUCH_TARGET))
    button.BackgroundColor3 = options.BackgroundColor3 or self.Theme.SURFACE_VARIANT
    button.Text = self:SafeText(options.Text or "Button")
    button.TextColor3 = options.TextColor3 or self.Theme.ON_SURFACE
    button.TextSize = 16
    button.Font = Enum.Font.SourceSansSemibold
    button.AutoButtonColor = false
    button.ClipsDescendants = true
    
    -- Accessibility
    button:SetAttribute("aria-label", options.Text or "Button")
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, MOBILE_SETTINGS.CORNER_RADIUS)
    corner.Parent = button
    
    -- Ripple effect
    local function createRipple(input)
        self:CreateRippleEffect(button, input)
    end
    
    -- Tooltip support
    if options.Tooltip then
        self:CreateSafeConnection(button.MouseEnter, function()
            self.TooltipManager:ShowTooltip(button, options.Tooltip)
        end)
        
        self:CreateSafeConnection(button.MouseLeave, function()
            self.TooltipManager:HideTooltip()
        end)
    end
    
    -- Interaction effects
    self:CreateSafeConnection(button.MouseEnter, function()
        self:CreateRobustTween(button, TweenInfo.new(0.2), {
            BackgroundColor3 = (options.BackgroundColor3 or self.Theme.SURFACE_VARIANT):Lerp(self.Theme.PRIMARY, 0.1)
        })
    end)
    
    self:CreateSafeConnection(button.MouseLeave, function()
        self:CreateRobustTween(button, TweenInfo.new(0.2), {
            BackgroundColor3 = options.BackgroundColor3 or self.Theme.SURFACE_VARIANT
        })
    end)
    
    self:CreateSafeConnection(button.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            createRipple(input)
            self:ProvideHapticFeedback(0.3)
            self:CreateRobustTween(button, TweenInfo.new(0.1), {
                BackgroundColor3 = (options.BackgroundColor3 or self.Theme.SURFACE_VARIANT):Lerp(self.Theme.PRIMARY, 0.2)
            })
        end
    end)
    
    self:CreateSafeConnection(button.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:CreateRobustTween(button, TweenInfo.new(0.2), {
                BackgroundColor3 = options.BackgroundColor3 or self.Theme.SURFACE_VARIANT
            })
        end
    end)
    
    if options.Callback then
        local debouncedCallback = self:CreateDebouncedCallback(options.Callback, 0.1)
        self:CreateSafeConnection(button.MouseButton1Click, function()
            pcall(debouncedCallback)
        end)
    end
    
    return button
end

function NebulaUI:CreateTab(options)
    local valid, errorMsg = ValidationSystem:Validate(options, ValidationSystem.Types.TABLE)
    if not valid then
        error("Tab options must be a table: " .. errorMsg)
    end
    
    local valid, errorMsg = ValidationSystem:Validate(options.Name, ValidationSystem.Types.STRING, {notEmpty = true})
    if not valid then
        error("Tab name is required: " .. errorMsg)
    end
    
    options = options or {}
    
    local tab = {
        Name = options.Name or "Tab",
        Icon = options.Icon,
        Content = nil,
        Window = self,
        LifecycleHooks = {
            onMount = options.onMount,
            onUnmount = options.onUnmount,
            onUpdate = options.onUpdate
        }
    }
    
    -- Create sidebar tab button
    local tabButton = self:CreateModernButton({
        Name = tab.Name .. "Tab",
        Text = tab.Name,
        BackgroundColor3 = self.Theme.SURFACE_VARIANT,
        Tooltip = options.Tooltip
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
    self:CreateSafeConnection(tabButton.MouseButton1Click, function()
        self:SelectTab(tab)
    end)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    self:DebugLog(string.format("Tab '%s' created successfully", tab.Name), "INFO")
    
    return tab
end

function NebulaUI:SelectTab(selectedTab)
    return self:MeasurePerformance("SelectTab", function()
        for _, tab in ipairs(self.Tabs) do
            tab.Content.Visible = false
            self:CreateRobustTween(tab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.SURFACE_VARIANT
            })
            
            -- Call unmount hook
            if tab.LifecycleHooks.onUnmount then
                pcall(tab.LifecycleHooks.onUnmount)
            end
        end
        
        selectedTab.Content.Visible = true
        self:CreateRobustTween(selectedTab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.PRIMARY
        })
        
        self.ContentArea.Visible = true
        self:ToggleSidebar(false)
        
        -- Call mount hook
        if selectedTab.LifecycleHooks.onMount then
            pcall(selectedTab.LifecycleHooks.onMount)
        end
        
        self.ToastManager:ShowToast({
            Title = "Navigation",
            Content = "Switched to " .. selectedTab.Name,
            Type = "INFO",
            Duration = 2
        })
        
        -- Fire tab change event
        self.EventSystem:Fire("TabChanged", selectedTab.Name)
        
        self:DebugLog(string.format("Selected tab: %s", selectedTab.Name), "DEBUG")
    end)
end

function NebulaUI:ToggleSidebar(forceState)
    return self:MeasurePerformance("ToggleSidebar", function()
        if forceState == nil then
            forceState = not self.IsOpen
        end
        
        self.IsOpen = forceState
        
        if self.IsOpen then
            self.Overlay.Visible = true
            self:CreateRobustTween(self.Sidebar, TweenInfo.new(MOBILE_SETTINGS.ANIMATION_DURATION, Enum.EasingStyle.Cubic), {
                Position = UDim2.new(0, 0, 0, 0)
            })
        else
            self:CreateRobustTween(self.Sidebar, TweenInfo.new(MOBILE_SETTINGS.ANIMATION_DURATION, Enum.EasingStyle.Cubic), {
                Position = UDim2.new(-1, 0, 0, 0)
            })
            
            task.delay(MOBILE_SETTINGS.ANIMATION_DURATION, function()
                self.Overlay.Visible = false
            end)
        end
        
        -- Fire sidebar state event
        self.EventSystem:Fire("SidebarToggled", self.IsOpen)
        
        self:DebugLog(string.format("Sidebar %s", self.IsOpen and "opened" or "closed"), "DEBUG")
    end)
end

-- Modern UI Components dengan enhanced validation
function NebulaUI:AddButton(tabContent, options)
    local valid, errorMsg = ValidationSystem:Validate(tabContent, ValidationSystem.Types.USERDATA)
    if not valid then
        error("Tab content must be a valid instance: " .. errorMsg)
    end
    
    local valid, errorMsg = ValidationSystem:Validate(options, ValidationSystem.Types.TABLE)
    if not valid then
        error("Button options must be a table: " .. errorMsg)
    end
    
    local button = self:CreateModernButton(options)
    button.Parent = tabContent
    return button
end

function NebulaUI:AddToggle(tabContent, options)
    local valid, errorMsg = ValidationSystem:Validate(tabContent, ValidationSystem.Types.USERDATA)
    if not valid then
        error("Tab content must be a valid instance: " .. errorMsg)
    end
    
    local valid, errorMsg = ValidationSystem:Validate(options, ValidationSystem.Types.TABLE)
    if not valid then
        error("Toggle options must be a table: " .. errorMsg)
    end
    
    options = options or {}
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = options.Name or "Toggle"
    toggleContainer.Size = UDim2.new(1, 0, 0, math.max(MOBILE_SETTINGS.ELEMENT_HEIGHT, MOBILE_SETTINGS.TOUCH_TARGET))
    toggleContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = self:SafeText(options.Text or options.Name or "Toggle")
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
        self:CreateRobustTween(toggleSwitch, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and self.Theme.PRIMARY or self.Theme.OUTLINE
        })
        
        self:CreateRobustTween(toggleThumb, TweenInfo.new(0.2), {
            Position = isToggled and UDim2.new(1, -26, 0, 2) or UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = isToggled and self.Theme.ON_PRIMARY or self.Theme.SURFACE
        })
        
        if options.Callback then
            pcall(options.Callback, isToggled)
        end
        
        -- Fire toggle change event
        self.EventSystem:Fire("ToggleChanged", options.Name or "Unnamed", isToggled)
    end
    
    self:CreateSafeConnection(toggleSwitch.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isToggled = not isToggled
            self:ProvideHapticFeedback(0.2)
            updateToggle()
            
            self:DebugLog(string.format("Toggle '%s' set to: %s", options.Name or "Unnamed", tostring(isToggled)), "DEBUG")
        end
    end)
    
    updateToggle()
    toggleContainer.Parent = tabContent
    
    return {
        Container = toggleContainer,
        SetValue = function(self, value)
            isToggled = value
            updateToggle()
        end,
        GetValue = function(self)
            return isToggled
        end
    }
end

-- Form Validation System
function NebulaUI:CreateFormValidator(rules)
    local validator = {
        rules = rules or {},
        errors = {}
    }
    
    function validator:validate(data)
        self.errors = {}
        
        for field, rule in pairs(self.rules) do
            local value = data[field]
            
            if rule.required and (value == nil or value == "") then
                self.errors[field] = rule.requiredMessage or field .. " is required"
            elseif value ~= nil and value ~= "" then
                if rule.type and type(value) ~= rule.type then
                    self.errors[field] = field .. " must be a " .. rule.type
                end
                
                if rule.min and type(value) == "number" and value < rule.min then
                    self.errors[field] = field .. " must be at least " .. rule.min
                end
                
                if rule.max and type(value) == "number" and value > rule.max then
                    self.errors[field] = field .. " must be at most " .. rule.max
                end
                
                if rule.pattern and type(value) == "string" and not string.match(value, rule.pattern) then
                    self.errors[field] = rule.patternMessage or field .. " is invalid"
                end
                
                if rule.custom and type(rule.custom) == "function" then
                    local valid, message = rule.custom(value)
                    if not valid then
                        self.errors[field] = message or field .. " is invalid"
                    end
                end
            end
        end
        
        return #self.errors == 0, self.errors
    end
    
    function validator:getErrors()
        return self.errors
    end
    
    return validator
end

-- Localization System
function NebulaUI:SetupLocalization(translations, defaultLanguage)
    NebulaUI_Internal.Localization = {
        translations = translations or {},
        currentLanguage = defaultLanguage or "en",
        fallbackLanguage = "en"
    }
end

function NebulaUI:SetLanguage(language)
    if NebulaUI_Internal.Localization.translations[language] then
        NebulaUI_Internal.Localization.currentLanguage = language
        self.EventSystem:Fire("LanguageChanged", language)
    else
        self:DebugLog("Language not found: " .. language, "WARN")
    end
end

function NebulaUI:Translate(key, ...)
    local loc = NebulaUI_Internal.Localization
    local translation = loc.translations[loc.currentLanguage] and loc.translations[loc.currentLanguage][key]
                    or loc.translations[loc.fallbackLanguage] and loc.translations[loc.fallbackLanguage][key]
                    or key
    
    if ... then
        translation = string.format(translation, ...)
    end
    
    return translation
end

-- XSS Prevention
function NebulaUI:SafeText(text)
    if type(text) ~= "string" then
        return tostring(text)
    end
    
    -- Basic XSS prevention
    return string.gsub(text, "[<>]", function(c)
        if c == "<" then
            return "&lt;"
        else
            return "&gt;"
        end
    end)
end

-- Rate Limiting System
function NebulaUI:CreateRateLimiter(key, limit, period)
    period = period or 60 -- Default 60 seconds
    
    if not NebulaUI_Internal.RateLimiters[key] then
        NebulaUI_Internal.RateLimiters[key] = {
            calls = 0,
            resetTime = tick() + period
        }
    end
    
    local limiter = NebulaUI_Internal.RateLimiters[key]
    
    if tick() > limiter.resetTime then
        limiter.calls = 0
        limiter.resetTime = tick() + period
    end
    
    if limiter.calls >= limit then
        return false, "Rate limit exceeded"
    end
    
    limiter.calls = limiter.calls + 1
    return true, limit - limiter.calls
end

-- Component Registration System
function NebulaUI:RegisterComponent(name, componentClass)
    local valid, errorMsg = ValidationSystem:Validate(name, ValidationSystem.Types.STRING, {notEmpty = true})
    if not valid then
        error("Component name must be a non-empty string: " .. errorMsg)
    end
    
    local valid, errorMsg = ValidationSystem:Validate(componentClass, ValidationSystem.Types.TABLE)
    if not valid then
        error("Component class must be a table: " .. errorMsg)
    end
    
    NebulaUI_Internal.ComponentRegistry[name] = componentClass
    self:DebugLog("Component registered: " .. name, "INFO")
end

function NebulaUI:CreateRegisteredComponent(name, ...)
    local componentClass = NebulaUI_Internal.ComponentRegistry[name]
    if not componentClass then
        error("Component not found: " .. name)
    end
    
    return componentClass.new(...)
end

-- Debug Overlay System
function NebulaUI:EnableDebugOverlay()
    if NebulaUI_Internal.DebugOverlay then return end
    
    local debugGui = Instance.new("ScreenGui")
    debugGui.Name = "NebulaDebugOverlay"
    debugGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    debugGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(1, -310, 1, -210)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Nebula UI Debug"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansSemibold
    title.Parent = frame
    
    local metricsText = Instance.new("TextLabel")
    metricsText.Size = UDim2.new(1, -10, 1, -40)
    metricsText.Position = UDim2.new(0, 5, 0, 35)
    metricsText.BackgroundTransparency = 1
    metricsText.TextColor3 = Color3.new(1, 1, 1)
    metricsText.TextSize = 12
    metricsText.TextXAlignment = Enum.TextXAlignment.Left
    metricsText.TextYAlignment = Enum.TextYAlignment.Top
    metricsText.Font = Enum.Font.SourceSans
    metricsText.Text = "Loading metrics..."
    metricsText.Parent = frame
    
    frame.Parent = debugGui
    debugGui.Parent = player.PlayerGui
    
    -- Update metrics periodically
    local connection = RunService.Heartbeat:Connect(function()
        local metrics = self:GetPerformanceMetrics()
        local text = "Performance Metrics:\n"
        
        for funcName, data in pairs(metrics) do
            text ..= string.format("\n%s:\n  Calls: %d\n  Avg: %.3fs\n  Max: %.3fs\n  Min: %.3fs",
                funcName, data.callCount, data.averageTime, data.maxTime, data.minTime)
        end
        
        text ..= "\n\nActive Windows: " .. #NebulaUI_Internal.Windows
        text ..= "\nMemory Usage: " .. collectgarbage("count") .. " KB"
        text ..= "\nErrors: " .. (table.count(ErrorHandler.CriticalErrors) + table.count(ErrorHandler.NonCriticalErrors))
        
        metricsText.Text = text
    end)
    
    NebulaUI_Internal.DebugOverlay = {
        GUI = debugGui,
        Connection = connection
    }
end

function NebulaUI:DisableDebugOverlay()
    if NebulaUI_Internal.DebugOverlay then
        NebulaUI_Internal.DebugOverlay.Connection:Disconnect()
        NebulaUI_Internal.DebugOverlay.GUI:Destroy()
        NebulaUI_Internal.DebugOverlay = nil
    end
end

-- Automatic Cleanup Registry
function NebulaUI:RegisterForCleanup(object, cleanupFunction)
    if not self._cleanupRegistry then
        self._cleanupRegistry = setmetatable({}, {__mode = "v"})
    end
    
    table.insert(self._cleanupRegistry, {
        object = object,
        cleanup = cleanupFunction
    })
end

function NebulaUI:Cleanup()
    if self._cleanupRegistry then
        for _, item in ipairs(self._cleanupRegistry) do
            if item.cleanup then
                pcall(item.cleanup)
            elseif item.object and item.object.Destroy then
                pcall(item.object.Destroy, item.object)
            end
        end
        self._cleanupRegistry = {}
    end
end

-- Performance Health Monitor
function NebulaUI:StartHealthMonitor()
    self._healthMonitor = RunService.Heartbeat:Connect(function()
        local memoryUsage = collectgarbage("count")
        if memoryUsage > 10000 then -- 10MB threshold
            self:DebugLog("High memory usage detected: " .. memoryUsage .. " KB", "WARN")
            self:PerformCleanup()
        end
        
        -- Monitor frame rate
        local currentTime = tick()
        if not self._lastFrameCheck then self._lastFrameCheck = currentTime end
        
        if currentTime - self._lastFrameCheck > 5 then -- Check every 5 seconds
            self._lastFrameCheck = currentTime
            
            -- Simple FPS calculation
            if not self._frameCount then self._frameCount = 0 end
            if not self._lastFPSCheck then self._lastFPSCheck = currentTime end
            
            self._frameCount = self._frameCount + 1
            
            if currentTime - self._lastFPSCheck >= 1 then
                local fps = self._frameCount / (currentTime - self._lastFPSCheck)
                self._frameCount = 0
                self._lastFPSCheck = currentTime
                
                if fps < 20 then
                    self:DebugLog("Low FPS detected: " .. math.floor(fps) .. ", optimizing...", "WARN")
                    self:OptimizePerformance()
                end
            end
        end
    end)
end

function NebulaUI:OptimizePerformance()
    -- Cleanup unused assets
    self:CleanupAssetCache()
    
    -- Cancel non-essential animations
    for tweenId, tweenData in pairs(NebulaUI_Internal.ActiveTweens) do
        if tweenData and tweenData.Controller and not tweenData.essential then
            tweenData.Controller.Cancel()
        end
    end
    
    -- Force garbage collection
    task.defer(function()
        wait(0.5)
        collectgarbage("collect")
    end)
end

function NebulaUI:PerformCleanup()
    -- Cleanup asset cache
    self:CleanupAssetCache()
    
    -- Clear old error logs
    local now = tick()
    for errorId, errorInfo in pairs(ErrorHandler.NonCriticalErrors) do
        if now - errorInfo.Timestamp > 300 then -- 5 minutes
            ErrorHandler.NonCriticalErrors[errorId] = nil
        end
    end
    
    -- Force garbage collection
    collectgarbage("collect")
end

-- Type Checking System
function NebulaUI:CreateTypeValidator(schema)
    return function(data)
        for key, expectedType in pairs(schema) do
            if data[key] == nil then
                return false, "Missing required field: " .. key
            end
            
            if type(data[key]) ~= expectedType then
                return false, string.format("Field %s expected %s, got %s", key, expectedType, type(data[key]))
            end
        end
        return true
    end
end

-- Public API Methods
function NebulaUI:ShowToast(options)
    local valid, errorMsg = ValidationSystem:Validate(options, ValidationSystem.Types.TABLE)
    if not valid then
        error("Toast options must be a table: " .. errorMsg)
    end
    
    self.ToastManager:ShowToast(options)
end

function NebulaUI:SetTheme(themeName)
    local valid, errorMsg = ValidationSystem:Validate(themeName, ValidationSystem.Types.STRING, {notEmpty = true})
    if not valid then
        error("Theme name must be a non-empty string: " .. errorMsg)
    end
    
    if MODERN_THEMES[themeName] then
        local oldTheme = NebulaUI_Internal.CurrentTheme
        NebulaUI_Internal.CurrentTheme = themeName
        self.Theme = MODERN_THEMES[themeName]
        
        -- Update all UI elements with new theme
        self:UpdateTheme()
        
        -- Fire theme change event
        self.EventSystem:Fire("ThemeChanged", oldTheme, themeName)
        
        self:DebugLog(string.format("Theme changed to: %s", themeName), "INFO")
    else
        self:DebugLog(string.format("Invalid theme name: %s", themeName), "WARN")
    end
end

function NebulaUI:UpdateTheme()
    -- This would recursively update all UI elements with the new theme
    -- Implementation would depend on the specific UI structure
    if self.Sidebar then
        self.Sidebar.BackgroundColor3 = self.Theme.SURFACE
    end
    -- Add more theme update logic here...
end

function NebulaUI:Connect(eventName, callback)
    return self.EventSystem:Connect(eventName, callback)
end

function NebulaUI:GetPerformanceMetrics()
    return DebugSystem.PerformanceMetrics
end

function NebulaUI:GetErrorReport()
    return ErrorHandler:GetErrorReport()
end

function NebulaUI:EnableDebug(enable)
    DebugSystem.Enabled = enable
end

function NebulaUI:SetLogLevel(level)
    local validLevels = {"DEBUG", "INFO", "WARN", "ERROR"}
    if table.find(validLevels, level) then
        DebugSystem.LogLevel = level
    else
        warn("Invalid log level. Use: DEBUG, INFO, WARN, ERROR")
    end
end

function NebulaUI:Destroy()
    if self.GUI then
        -- Stop health monitor
        if self._healthMonitor then
            self._healthMonitor:Disconnect()
        end
        
        -- Clean up all connections
        for _, connection in ipairs(self._connections) do
            pcall(function() connection:Disconnect() end)
        end
        
        -- Cancel all active tweens
        for tweenId, tweenData in pairs(self._activeTweens) do
            if tweenData and tweenData.Controller then
                pcall(tweenData.Controller.Cancel)
            end
        end
        
        -- Run cleanup registry
        self:Cleanup()
        
        -- Mark as destroyed
        self._destroyed = true
        
        self.GUI:Destroy()
        self:DebugLog(string.format("Window '%s' destroyed", self.Name), "INFO")
        
        -- Remove from windows list
        for i, window in ipairs(NebulaUI_Internal.Windows) do
            if window == self then
                table.remove(NebulaUI_Internal.Windows, i)
                break
            end
        end
    end
end

-- Initialize asset cache
NebulaUI:InitializeAssetCache()

-- Start health monitoring
task.spawn(function()
    wait(2) -- Wait for everything to initialize
    NebulaUI:StartHealthMonitor()
end)

-- Make library available globally dengan safety check
if getgenv then
    if not getgenv().NebulaUI then
        getgenv().NebulaUI = NebulaUI
        getgenv().NebulaUI_Internal = NebulaUI_Internal -- For advanced debugging
    else
        warn("NebulaUI is already defined in global environment")
    end
end

-- Export all systems
NebulaUI.ValidationSystem = ValidationSystem
NebulaUI.VirtualList = VirtualList
NebulaUI.ContextMenu = ContextMenu
NebulaUI.TooltipManager = TooltipManager
NebulaUI.ErrorHandler = ErrorHandler

return NebulaUI
