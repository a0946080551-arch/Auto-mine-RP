-- Smart Auto Mine System for [✨] ทหารไทย
-- Fixed Version with Better UI Drag
-- By KobeCozydawg

if _G.ThaiSoldierMine then return end
_G.ThaiSoldierMine = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Smart Auto Mine System", "DarkTheme")

-- Enhanced UI Drag Function (สามารถลากได้จากทุกส่วนของเมนู)
local function MakeMainWindowDraggable()
    for _, obj in pairs(CoreGui:GetChildren()) do
        if obj:IsA("ScreenGui") and obj.Name == "KavoLibrary" then
            local mainFrame = obj:FindFirstChild("Main")
            if mainFrame then
                -- ทำให้ทั้งหน้าต่างสามารถลากได้
                local dragging = false
                local dragInput, dragStart, startPos

                local function updateInput(input)
                    local delta = input.Position - dragStart
                    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end

                -- ตรวจจับการคลิกที่หน้าต่างหลัก
                mainFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

                mainFrame.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        dragInput = input
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input == dragInput and dragging then
                        updateInput(input)
                    end
                end)

                -- ทำให้ทุกส่วนในเมนูสามารถลากหน้าต่างได้ (ยกเว้นปุ่มและช่องใส่ข้อมูล)
                local function makeDescendantsDraggable(parent)
                    for _, child in pairs(parent:GetDescendants()) do
                        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("ImageLabel") then
                            if not child:FindFirstChildWhichIsA("TextButton") and not child:FindFirstChildWhichIsA("TextBox") then
                                child.InputBegan:Connect(function(input)
                                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

                                child.InputChanged:Connect(function(input)
                                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                                        dragInput = input
                                    end
                                end)
                            end
                        end
                    end
                end

                makeDescendantsDraggable(mainFrame)
            end
        end
    end
end

-- Configuration
local Config = {
    Enabled = false,
    Language = "Thai",
    TargetOres = {
        Coal = true,
        IronOre = true,
        CopperOre = true
    },
    WalkSpeed = 25,
    JumpPower = 50,
    MiningRange = 10,
    SearchRange = 300,
    AutoSell = false,
    SellInterval = 60,
    HoldDuration = 2,
    LastSellTime = 0
}

-- Manual Ore Positions (จะอัพเดทอัตโนมัติ)
local ManualOrePositions = {}

-- Language Texts
local Texts = {
    Thai = {
        MainTitle = "ระบบขุดแร่อัตโนมัติ",
        Toggle = "เปิด/ปิด Auto Mine",
        Language = "ภาษา",
        OreSelection = "เลือกแร่ที่ต้องการขุด",
        SelectAll = "เลือกทั้งหมด",
        DeselectAll = "ยกเลิกทั้งหมด",
        SmartWalk = "การตั้งค่าการเดิน",
        Start = "เริ่มทำงาน",
        Stop = "หยุดทำงาน",
        Status = "สถานะ: พร้อมทำงาน",
        Mining = "กำลังขุดแร่...",
        Searching = "กำลังค้นหาแร่...",
        Walking = "กำลังเดินไปหาแร่...",
        NoPickaxe = "กรุณาถือ Pickaxe ก่อน!",
        FoundOre = "พบแร่: ",
        MiningOre = "กำลังขุด: ",
        Waiting = "กำลังรอ...",
        Selling = "กำลังขายของ...",
        AutoSell = "ขายของอัตโนมัติ",
        SellInterval = "ระยะเวลาขาย (วินาที)",
        HoldMining = "กดค้าง 2 วินาที",
        HoldProgress = "กำลังกดค้าง: ",
        SellingItems = "ขายของในกระเป๋า...",
        ToggleUI = "แสดง/ซ่อน เมนู",
        DragUI = "ลากที่ว่างเพื่อย้ายเมนู",
        FindOres = "ค้นหาแร่อัตโนมัติ",
        ScanOres = "สแกนหาแร่ในเกม"
    },
    English = {
        MainTitle = "Auto Mine System",
        Toggle = "Toggle Auto Mine",
        Language = "Language",
        OreSelection = "Select Ores to Mine",
        SelectAll = "Select All",
        DeselectAll = "Deselect All",
        SmartWalk = "Movement Settings",
        Start = "Start",
        Stop = "Stop",
        Status = "Status: Ready",
        Mining = "Mining ore...",
        Searching = "Searching for ores...",
        Walking = "Walking to ore...",
        NoPickaxe = "Please equip Pickaxe first!",
        FoundOre = "Found ore: ",
        MiningOre = "Mining: ",
        Waiting = "Waiting...",
        Selling = "Selling items...",
        AutoSell = "Auto Sell Items",
        SellInterval = "Sell Interval (seconds)",
        HoldMining = "Hold for 2 seconds",
        HoldProgress = "Holding: ",
        SellingItems = "Selling backpack items...",
        ToggleUI = "Show/Hide Menu",
        DragUI = "Drag empty space to move menu",
        FindOres = "Find Ores Automatically",
        ScanOres = "Scan for ores in game"
    }
}

-- Get text function
local function T(key)
    return Texts[Config.Language][key] or key
end

-- Create UI
local MainTab = Window:NewTab(T("MainTitle"))
local MainSection = MainTab:NewSection("Main Settings")

-- Toggle UI Button
MainSection:NewButton(T("ToggleUI"), T("DragUI"), function()
    for _, obj in pairs(CoreGui:GetChildren()) do
        if obj:IsA("ScreenGui") and obj.Name == "KavoLibrary" then
            obj.Enabled = not obj.Enabled
        end
    end
end)

-- Auto Find Ores Button
MainSection:NewButton(T("FindOres"), T("ScanOres"), function()
    FindAllOresInGame()
end)

local ToggleBtn = MainSection:NewToggle(T("Toggle"), "เปิด/ปิดระบบขุดแร่อัตโนมัติ", function(state)
    Config.Enabled = state
    if state then
        if CheckPickaxe() then
            StartMining()
        else
            Config.Enabled = false
            ToggleBtn:UpdateToggle(false)
            notify(T("NoPickaxe"))
        end
    else
        StopMining()
    end
end)

MainSection:NewDropdown(T("Language"), "เลือกภาษา", {"Thai", "English"}, function(selected)
    Config.Language = selected
    UpdateUI()
end)

-- Auto Sell Settings
local SellSection = MainTab:NewSection("Auto Sell Settings")

local AutoSellToggle = SellSection:NewToggle(T("AutoSell"), "เปิด/ปิดระบบขายของอัตโนมัติ", function(state)
    Config.AutoSell = state
end)

SellSection:NewSlider(T("SellInterval"), "ระยะเวลาขายของอัตโนมัติ", 300, 30, function(value)
    Config.SellInterval = value
end)

-- Settings Tab
local SettingsTab = Window:NewTab("Settings")
local OreSection = SettingsTab:NewSection(T("OreSelection"))

local OreToggles = {
    Coal = OreSection:NewToggle("ถ่าน (Coal)", "ขุดแร่ถ่าน", function(state) Config.TargetOres.Coal = state end),
    IronOre = OreSection:NewToggle("แร่เหล็ก (IronOre)", "ขุดแร่เหล็ก", function(state) Config.TargetOres.IronOre = state end),
    CopperOre = OreSection:NewToggle("แร่ทองแดง (CopperOre)", "ขุดแร่ทองแดง", function(state) Config.TargetOres.CopperOre = state end)
}

OreSection:NewButton(T("SelectAll"), "เลือกแร่ทั้งหมด", function()
    for ore, toggle in pairs(OreToggles) do
        Config.TargetOres[ore] = true
        toggle:UpdateToggle(true)
    end
end)

OreSection:NewButton(T("DeselectAll"), "ยกเลิกแร่ทั้งหมด", function()
    for ore, toggle in pairs(OreToggles) do
        Config.TargetOres[ore] = false
        toggle:UpdateToggle(false)
    end
end)

-- Movement Settings
local MoveSection = SettingsTab:NewSection(T("SmartWalk"))
MoveSection:NewSlider("ความเร็วเดิน", "Walk Speed", 50, 16, function(value)
    Config.WalkSpeed = value
    updateHumanoid()
end)

MoveSection:NewSlider("พลังกระโดด", "Jump Power", 100, 50, function(value)
    Config.JumpPower = value
    updateHumanoid()
end)

MoveSection:NewSlider("ระยะขุดแร่", "Mining Range", 25, 5, function(value)
    Config.MiningRange = value
end)

MoveSection:NewSlider("ระยะค้นหา", "Search Range", 500, 50, function(value)
    Config.SearchRange = value
end)

-- Status Tab
local StatusTab = Window:NewTab("Status")
local StatusSection = StatusTab:NewSection("System Status")

local StatusLabel = StatusSection:NewLabel("🔴 " .. T("Waiting"))
local ActionLabel = StatusSection:NewLabel("🛑 " .. T("Stop"))
local OreLabel = StatusSection:NewLabel("📦 ยังไม่พบแร่")
local DistanceLabel = StatusSection:NewLabel("📏 ระยะ: 0")
local HoldLabel = StatusSection:NewLabel("⏱️ " .. T("HoldMining"))
local SellLabel = StatusSection:NewLabel("💰 ขายของ: ปิด")
local FoundOresLabel = StatusSection:NewLabel("🔍 พบแร่: 0 ตำแหน่ง")

-- Apply enhanced drag functionality
wait(1)
MakeMainWindowDraggable()

-- Mining Variables
local CurrentTarget = nil
local MiningConnection = nil
local IsMining = false
local HoldStartTime = 0
local IsHolding = false

-- Utility Functions
function notify(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Mine",
        Text = message,
        Duration = 3
    })
