--[[
==============================================================================================
 ThaiSoldier Auto Mine V4 - High Detail & Advanced System
 Created by: KobeCozydawg
 Version: 4.0.1
 Description: Advanced auto mining system with high precision movement, intelligent ore detection, and mobile optimization
==============================================================================================
--]]

-- ========== SERVICES & INITIALIZATION ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- ========== PLAYER REFERENCES ==========
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ========== SYSTEM CONFIGURATION ==========
local CONFIG = {
    -- Movement Settings
    MOVEMENT_SPEED = 16,
    MOVEMENT_PRECISION = 2.5, -- How close to get to target (studs)
    PATHFINDING_TIMEOUT = 10,
    
    -- Mining Settings
    MINE_DURATION = 2.5,
    MINE_COOLDOWN = 0.5,
    
    -- Safety Settings
    ANTI_AFK_ENABLED = true,
    ANTI_AFK_INTERVAL = 30,
    
    -- UI Settings
    UI_OPACITY = 0.95,
    UI_ANIMATION_SPEED = 0.3,
    
    -- Performance Settings
    UPDATE_INTERVAL = 0.1,
    RAYCAST_DISTANCE = 50
}

-- ========== ADVANCED ORE DATABASE ==========
local ORE_DATABASE = {
    {
        id = "iron_001",
        name = "เหล็กก้อนที่1", 
        type = "Iron",
        tier = 1,
        position = Vector3.new(-387.63, 4.05, -74.19),
        respawnTime = 60,
        value = 25,
        weight = 15
    },
    {
        id = "copper_001",
        name = "ทองแดงก้อนที่1",
        type = "Copper", 
        tier = 1,
        position = Vector3.new(-399.82, 4.83, -74.84),
        respawnTime = 45,
        value = 15,
        weight = 12
    },
    {
        id = "iron_002",
        name = "เหล็กก้อนที่2",
        type = "Iron",
        tier = 1,
        position = Vector3.new(-368.52, 8.90, -73.32),
        respawnTime = 60,
        value = 25,
        weight = 15
    },
    {
        id = "coal_001",
        name = "ถ่านก้อนที่1",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-390.16, -0.56, -57.80),
        respawnTime = 30,
        value = 8,
        weight = 8
    },
    {
        id = "copper_002",
        name = "ทองแดงก้อนที่2",
        type = "Copper",
        tier = 1,
        position = Vector3.new(-406.71, -8.37, -48.87),
        respawnTime = 45,
        value = 15,
        weight = 12
    },
    {
        id = "coal_002",
        name = "ถ่านก้อนที่2",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-403.38, -13.62, -37.95),
        respawnTime = 30,
        value = 8,
        weight = 8
    },
    {
        id = "coal_003",
        name = "ถ่านก้อนที่3",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-387.06, -14.13, -39.31),
        respawnTime = 30,
        value = 8,
        weight = 8
    },
    {
        id = "coal_004",
        name = "ถ่านก้อนที่4",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-388.75, -7.68, -20.59),
        respawnTime = 30,
        value = 8,
        weight = 8
    },
    {
        id = "iron_003",
        name = "เหล็กก้อนที่3",
        type = "Iron",
        tier = 1,
        position = Vector3.new(-391.27, -7.48, -10.49),
        respawnTime = 60,
        value = 25,
        weight = 15
    },
    {
        id = "diamond_001",
        name = "เพชรก้อนที่1",
        type = "Diamond",
        tier = 3,
        position = Vector3.new(-400.27, -7.77, -12.55),
        respawnTime = 180,
        value = 100,
        weight = 5
    },
    {
        id = "copper_003",
        name = "ทองแดงก้อนที่3",
        type = "Copper",
        tier = 1,
        position = Vector3.new(-386.51, -7.30, -21.80),
        respawnTime = 45,
        value = 15,
        weight = 12
    },
    {
        id = "iron_004",
        name = "เหล็กก้อนที่4",
        type = "Iron",
        tier = 1,
        position = Vector3.new(-416.84, -14.22, -30.66),
        respawnTime = 60,
        value = 25,
        weight = 15
    },
    {
        id = "coal_005",
        name = "ถ่านก้อนที่5",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-408.36, -13.23, -17.06),
        respawnTime = 30,
        value = 8,
        weight = 8
    },
    {
        id = "iron_005",
        name = "เหล็กก้อนที่5",
        type = "Iron",
        tier = 1,
        position = Vector3.new(-416.72, -14.20, 5.16),
        respawnTime = 60,
        value = 25,
        weight = 15
    },
    {
        id = "coal_006",
        name = "ถ่านก้อนที่6",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-432.56, -7.92, -32.08),
        respawnTime = 30,
        value = 8,
        weight = 8
    },
    {
        id = "coal_007",
        name = "ถ่านก้อนที่7",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-437.49, -7.75, 3.10),
        respawnTime = 30,
        value = 8,
        weight = 8
    },
    {
        id = "coal_008",
        name = "ถ่านก้อนที่8",
        type = "Coal",
        tier = 1,
        position = Vector3.new(-430.85, -7.25, -9.49),
        respawnTime = 30,
        value = 8,
        weight = 8
    }
}

