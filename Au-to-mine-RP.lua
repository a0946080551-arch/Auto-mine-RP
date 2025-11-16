-- Auto-mine[✨] ทหารไทย By-KobeCozydawg
-- Auto Mine + Auto Sell System
-- For Educational Purposes

if _G.ThaiSoldierMine then return end
_G.ThaiSoldierMine = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Auto-mine[✨] ทหารไทย By-KobeCozydawg", "DarkTheme")

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
    MiningRange = 15,
    SearchRange = 200,
    AutoSell = false,
    SellInterval = 60,
    HoldDuration = 2,
    LastSellTime = 0
}

-- Language Texts
local Texts = {
    Thai = {
        MainTitle = "ระบบขุดแร่ & ขายอัตโนมัติ",
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
        NoPickaxe = "❌ กรุณาถือ Pickaxe ก่อน!",
        FoundOre = "📦 พบแร่: ",
        MiningOre = "⛏️ กำลังขุด: ",
        Waiting = "⏳ กำลังรอ...",
        Selling = "💰 กำลังขายของ...",
        AutoSell = "ขายของอัตโนมัติ",
        SellInterval = "ระยะเวลาขาย (วินาที)",
        HoldMining = "⏱️ กดค้าง 2 วินาที",
        HoldProgress = "กำลังกดค้าง: ",
        SellingItems = "ขายของในกระเป๋า..."
    },
    English = {
        MainTitle = "Auto Mine & Sell System",
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
        NoPickaxe = "❌ Please equip Pickaxe first!",
        FoundOre = "📦 Found ore: ",
        MiningOre = "⛏️ Mining: ",
        Waiting = "⏳ Waiting...",
        Selling = "💰 Selling items...",
        AutoSell = "Auto Sell Items",
        SellInterval = "Sell Interval (seconds)",
        HoldMining = "⏱️ Hold for 2 seconds",
        HoldProgress = "Holding: ",
        SellingItems = "Selling backpack items..."
    }
}

-- Get text function
local function T(key)
    return Texts[Config.Language][key] or key
end

-- Create UI
local MainTab = Window:NewTab(T("MainTitle"))
local MainSection = MainTab:NewSection("⚙️ " .. T("MainTitle"))

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
local SellSection = MainTab:NewSection("💰 Auto Sell Settings")

local AutoSellToggle = SellSection:NewToggle(T("AutoSell"), "เปิด/ปิดระบบขายของอัตโนมัติ", function(state)
    Config.AutoSell = state
end)

SellSection:NewSlider(T("SellInterval"), "ระยะเวลาขายของอัตโนมัติ", 300, 30, function(value)
    Config.SellInterval = value
end)

-- Settings Tab
local SettingsTab = Window:NewTab("🔧 Settings")
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

MoveSection:NewSlider("ระยะขุดแร่", "Mining Range", 25, 10, function(value)
    Config.MiningRange = value
end)

MoveSection:NewSlider("ระยะค้นหา", "Search Range", 500, 100, function(value)
    Config.SearchRange = value
end)

-- Status Tab
local StatusTab = Window:NewTab("📊 Status")
local StatusSection = StatusTab:NewSection("ระบบติดตามสถานะ")

local StatusLabel = StatusSection:NewLabel("🔴 " .. T("Waiting"))
local ActionLabel = StatusSection:NewLabel("🛑 " .. T("Stop"))
local OreLabel = StatusSection:NewLabel("📦 ยังไม่พบแร่")
local DistanceLabel = StatusSection:NewLabel("📏 ระยะ: 0")
local HoldLabel = StatusSection:NewLabel("⏱️ " .. T("HoldMining"))
local SellLabel = StatusSection:NewLabel("💰 ขายของ: ปิด")

-- Mining Variables
local CurrentTarget = nil
local MiningConnection = nil
local IsMining = false
local HoldStartTime = 0
local IsHolding = false