end

function updateHumanoid()
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Config.WalkSpeed
        char.Humanoid.JumpPower = Config.JumpPower
    end
end

function CheckPickaxe()
    local char = Player.Character
    if not char then return false end
    
    -- Check in character
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local nameLower = string.lower(item.Name)
            if string.find(nameLower, "pick") or string.find(nameLower, "axe") or string.find(nameLower, "hammer") or string.find(nameLower, "ขุด") then
                return true
            end
        end
    end
    
    -- Check in backpack
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local nameLower = string.lower(item.Name)
                if string.find(nameLower, "pick") or string.find(nameLower, "axe") or string.find(nameLower, "hammer") or string.find(nameLower, "ขุด") then
                    return true
                end
            end
        end
    end
    
    return false
end

function EquipPickaxe()
    local char = Player.Character
    if not char then return false end
    
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local nameLower = string.lower(item.Name)
                if string.find(nameLower, "pick") or string.find(nameLower, "axe") or string.find(nameLower, "hammer") or string.find(nameLower, "ขุด") then
                    item.Parent = char
                    return true
                end
            end
        end
    end
    return false
end

-- Function to automatically find all ores in the game
function FindAllOresInGame()
    print("🔍 กำลังค้นหาแร่ในเกม...")
    ManualOrePositions = {}
    
    local foundCount = 0
    
    -- Search in workspace
    for i, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            local displayName = obj.Name
            
            -- Check for ore names
            local isOre = false
            local oreType = "Unknown"
            
            if string.find(name, "coal") or string.find(name, "ถ่าน") then
                isOre = true
                oreType = "Coal"
            elseif string.find(name, "iron") or string.find(name, "เหล็ก") then
                isOre = true
                oreType = "IronOre"
            elseif string.find(name, "copper") or string.find(name, "ทองแดง") then
                isOre = true
                oreType = "CopperOre"
            elseif string.find(name, "ore") or string.find(name, "แร่") then
                isOre = true
                oreType = "Generic"
            end
            
            if isOre then
                local position = obj:IsA("Model") and (obj:GetPivot().Position) or obj.Position
                
                table.insert(ManualOrePositions, {
                    Position = position,
                    Type = oreType,
                    Name = displayName,
                    Object = obj
                })
                
                foundCount = foundCount + 1
                print("📦 พบแร่: " .. displayName .. " (" .. oreType .. ") | ตำแหน่ง: " .. tostring(position))
            end
        end
    end
    
    FoundOresLabel:UpdateLabel("🔍 พบแร่: " .. foundCount .. " ตำแหน่ง")
    notify("✅ พบแร่ " .. foundCount .. " ตำแหน่งในเกม")
    print("✅ ค้นหาแร่เสร็จสิ้น: พบ " .. foundCount .. " ตำแหน่ง")
    
    return foundCount