-- ========== SELLING LOCATIONS ==========
local SELL_LOCATIONS = {
    {
        name = "ร้านขายแร่ A",
        position = Vector3.new(-350, 5, -50),
        npcName = "แร่พ่อค้า",
        buyRate = 1.0
    },
    {
        name = "ร้านขายแร่ B", 
        position = Vector3.new(-360, 5, -40),
        npcName = "แร่แม่ค้า",
        buyRate = 1.1
    }
}

-- ========== SYSTEM VARIABLES ==========
local SystemState = {
    isRunning = false,
    isPaused = false,
    currentMode = "IDLE", -- "MINING", "SELLING", "RESTING"
    currentTargetIndex = 1,
    totalOresMined = 0,
    sessionEarnings = 0,
    startTime = 0,
    pathfinder = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true
    })
}

local UIElements = {}
local Statistics = {
    oresMined = {Iron = 0, Copper = 0, Coal = 0, Diamond = 0},
    distanceTraveled = 0,
    timeSpentMining = 0,
    successfulMines = 0,
    failedMines = 0
}

-- ========== ADVANCED MOVEMENT SYSTEM ==========
local MovementController = {
    currentDestination = nil,
    isMoving = false,
    lastPosition = nil,
    stuckCheckCounter = 0
}

function MovementController:CalculateOptimalPath(targetPosition)
    -- สร้าง pathfinding path ไปยังเป้าหมาย
    local character = Player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    SystemState.pathfinder:ComputeAsync(humanoidRootPart.Position, targetPosition)
    
    if SystemState.pathfinder.Status == Enum.PathStatus.Success then
        local waypoints = SystemState.pathfinder:GetWaypoints()
        return waypoints
    else
        warn("Pathfinding failed: " .. tostring(SystemState.pathfinder.Status))
        return false
    end
end

function MovementController:SmartMoveTo(position)
    local character = Player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- คำนวณระยะทาง
    local distance = (rootPart.Position - position).Magnitude
    
    if distance <= CONFIG.MOVEMENT_PRECISION then
        return true -- ถึงเป้าหมายแล้ว
    end
    
    -- ใช้ pathfinding ถ้าระยะทางไกล
    if distance > 20 then
        local waypoints = self:CalculateOptimalPath(position)
        if waypoints then
            for _, waypoint in ipairs(waypoints) do
                if not SystemState.isRunning then break end
                
                humanoid:MoveTo(waypoint.Position)
                
                -- รอให้เคลื่อนที่ถึง waypoint นี้
                local wpReached = false
                local waitTime = 0
                while not wpReached and waitTime < CONFIG.PATHFINDING_TIMEOUT do
                    local currentDist = (rootPart.Position - waypoint.Position).Magnitude
                    if currentDist <= CONFIG.MOVEMENT_PRECISION then
                        wpReached = true
                    end
                    wait(0.1)
                    waitTime = waitTime + 0.1
                end
                
                if not wpReached then
                    warn("Failed to reach waypoint")
                    return false
                end
            end
            return true
        end
    end
    
    -- ถ้า pathfinding ล้มเหลวหรือระยะใกล้ ให้ใช้การเคลื่อนที่ปกติ
    humanoid:MoveTo(position)
    
    -- รอให้ถึงเป้าหมาย
    local arrived = false
    local waitTime = 0
    while not arrived and waitTime < CONFIG.PATHFINDING_TIMEOUT do
        local currentDist = (rootPart.Position - position).Magnitude
        if currentDist <= CONFIG.MOVEMENT_PRECISION then
            arrived = true
        end
        
        -- ตรวจสอบการติด
        if self.lastPosition then
            local movedDistance = (rootPart.Position - self.lastPosition).Magnitude
            if movedDistance < 0.5 then
                self.stuckCheckCounter = self.stuckCheckCounter + 1
                if self.stuckCheckCounter > 10 then
                    -- พยายามกระโดดเพื่อแก้การติด
                    humanoid.Jump = true
                    self.stuckCheckCounter = 0
                end
            else
                self.stuckCheckCounter = 0
            end
        end
        
        self.lastPosition = rootPart.Position
        wait(0.1)
        waitTime = waitTime + 0.1
    end
    
    return arrived