-- Utility Functions
function notify(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto-mine[✨]",
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
        if item:IsA("Tool") and (string.find(string.lower(item.Name), "pick") or string.find(string.lower(item.Name), "axe")) then
            return true
        end
    end
    
    -- Check in backpack
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (string.find(string.lower(item.Name), "pick") or string.find(string.lower(item.Name), "axe")) then
                return true
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
            if item:IsA("Tool") and (string.find(string.lower(item.Name), "pick") or string.find(string.lower(item.Name), "axe")) then
                item.Parent = char
                return true
            end
        end
    end
    return false
end

function FindNearestOre()
    local char = Player.Character
    if not char then return nil end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local nearestOre = nil
    local nearestDist = Config.SearchRange
    local oreType = ""
    
    -- Search for ores in workspace
    for oreName, enabled in pairs(Config.TargetOres) do
        if enabled then
            -- Try different possible names
            local possibleNames = {
                oreName,
                oreName .. "Ore",
                "Ore" .. oreName,
                oreName .. " Ore"
            }
            
            for _, name in pairs(possibleNames) do
                local oreFolder = workspace:FindFirstChild(name)
                if oreFolder then
                    for _, ore in pairs(oreFolder:GetChildren()) do
                        if ore:IsA("Part") or ore:IsA("MeshPart") then
                            local dist = (root.Position - ore.Position).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearestOre = ore
                                oreType = oreName
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearestOre, nearestDist, oreType
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
        -- Face the ore
        char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, ore.Position)
        
        -- Start hold mining process
        HoldStartTime = tick()
        IsHolding = true
        
        -- Simulate hold for 2 seconds with progress
        for i = 1, 20 do
            if not Config.Enabled or not IsHolding then break end
            
            local progress = (tick() - HoldStartTime) / Config.HoldDuration
            local progressPercent = math.floor(progress * 100)
            HoldLabel:UpdateLabel("⏱️ " .. T("HoldProgress") .. progressPercent .. "%")
            
            -- Try to mine using click detector (hold simulation)
            local clickDetector = ore:FindFirstChildOfClass("ClickDetector")
            if clickDetector then
                fireclickdetector(clickDetector)
            end
            
            -- Use tool if available (continuous activation for hold)
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            
            wait(0.1) -- 0.1 second intervals for smooth progress
        end
        
        -- Complete mining after hold duration
        if IsHolding then
            -- Final mining action
            local clickDetector = ore:FindFirstChildOfClass("ClickDetector")
            if clickDetector then
                fireclickdetector(clickDetector)
            end
            
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            
            HoldLabel:UpdateLabel("✅ ขุดสำเร็จ!")
            wait(0.5)
        end
        
        IsHolding = false
        HoldLabel:UpdateLabel("⏱️ " .. T("HoldMining"))
    end
    
    IsMining = false
end

-- Auto Sell Function
function AutoSellItems()
    if not Config.AutoSell then return end
    
    local currentTime = tick()
    if currentTime - Config.LastSellTime < Config.SellInterval then return end
    
    ActionLabel:UpdateLabel("💰 " .. T("Selling"))
    SellLabel:UpdateLabel("💰 ขายของ: กำลังขาย...")
    
    -- Find NPC or sell point (adjust based on actual game)
    local sellNPC = workspace:FindFirstChild("SellNPC") or workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("Vendor")
    
    if sellNPC then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Move to sell NPC
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:MoveTo(sellNPC.Position)
                wait(2)
                
                -- Simulate selling interaction
                local clickDetector = sellNPC:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    -- Hold interaction for 2 seconds (similar to mining)
                    HoldStartTime = tick()
                    IsHolding = true
                    
                    for i = 1, 20 do
                        if not IsHolding then break end
                        fireclickdetector(clickDetector)
                        
                        local progress = (tick() - HoldStartTime) / Config.HoldDuration
                        local progressPercent = math.floor(progress * 100)
                        HoldLabel:UpdateLabel("💰 ขายของ: " .. progressPercent .. "%")
                        wait(0.1)
                    end
                    
                    IsHolding = false
                    HoldLabel:UpdateLabel("⏱️ " .. T("HoldMining"))
                end
            end
        end
    end
    
    Config.LastSellTime = currentTime
    SellLabel:UpdateLabel("💰 ขายของ: สำเร็จ!")
    wait(2)
    SellLabel:UpdateLabel("💰 ขายของ: รอบถัดไปใน " .. Config.SellInterval .. " วินาที")
