-- ThaiSoldier Auto Mine V3 - Mobile Touch Compatible
-- Created by KobeCozydawg
-- เพิ่มระบบการขุดแร่/ขายแร่สำหรับมือถือ

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TouchEnabled = UserInputService.TouchEnabled

-- ตรวจสอบอุปกรณ์
local isMobile = TouchEnabled
print("อุปกรณ์: " .. (isMobile and "มือถือ" or "คอมพิวเตอร์"))

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaiSoldierMineGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, isMobile and 400 or 350, 0, isMobile and 520 or 270)
MainFrame.Position = UDim2.new(0.5, isMobile and -200 or -175, 0.5, isMobile and -260 or -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, isMobile and 40 or 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Parent = MainFrame

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ThaiSoldier Auto Mine V3" .. (isMobile and " - Mobile" : "")
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = isMobile and 16 or 14
TitleText.Parent = TitleBar

-- Creator Credit
local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(0.3, 0, 1, 0)
CreatorLabel.Position = UDim2.new(0.7, 0, 0, 0)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "by KobeCozydawg"
CreatorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CreatorLabel.Font = Enum.Font.Gotham
CreatorLabel.TextSize = isMobile and 12 or 10
CreatorLabel.TextXAlignment = Enum.TextXAlignment.Right
CreatorLabel.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, isMobile and 40 or 30, 0, isMobile and 40 or 30)
CloseButton.Position = UDim2.new(1, isMobile and -40 or -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = isMobile and 18 or 14
CloseButton.Parent = TitleBar

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, isMobile and 120 or 100, 0, isMobile and 40 or 30)
ToggleButton.Position = UDim2.new(0, 10, 1, isMobile and -50 or -40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
ToggleButton.Text = "Toggle GUI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = isMobile and 14 or 12
ToggleButton.Parent = MainFrame

-- Ore Positions Database
local orePositions = {
    {name = "เหล็กก้อนที่1", type = "Iron", position = Vector3.new(-387.63, 4.05, -74.19)},
    {name = "ทองแดงก้อนที่1", type = "Copper", position = Vector3.new(-399.82, 4.83, -74.84)},
    {name = "เหล็กก้อนที่2", type = "Iron", position = Vector3.new(-368.52, 8.90, -73.32)},
    {name = "ถ่านก้อนที่1", type = "Coal", position = Vector3.new(-390.16, -0.56, -57.80)},
    {name = "ทองแดงก้อนที่2", type = "Copper", position = Vector3.new(-406.71, -8.37, -48.87)},
    {name = "ถ่านก้อนที่2", type = "Coal", position = Vector3.new(-403.38, -13.62, -37.95)},
    {name = "ถ่านก้อนที่3", type = "Coal", position = Vector3.new(-387.06, -14.13, -39.31)},
    {name = "ถ่านก้อนที่4", type = "Coal", position = Vector3.new(-388.75, -7.68, -20.59)},
    {name = "เหล็กก้อนที่3", type = "Iron", position = Vector3.new(-391.27, -7.48, -10.49)},
    {name = "เพชรก้อนที่1", type = "Diamond", position = Vector3.new(-400.27, -7.77, -12.55)},
    {name = "ทองแดงก้อนที่3", type = "Copper", position = Vector3.new(-386.51, -7.30, -21.80)},
    {name = "เหล็กก้อนที่4", type = "Iron", position = Vector3.new(-416.84, -14.22, -30.66)},
    {name = "ถ่านก้อนที่5", type = "Coal", position = Vector3.new(-408.36, -13.23, -17.06)},
    {name = "เหล็กก้อนที่5", type = "Iron", position = Vector3.new(-416.72, -14.20, 5.16)},
    {name = "ถ่านก้อนที่6", type = "Coal", position = Vector3.new(-432.56, -7.92, -32.08)},
    {name = "ถ่านก้อนที่7", type = "Coal", position = Vector3.new(-437.49, -7.75, 3.10)},
    {name = "ถ่านก้อนที่8", type = "Coal", position = Vector3.new(-430.85, -7.25, -9.49)}
}

-- ตำแหน่งขายแร่ (ตัวอย่าง)
local sellPositions = {
    {name = "ร้านขายแร่ A", position = Vector3.new(-350, 5, -50)},
    {name = "ร้านขายแร่ B", position = Vector3.new(-360, 5, -40)}
}

-- Movement System
local isMoving = false
local isMining = false
local isSelling = false

-- ฟังก์ชันเคลื่อนที่ที่ปลอดภัย
local function safeMoveTo(position)
    local character = Player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- ใช้ Humanoid.MoveTo สำหรับการเคลื่อนที่ที่ปลอดภัย
    humanoid:MoveTo(position)
    return true
end

-- ฟังก์ชันขุดแร่ (ปรับให้ใช้กับมือถือ)
local function mineOre(oreName, oreType)
    print("กำลังขุด: " .. oreName .. " (" .. oreType .. ")")
    
    -- สำหรับมือถือ: จำลองการกดปุ่มขุด
    if isMobile then
        -- ใส่โค้ดการขุดแร่สำหรับมือถือที่นี่
        -- เช่น การส่งเหตุการณ์การแตะหรือกดปุ่มขุด
        local virtualInput = game:GetService("VirtualInputManager")
        -- ตัวอย่างการส่งการกด (ปรับตามเกม)
        -- virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    end
    
    wait(2) -- จำลองเวลาในการขุด
    print("ขุด " .. oreName .. " สำเร็จ!")
    return true
end

-- ฟังก์ชันขายแร่ (ปรับให้ใช้กับมือถือ)
local function sellOres()
    print("กำลังขายแร่...")
    
    -- สำหรับมือถือ: จำลองการกดปุ่มขาย
    if isMobile then
        -- ใส่โค้ดการขายแร่สำหรับมือถือที่นี่
        -- เช่น การส่งเหตุการณ์การแตะหรือกดปุ่มขาย
        local virtualInput = game:GetService("VirtualInputManager")
        -- ตัวอย่างการส่งการกด (ปรับตามเกม)
        -- virtualInput:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
    end
    
    wait(2) -- จำลองเวลาในการขาย
    print("ขายแร่สำเร็จ!")
    return true
end

-- Status Display
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, isMobile and 60 or 40)
StatusLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "พร้อมทำงาน" .. (isMobile and "\nโหมดมือถือ" : "")
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = isMobile and 14 or 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Auto Mine Button
local AutoMineButton = Instance.new("TextButton")
AutoMineButton.Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
AutoMineButton.Position = UDim2.new(0.05, 0, 0.25, 0)
AutoMineButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
AutoMineButton.Text = "เริ่มขุดอัตโนมัติ"
AutoMineButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoMineButton.Font = Enum.Font.GothamBold
AutoMineButton.TextSize = isMobile and 16 or 14
AutoMineButton.Parent = MainFrame