end

-- ========== ADVANCED MINING SYSTEM ==========
local MiningSystem = {
    lastMineTime = 0,
    currentOre = nil
}

function MiningSystem:CanMine()
    return os.time() - self.lastMineTime >= CONFIG.MINE_COOLDOWN
end

function MiningSystem:SimulateMining(oreData)
    if not self:CanMine() then return false end
    
    local character = Player.Character
    if not character then return false end
    
    -- ตรวจสอบว่าแร่ยังอยู่ (raycast check)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
    
    local rayOrigin = character:FindFirstChild("HumanoidRootPart").Position
    local rayDirection = (oreData.position - rayOrigin).Unit * CONFIG.RAYCAST_DISTANCE
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        -- พบวัตถุระหว่างทางไปหาแร่
        warn("Obstacle detected between player and ore")
        return false
    end
    
    -- จำลองการขุดแร่
    print("🔄 Starting mining sequence for: " .. oreData.name)
    
    -- โค้ดการขุดแร่จริงๆ ควรปรับตามเกมที่เล่น
    -- ตัวอย่าง: ส่ง input event สำหรับการขุด
    if UserInputService.TouchEnabled then
        -- สำหรับมือถือ: สัมผัสหน้าจอเพื่อขุด
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    else
        -- สำหรับคอมพิวเตอร์: กดปุ่ม E เพื่อขุด
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
    
    -- รอให้ขุดเสร็จ
    wait(CONFIG.MINE_DURATION)
    
    self.lastMineTime = os.time()
    Statistics.successfulMines = Statistics.successfulMines + 1
    Statistics.oresMined[oreData.type] = (Statistics.oresMined[oreData.type] or 0) + 1
    Statistics.timeSpentMining = Statistics.timeSpentMining + CONFIG.MINE_DURATION
    
    print("✅ Successfully mined: " .. oreData.name)
    return true
end

-- ========== ANTI-AFK SYSTEM ==========
local AntiAFKSystem = {
    lastActivity = os.time()
}

function AntiAFKSystem:UpdateActivity()
    self.lastActivity = os.time()
end

function AntiAFKSystem:Start()
    if not CONFIG.ANTI_AFK_ENABLED then return end
    
    spawn(function()
        while SystemState.isRunning do
            local currentTime = os.time()
            if currentTime - self.lastActivity > CONFIG.ANTI_AFK_INTERVAL then
                -- ทำกิจกรรมเพื่อป้องกัน AFK
                local character = Player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        -- หมุนตัวเล็กน้อย
                        humanoid:Move(Vector3.new(0, 0, 0))
                        print("🔄 Anti-AFK: Performing activity")
                    end
                end
                self:UpdateActivity()
            end
            wait(1)
        end
    end)
end

-- ========== ADVANCED UI SYSTEM ==========
local UIManager = {}