end

-- Main Mining Loop
function MiningLoop()
    if not Config.Enabled then return end
    
    -- Check if player has pickaxe
    if not CheckPickaxe() then
        StatusLabel:UpdateLabel("❌ " .. T("NoPickaxe"))
        Config.Enabled = false
        ToggleBtn:UpdateToggle(false)
        return
    end
    
    -- Auto Sell Check
    AutoSellItems()
    
    local ore, distance, oreType = FindNearestOre()
    
    if ore then
        OreLabel:UpdateLabel("📦 " .. T("FoundOre") .. oreType)
        DistanceLabel:UpdateLabel("📏 ระยะ: " .. math.floor(distance) .. "m")
        
        if distance <= Config.MiningRange then
            SimulateHoldMining(ore, oreType)
        else
            MoveToPosition(ore.Position)
        end
    else
        ActionLabel:UpdateLabel("🔍 " .. T("Searching"))
        OreLabel:UpdateLabel("📦 ยังไม่พบแร่")
        DistanceLabel:UpdateLabel("📏 ระยะ: 0m")
        
        -- Random exploration when no ore found
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local randomPos = char.HumanoidRootPart.Position + Vector3.new(
                math.random(-80, 80),
                0,
                math.random(-80, 80)
            )
            MoveToPosition(randomPos)
        end
    end
end

function StartMining()
    if MiningConnection then
        MiningConnection:Disconnect()
    end
    
    StatusLabel:UpdateLabel("🟢 กำลังทำงาน")
    ActionLabel:UpdateLabel("🚀 " .. T("Start"))
    SellLabel:UpdateLabel("💰 ขายของ: " .. (Config.AutoSell and "เปิด" or "ปิด"))
    
    MiningConnection = RunService.Heartbeat:Connect(function()
        if Config.Enabled then
            MiningLoop()
        end
    end)
end

function StopMining()
    Config.Enabled = false
    IsHolding = false
    
    if MiningConnection then
        MiningConnection:Disconnect()
        MiningConnection = nil
    end
    
    -- Stop character movement
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:MoveTo(char.HumanoidRootPart.Position)
    end
    
    StatusLabel:UpdateLabel("🔴 หยุดทำงาน")
    ActionLabel:UpdateLabel("🛑 " .. T("Stop"))
    OreLabel:UpdateLabel("📦 ยังไม่พบแร่")
    DistanceLabel:UpdateLabel("📏 ระยะ: 0m")
    HoldLabel:UpdateLabel("⏱️ " .. T("HoldMining"))
    SellLabel:UpdateLabel("💰 ขายของ: ปิด")
end

function UpdateUI()
    if Config.Enabled then
        StatusLabel:UpdateLabel("🟢 " .. T("Mining"))
    else
        StatusLabel:UpdateLabel("🔴 " .. T("Stop"))
    end
end

-- Anti-AFK System
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Character Added Event
Player.CharacterAdded:Connect(function(char)
    wait(3) -- Wait for character to load completely
    updateHumanoid()
    if Config.Enabled then
        wait(2)
        StartMining()
    end
end)

-- Initial setup
if Player.Character then
    updateHumanoid()
end

-- Success notification
notify("✅ โหลดสคริปต์ Auto-mine[✨] สำเร็จ!\nโดย KobeCozydawg")

print("🎯 Auto-mine[✨] ทหารไทย By-KobeCozydawg")
print("📌 Available Ores: Coal, IronOre, CopperOre")
print("⏱️ Hold Mining: 2 seconds per ore")
print("💰 Auto Sell: " .. (Config.AutoSell and "Enabled" or "Disabled"))
print("⚠️ Remember to equip Pickaxe before starting!")