end

function FindNearestOre()
    local char = Player.Character
    if not char then return nil end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local nearestOre = nil
    local nearestDist = Config.SearchRange
    local oreType = "Unknown"
    local nearestPosition = nil
    
    -- Use manually found positions first
    for _, oreData in pairs(ManualOrePositions) do
        if Config.TargetOres[oreData.Type] or oreData.Type == "Generic" then
            local dist = (root.Position - oreData.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestOre = oreData.Object
                oreType = oreData.Type
                nearestPosition = oreData.Position
            end
        end
    end
    
    -- If no manual positions found, try automatic detection
    if not nearestOre then
        for oreName, enabled in pairs(Config.TargetOres) do
            if enabled then
                -- Search in common locations
                local searchLocations = {
                    workspace,
                    workspace:FindFirstChild("Ores"),
                    workspace:FindFirstChild("Mines"),
                    workspace:FindFirstChild("Resources"),
                    workspace:FindFirstChild("Map")
                }
                
                for _, location in pairs(searchLocations) do
                    if location then
                        local oreFolder = location:FindFirstChild(oreName) or 
                                        location:FindFirstChild(oreName .. "Ore") or
                                        location:FindFirstChild("Ore" .. oreName)
                        
                        if oreFolder then
                            for _, ore in pairs(oreFolder:GetChildren()) do
                                if ore:IsA("Part") or ore:IsA("MeshPart") or ore:IsA("Model") then
                                    local orePosition = ore:IsA("Model") and (ore:GetPivot().Position) or ore.Position
                                    local dist = (root.Position - orePosition).Magnitude
                                    if dist < nearestDist then
                                        nearestDist = dist
                                        nearestOre = ore
                                        oreType = oreName
                                        nearestPosition = orePosition
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearestOre, nearestDist, oreType, nearestPosition
end

function MoveToPosition(position)
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    local distance = (root.Position - position).Magnitude
    
    if distance > Config.MiningRange then
        humanoid:MoveTo(position)
        ActionLabel:UpdateLabel("🚶 " .. T("Walking") .. " (" .. math.floor(distance) .. "m)")
    else
        humanoid:MoveTo(root.Position)
        ActionLabel:UpdateLabel("⛏️ " .. T("Mining"))
    end
end

-- Function to simulate hold for 2 seconds
function SimulateHoldMining(ore, oreType)
    if IsMining then return end
    IsMining = true
    
    -- Equip pickaxe first
    if not EquipPickaxe() then
        ActionLabel:UpdateLabel("❌ " .. T("NoPickaxe"))
        IsMining = false
        return
    end
    
    ActionLabel:UpdateLabel("⛏️ " .. T("MiningOre") .. oreType)
    
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Get ore position
        local orePosition = ore:IsA("Model") and (ore:GetPivot().Position) or ore.Position
        
        -- Face the ore
        char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, orePosition)
        
        -- Start hold mining process
        HoldStartTime = tick()
        IsHolding = true
        
        -- Simulate hold for 2 seconds with progress
        for i = 1, 20 do
            if not Config.Enabled or not IsHolding then break end
            
            local progress = (tick() - HoldStartTime) / Config.HoldDuration
            local progressPercent = math.floor(progress * 100)
            HoldLabel:UpdateLabel("⏱️ " .. T("HoldProgress") .. progressPercent .. "%")
            
            -- Try to mine using click detector
            local clickDetector = ore:FindFirstChildOfClass("ClickDetector")
            if not clickDetector then
                for _, child in pairs(ore:GetDescendants()) do
                    if child:IsA("ClickDetector") then
                        clickDetector = child
                        break
                    end
                end
            end
            
            if clickDetector then
                fireclickdetector(clickDetector)
            end
            
            -- Use tool
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            
            wait(0.1)
        end
     