-- Auto Sell Button
local AutoSellButton = Instance.new("TextButton")
AutoSellButton.Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
AutoSellButton.Position = UDim2.new(0.05, 0, 0.35, 0)
AutoSellButton.BackgroundColor3 = Color3.fromRGB(160, 120, 80)
AutoSellButton.Text = "ขายแร่อัตโนมัติ"
AutoSellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoSellButton.Font = Enum.Font.GothamBold
AutoSellButton.TextSize = isMobile and 16 or 14
AutoSellButton.Parent = MainFrame

-- Stop Button
local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.9, 0, 0, isMobile and 40 or 30)
StopButton.Position = UDim2.new(0.05, 0, 0.45, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(160, 80, 80)
StopButton.Text = "หยุดทั้งหมด"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.Gotham
StopButton.TextSize = isMobile and 14 or 12
StopButton.Visible = false
StopButton.Parent = MainFrame

-- Progress Label
local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(0.9, 0, 0, isMobile and 40 or 30)
ProgressLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "ความคืบหน้า: 0/" .. #orePositions
ProgressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ProgressLabel.Font = Enum.Font.Gotham
ProgressLabel.TextSize = isMobile and 13 or 11
ProgressLabel.Parent = MainFrame

-- Touch Controls for Mobile (ปุ่มกดข้างสำหรับมือถือ)
local TouchControlsFrame = Instance.new("Frame")
TouchControlsFrame.Size = UDim2.new(0.9, 0, 0, isMobile and 120 or 0)
TouchControlsFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
TouchControlsFrame.BackgroundTransparency = 1
TouchControlsFrame.Visible = isMobile
TouchControlsFrame.Parent = MainFrame

if isMobile then
    -- ปุ่มขุดด่วน
    local QuickMineButton = Instance.new("TextButton")
    QuickMineButton.Size = UDim2.new(0.45, 0, 0, 50)
    QuickMineButton.Position = UDim2.new(0, 0, 0, 0)
    QuickMineButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    QuickMineButton.Text = "⛏️ ขุดด่วน"
    QuickMineButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    QuickMineButton.Font = Enum.Font.GothamBold
    QuickMineButton.TextSize = 16
    QuickMineButton.Parent = TouchControlsFrame
    
    -- ปุ่มขายด่วน
    local QuickSellButton = Instance.new("TextButton")
    QuickSellButton.Size = UDim2.new(0.45, 0, 0, 50)
    QuickSellButton.Position = UDim2.new(0.55, 0, 0, 0)
    QuickSellButton.BackgroundColor3 = Color3.fromRGB(160, 120, 80)
    QuickSellButton.Text = "💰 ขายด่วน"
    QuickSellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    QuickSellButton.Font = Enum.Font.GothamBold
    QuickSellButton.TextSize = 16
    QuickSellButton.Parent = TouchControlsFrame
    
    -- ปุ่มหยุดฉุกเฉิน
    local EmergencyStop = Instance.new("TextButton")
    EmergencyStop.Size = UDim2.new(1, 0, 0, 50)
    EmergencyStop.Position = UDim2.new(0, 0, 0.6, 0)
    EmergencyStop.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    EmergencyStop.Text = "🛑 หยุดฉุกเฉิน"
    EmergencyStop.TextColor3 = Color3.fromRGB(255, 255, 255)
    EmergencyStop.Font = Enum.Font.GothamBold
    EmergencyStop.TextSize = 16
    EmergencyStop.Parent = TouchControlsFrame
    
    -- ฟังก์ชันสำหรับปุ่มมือถือ
    QuickMineButton.MouseButton1Click:Connect(function()
        if isMining then return end
        StatusLabel.Text = "กำลังขุดแร่ด่วน..."
        mineOre("แร่ด่วน", "ทั่วไป")
        StatusLabel.Text = "ขุดแร่ด่วนสำเร็จ!"
    end)
    
    QuickSellButton.MouseButton1Click:Connect(function()
        if isSelling then return end
        StatusLabel.Text = "กำลังขายแร่ด่วน..."
        sellOres()
        StatusLabel.Text = "ขายแร่ด่วนสำเร็จ!"
    end)
    
    EmergencyStop.MouseButton1Click:Connect(function()
        isMining = false
        isSelling = false
        AutoMineButton.Visible = true
        AutoSellButton.Visible = true
        StopButton.Visible = false
        StatusLabel.Text = "หยุดฉุกเฉินแล้ว!"
    end)
end

-- Footer Credit
local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(0.9, 0, 0, 20)
FooterLabel.Position = UDim2.new(0.05, 0, 0.95, 0)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text = "Created by KobeCozydawg"
FooterLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextSize = 10
FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
FooterLabel.Parent = MainFrame

-- Auto Mining Function
AutoMineButton.MouseButton1Click:Connect(function()
    if isMining then return end
    
    isMining = true
    AutoMineButton.Visible = false
    AutoSellButton.Visible = false
    StopButton.Visible = true
    
    local currentIndex = 1
    
    spawn(function()
        while isMining and currentIndex <= #orePositions do
            local ore = orePositions[currentIndex]
            
            StatusLabel.Text = "กำลังไปยัง: " .. ore.name .. "\n(" .. currentIndex .. "/" .. #orePositions .. ")"
            ProgressLabel.Text = "ความคืบหน้า: " .. currentIndex .. "/" .. #orePositions
            
            -- เคลื่อนที่ไปยังตำแหน่งแร่
            if safeMoveTo(ore.position) then
                -- รอให้เคลื่อนที่ถึง
                wait(3)
                
                -- ขุดแร่
                mineOre(ore.name, ore.type)
                
                currentIndex = currentIndex + 1
            else
                StatusLabel.Text = "ไม่สามารถเคลื่อนที่ได้\nข้าม: " .. ore.name
                currentIndex = currentIndex + 1
            end
            
            wait(1) -- รอก่อนแร่ถัดไป
        end
        
        -- จบการทำงาน
        isMining = false
        AutoMineButton.Visible = true
        AutoSellButton.Visible = true
        StopButton.Visible = false
        StatusLabel.Text = "ขุดแร่เสร็จสิ้น!"
        ProgressLabel.Text = "ความคืบหน้า: " .. #orePositions .. "/" .. #orePositions
    end)
end)

-- Auto Sell Function
AutoSellButton.MouseButton1Click:Connect(function()
    if isSelling then return end
    
    isSelling = true
    AutoMineButton.Visible = false
    AutoSellButton.Visible = false
    StopButton.Visible = true
    
    StatusLabel.Text = "กำลังไปขายแร่..."
    
    spawn(function()
        -- ไปยังร้านขายแร่
        if #sellPositions > 0 then
            local sellSpot = sellPositions[1] -- ใช้ร้านแรก
            
            if safeMoveTo(sellSpot.position) then
                wait(3)
                sellOres()
                StatusLabel.Text = "ขายแร่สำเร็จ!"
            else
                StatusLabel.Text = "ไม่สามารถไปร้านขายแร่ได้"
            end
        else
            StatusLabel.Text = "ไม่มีตำแหน่งร้านขายแร่"
        end
        
        -- จบการทำงาน
        isSelling = false
        AutoMineButton.Visible = true
        AutoSellButton.Visible = true
        StopButton.Visible = false
    end)
end)

-- Stop Function
StopButton.MouseButton1Click:Connect(function()
    isMining = false
    isSelling = false
    AutoMineButton.Visible = true
    AutoSellButton.Visible = true
    StopButton.Visible = false
    StatusLabel.Text = "หยุดการทำงานแล้ว"
end)

-- GUI Visibility Control
local isGUIVisible = true

CloseButton.MouseButton1Click:Connect(function()
    isGUIVisible = false
    MainFrame.Visible = false
end)

ToggleButton.MouseButton1Click:Connect(function()
    isGUIVisible = not isGUIVisible
    MainFrame.Visible = isGUIVisible
end)

-- Make GUI draggable (สำหรับมือถือใช้การกดค้าง)
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- ปรับปรุงการแสดงผลสำหรับมือถือ
if isMobile then
    -- ทำให้ปุ่มใหญ่ขึ้นและมีระยะห่างเหมาะสม
    for _, button in pairs(MainFrame:GetChildren()) do
        if button:IsA("TextButton") then
            button.AutoButtonColor = false
            local originalColor = button.BackgroundColor3
            button.MouseButton1Down:Connect(function()
                button.BackgroundColor3 = originalColor * 0.8
            end)
            button.MouseButton1Up:Connect(function()
                button.BackgroundColor3 = originalColor
            end)
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = originalColor
            end)
        end
    end
end

print("===========================================")
print("ThaiSoldier Auto Mine V3 โหลดสำเร็จ!")
print("Created by KobeCozydawg")
print("===========================================")
print("อุปกรณ์: " .. (isMobile and "มือถือ" or "คอมพิวเตอร์"))
print("พบตำแหน่งแร่: " .. #orePositions .. " ตำแหน่ง")
if isMobile then
    print("โหมดมือถือ: เปิดใช้งานปุ่มกดข้างแล้ว")
end
print("===========================================")
