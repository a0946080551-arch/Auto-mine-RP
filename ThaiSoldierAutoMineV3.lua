-- Infinite Yield FE v6.3.4 - Enhanced Mining System
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MainGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.Parent = MainFrame

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Mining System v2.0"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Toggle Button (Near basket icon)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 1, -40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
ToggleButton.Text = "Toggle GUI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 12
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

-- Mining System
local isMining = false
local currentOreIndex = 1

-- Function to teleport to ore position
local function teleportToOre(position)
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

-- Function to simulate mining
local function mineOre(oreName, oreType)
    print("กำลังขุด: " .. oreName .. " (" .. oreType .. ")")
    -- ใส่การขุดแร่จริงๆ ที่นี่
    wait(2) -- จำลองเวลาในการขุด
    print("ขุด " .. oreName .. " สำเร็จ!")
end

-- Auto Mine All Button
local AutoMineAllButton = Instance.new("TextButton")
AutoMineAllButton.Size = UDim2.new(0, 140, 0, 35)
AutoMineAllButton.Position = UDim2.new(0.5, -70, 0.15, 0)
AutoMineAllButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
AutoMineAllButton.Text = "เริ่มขุดทั้งหมดอัตโนมัติ"
AutoMineAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoMineAllButton.Font = Enum.Font.GothamBold
AutoMineAllButton.TextSize = 12
AutoMineAllButton.Parent = MainFrame

-- Stop Mining Button
local StopMiningButton = Instance.new("TextButton")
StopMiningButton.Size = UDim2.new(0, 120, 0, 30)
StopMiningButton.Position = UDim2.new(0.5, -60, 0.3, 0)
StopMiningButton.BackgroundColor3 = Color3.fromRGB(160, 80, 80)
StopMiningButton.Text = "หยุดขุด"
StopMiningButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopMiningButton.Font = Enum.Font.Gotham
StopMiningButton.TextSize = 12
StopMiningButton.Visible = false
StopMiningButton.Parent = MainFrame

-- Status Display
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
StatusLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "พร้อมทำงาน"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Ore Selection Buttons Container
local OreScrollFrame = Instance.new("ScrollingFrame")
OreScrollFrame.Size = UDim2.new(0.9, 0, 0, 100)
OreScrollFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
OreScrollFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
OreScrollFrame.BorderSizePixel = 0
OreScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #orePositions * 25)
OreScrollFrame.Parent = MainFrame

-- Create ore selection buttons
for i, ore in ipairs(orePositions) do
    local OreButton = Instance.new("TextButton")
    OreButton.Size = UDim2.new(0.95, 0, 0, 20)
    OreButton.Position = UDim2.new(0.025, 0, 0, (i-1) * 25)
    OreButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    OreButton.Text = ore.name .. " (" .. ore.type .. ")"
    OreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OreButton.Font = Enum.Font.Gotham
    OreButton.TextSize = 10
    OreButton.TextXAlignment = Enum.TextXAlignment.Left
    OreButton.Parent = OreScrollFrame
    
    OreButton.MouseButton1Click:Connect(function()
        if teleportToOre(ore.position) then
            StatusLabel.Text = "เดินทางไป: " .. ore.name
            mineOre(ore.name, ore.type)
        end
    end)
end

-- Auto Mining Function
AutoMineAllButton.MouseButton1Click:Connect(function()
    if isMining then return end
    
    isMining = true
    AutoMineAllButton.Visible = false
    StopMiningButton.Visible = true
    currentOreIndex = 1
    
    -- Start auto mining loop
    spawn(function()
        while isMining and currentOreIndex <= #orePositions do
            local ore = orePositions[currentOreIndex]
            
            StatusLabel.Text = "กำลังไปยัง: " .. ore.name .. " (" .. currentOreIndex .. "/" .. #orePositions .. ")"
            
            -- Teleport to ore
            if teleportToOre(ore.position) then
                wait(1) -- รอให้ถึงตำแหน่ง
                
                -- Mine the ore
                mineOre(ore.name, ore.type)
                
                -- Move to next ore
                currentOreIndex = currentOreIndex + 1
                wait(1) -- รอก่อนไปแร่ถัดไป
            else
                StatusLabel.Text = "ไม่สามารถไปยัง " .. ore.name .. " ได้"
                break
            end
        end
        
        -- Mining completed
        isMining = false
        AutoMineAllButton.Visible = true
        StopMiningButton.Visible = false
        StatusLabel.Text = "ขุดแร่ทั้งหมดเสร็จสิ้น!"
    end)
end)

-- Stop Mining Function
StopMiningButton.MouseButton1Click:Connect(function()
    isMining = false
    AutoMineAllButton.Visible = true
    StopMiningButton.Visible = false
    StatusLabel.Text = "หยุดการขุดแล้ว"
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

-- Prevent GUI from going off-screen
RunService.Heartbeat:Connect(function()
    if not MainFrame.Visible then return end
    
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local position = MainFrame.Position
    local size = MainFrame.Size
    
    -- Keep GUI within screen bounds
    if position.X.Offset < 0 then
        MainFrame.Position = UDim2.new(0, 10, position.Y.Scale, position.Y.Offset)
    elseif position.X.Offset + size.X.Offset > viewportSize.X then
        MainFrame.Position = UDim2.new(0, viewportSize.X - size.X.Offset - 10, position.Y.Scale, position.Y.Offset)
    end
    
    if position.Y.Offset < 0 then
        MainFrame.Position = UDim2.new(position.X.Scale, position.X.Offset, 0, 10)
    elseif position.Y.Offset + size.Y.Offset > viewportSize.Y then
        MainFrame.Position = UDim2.new(position.X.Scale, position.X.Offset, 0, viewportSize.Y - size.Y.Offset - 10)
    end
end)

-- Make GUI draggable
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Mining System โหลดสำเร็จ!")
print("พบตำแหน่งแร่ทั้งหมด: " .. #orePositions .. " ตำแหน่ง")
print("ใช้ปุ่ม Toggle GUI สำหรับเปิด/ปิด")