function UIManager:CreateHighDetailGUI()
    -- Create main screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ThaiSoldierMineV4_Advanced"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    UIElements.ScreenGui = ScreenGui
    
    -- Main container with advanced styling
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 450, 0, 600)
    MainContainer.Position = UDim2.new(0.5, -225, 0.5, -300)
    MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainContainer.BackgroundTransparency = 0.05
    MainContainer.BorderSizePixel = 0
    MainContainer.Parent = ScreenGui
    
    -- Add gradient background
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    Gradient.Rotation = 45
    Gradient.Parent = MainContainer
    
    -- Header section
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Header.BorderSizePixel = 0
    Header.Parent = MainContainer
    
    local HeaderGradient = Instance.new("UIGradient")
    HeaderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 120, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 160, 240))
    })
    HeaderGradient.Rotation = 45
    HeaderGradient.Parent = Header
    
    -- Title with icon
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "⚒️ THAISOLDIER MINE V4"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Padding = {
        Left = UDim.new(0, 15),
        Right = UDim.new(0, 0),
        Top = UDim.new(0, 0),
        Bottom = UDim.new(0, 0)
    }
    TitleLabel.Parent = Header
    
    -- Creator credit
    local CreatorLabel = Instance.new("TextLabel")
    CreatorLabel.Name = "CreatorLabel"
    CreatorLabel.Size = UDim2.new(0.3, 0, 1, 0)
    CreatorLabel.Position = UDim2.new(0.7, 0, 0, 0)
    CreatorLabel.BackgroundTransparency = 1
    CreatorLabel.Text = "by KobeCozydawg"
    CreatorLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    CreatorLabel.Font = Enum.Font.Gotham
    CreatorLabel.TextSize = 12
    CreatorLabel.TextXAlignment = Enum.TextXAlignment.Right
    CreatorLabel.Padding = {
        Right = UDim.new(0, 15)
    }
    CreatorLabel.Parent = Header
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0.5, -20)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.Parent = Header
    
    -- Status panel
    local StatusPanel = self:CreateStatusPanel(MainContainer)
    local ControlPanel = self:CreateControlPanel(MainContainer)
    local StatisticsPanel = self:CreateStatisticsPanel(MainContainer)
    local ProgressPanel = self:CreateProgressPanel(MainContainer)
    
    -- Setup interactions
    self:SetupInteractions()
    
    return ScreenGui
end

function UIManager:CreateStatusPanel(parent)
    local StatusPanel = Instance.new("Frame")
    StatusPanel.Name = "StatusPanel"
    StatusPanel.Size = UDim2.new(0.9, 0, 0, 100)
    StatusPanel.Position = UDim2.new(0.05, 0, 0.1, 0)
    StatusPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    StatusPanel.BackgroundTransparency = 0.1
    StatusPanel.BorderSizePixel = 0
    StatusPanel.Parent = parent
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "🟢 SYSTEM READY\nAdvanced Mining System Active"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = StatusPanel
    
    UIElements.StatusLabel = StatusLabel
    
    return StatusPanel
end

function UIManager:CreateControlPanel(parent)
    local ControlPanel = Instance.new("Frame")
    ControlPanel.Name = "ControlPanel"
    ControlPanel.Size = UDim2.new(0.9, 0, 0, 180)
    ControlPanel.Position = UDim2.new(0.05, 0, 0.3, 0)
    ControlPanel.BackgroundTransparency = 1
    ControlPanel.Parent = parent
    
    -- Start button
    local StartButton = Instance.new("TextButton")
    StartButton.Name = "StartButton"
    StartButton.Size = UDim2.new(0.45, 0, 0, 50)
    StartButton.Position = UDim2.new(0, 0, 0, 0)
    StartButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    StartButton.Text = "🚀 START MINING"
    StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartButton.Font = Enum.Font.GothamBold
    StartButton.TextSize = 14
    StartButton.Parent = ControlPanel
    
    -- Sell button
    local SellButton = Instance.new("TextButton")
    SellButton.Name = "SellButton"
    SellButton.Size = UDim2.new(0.45, 0, 0, 50)
    SellButton.Position = UDim2.new(0.55, 0, 0, 0)
    SellButton.BackgroundColor3 = Color3.fromRGB(160, 120, 80)
    SellButton.Text = "💰 AUTO SELL"
    SellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SellButton.Font = Enum.Font.GothamBold
    SellButton.TextSize = 14
    SellButton.Parent = ControlPanel
    
    -- Stop button
    local StopButton = Instance.new("TextButton")
    StopButton.Name = "StopButton"
    StopButton.Size = UDim2.new(1, 0, 0, 40)
    StopButton.Position = UDim2.new(0, 0, 0.4, 0)
    StopButton.BackgroundColor3 = Color3.fromRGB(160, 80, 80)
    StopButton.Text = "🛑 EMERGENCY STOP"
    StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopButton.Font = Enum.Font.Gotham
    StopButton.TextSize = 12
    StopButton.Visible = false
    StopButton.Parent = ControlPanel
    
    -- Quick actions
    local QuickMineButton = Instance.new("TextButton")
    QuickMineButton.Name = "QuickMineButton"
    QuickMine
