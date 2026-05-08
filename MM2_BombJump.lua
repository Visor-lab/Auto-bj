-- MM2 AUTO BOMB JUMP + GUI | EDUCATIONAL USE ONLY
-- Style: Same as Baddies2 / WeAreDevs scripts
-- Features: Toggle ON/OFF, Adjust Height, Delay Slider, Keybind

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- LOCAL REFS
local LocalPlayer = Players.LocalPlayer
local Character, Humanoid, HRP, Tool

-- ⚙️ SETTINGS (editable in GUI)
local Settings = {
    Enabled = true,
    BoostForce = 220,      -- 150–300 = higher = higher jump
    DetonateDelay = 0.12,  -- 0.08–0.15 = perfect timing
    ToggleKey = Enum.KeyCode.F5
}

-- =====================
-- 🖥️ CUSTOM GUI MENU
-- =====================
local GUI = Instance.new("ScreenGui")
GUI.Name = "BaddiesStyle_MM2"
GUI.Parent = CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false

-- Main Window
local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Parent = GUI
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.Position = UDim2.new(0.05, 0, 0.05, 0)
Window.Size = UDim2.new(0, 280, 0, 220)
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true -- drag to move

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = Window
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, -10, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "MM2 | AUTO BOMB JUMP"
TitleText.TextColor3 = Color3.fromRGB(255, 85, 85)
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- TOGGLE BUTTON
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Window
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ENABLED | F5 TOGGLE"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 0

-- BOOST FORCE SLIDER LABEL
local ForceLabel = Instance.new("TextLabel")
ForceLabel.Parent = Window
ForceLabel.BackgroundTransparency = 1
ForceLabel.Size = UDim2.new(0.9, 0, 0, 20)
ForceLabel.Position = UDim2.new(0.05, 0, 0, 90)
ForceLabel.Font = Enum.Font.Gotham
ForceLabel.Text = "Boost Height: "..Settings.BoostForce
ForceLabel.TextColor3 = Color3.new(0.9,0.9,0.9)
ForceLabel.TextSize = 12
ForceLabel.TextXAlignment = Enum.TextXAlignment.Left

-- BOOST SLIDER BAR
local ForceSliderBG = Instance.new("Frame")
ForceSliderBG.Parent = Window
ForceSliderBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
ForceSliderBG.Size = UDim2.new(0.9, 0, 0, 8)
ForceSliderBG.Position = UDim2.new(0.05, 0, 0, 110)
ForceSliderBG.BorderSizePixel = 0

local ForceSliderFill = Instance.new("Frame")
ForceSliderFill.Parent = ForceSliderBG
ForceSliderFill.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
ForceSliderFill.Size = UDim2.new((Settings.BoostForce-100)/200, 0, 1, 0)
ForceSliderFill.BorderSizePixel = 0

-- DELAY LABEL
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Parent = Window
DelayLabel.BackgroundTransparency = 1
DelayLabel.Size = UDim2.new(0.9, 0, 0, 20)
DelayLabel.Position = UDim2.new(0.05, 0, 0, 130)
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.Text = "Detonate Delay: "..Settings.DetonateDelay.."s"
DelayLabel.TextColor3 = Color3.new(0.9,0.9,0.9)
DelayLabel.TextSize = 12
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left

-- DELAY SLIDER BAR
local DelaySliderBG = Instance.new("Frame")
DelaySliderBG.Parent = Window
DelaySliderBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
DelaySliderBG.Size = UDim2.new(0.9, 0, 0, 8)
DelaySliderBG.Position = UDim2.new(0.05, 0, 0, 150)
DelaySliderBG.BorderSizePixel = 0

local DelaySliderFill = Instance.new("Frame")
DelaySliderFill.Parent = DelaySliderBG
DelaySliderFill.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
DelaySliderFill.Size = UDim2.new((Settings.DetonateDelay-0.05)/0.2, 0, 1, 0)
DelaySliderFill.BorderSizePixel = 0

-- CREDITS
local Credit = Instance.new("TextLabel")
Credit.Parent = Window
Credit.BackgroundTransparency = 1
Credit.Size = UDim2.new(1,0,0,20)
Credit.Position = UDim2.new(0,0,1,-22)
Credit.Font = Enum.Font.Gotham
Credit.Text = "Made like Baddies2 | Educational Only"
Credit.TextColor3 = Color3.fromRGB(100,100,100)
Credit.TextSize = 10
Credit.TextXAlignment = Enum.TextXAlignment.Center

-- =====================
-- 🎛️ GUI LOGIC
-- =====================
-- Toggle Button Click
ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    ToggleBtn.Text = Settings.Enabled and "ENABLED | F5 TOGGLE" or "DISABLED | F5 TOGGLE"
    ToggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(60,120,255) or Color3.fromRGB(80,80,80)
end)

-- Keybind Toggle
UIS.InputBegan:Connect(function(Inp, GP)
    if GP then return end
    if Inp.KeyCode == Settings.ToggleKey then
        Settings.Enabled = not Settings.Enabled
        ToggleBtn.Text = Settings.Enabled and "ENABLED | F5 TOGGLE" or "DISABLED | F5 TOGGLE"
        ToggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(60,120,255) or Color3.fromRGB(80,80,80)
    end
end)

-- Slider drag logic (simple version)
local function MakeSlider(Bar, Fill, Label, Min, Max, SettingName, Format)
    local Dragging = false
    Bar.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end end)
    Bar.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    UIS.InputChanged:Connect(function(I)
        if Dragging and I.UserInputType == Enum.UserInputType.MouseMovement then
            local Pos = math.clamp((I.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(Pos,0,1,0)
            Settings[SettingName] = Min + (Pos*(Max-Min))
            Label.Text = Format(Settings[SettingName])
        end
    end)
end

-- Activate sliders
MakeSlider(ForceSliderBG, ForceSliderFill, ForceLabel, 100, 300, "BoostForce", function(v) return "Boost Height: "..math.floor(v) end)
MakeSlider(DelaySliderBG, DelaySliderFill, DelayLabel, 0.05, 0.25, "DetonateDelay", function(v) return "Detonate Delay: "..math.floor(v*100)/100.."s" end)

-- =====================
-- 🎮 GAME LOGIC (AUTO BOMB JUMP)
-- =====================
local function SetupChar()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    HRP = Character:WaitForChild("HumanoidRootPart")

    -- Detect Prank Bomb equip
    Character.ChildAdded:Connect(function(Child)
        if Child:IsA("Tool") and Child.Name:lower():find("bomb") then Tool = Child end
    end)
    Character.ChildRemoved:Connect(function(Child)
        if Child == Tool then Tool = nil end
    end)
end
SetupChar()
LocalPlayer.CharacterAdded:Connect(SetupChar)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if not Settings.Enabled or not Tool or not Humanoid or Humanoid.Health <= 0 or not HRP then return end

    -- When jumping & in air
    if Humanoid.Jump and Humanoid.FloorMaterial == Enum.Material.Air then
        task.wait(Settings.DetonateDelay) -- wait for peak
        if Humanoid.FloorMaterial == Enum.Material.Air then
            -- Simulate RIGHT CLICK = DETONATE
            UIS:InputBegan:Fire({
                UserInputType = Enum.UserInputType.MouseButton2,
                Position = UIS:GetMouseLocation()
            })
            -- Apply extra boost
            HRP.Velocity = HRP.Velocity + Vector3.new(0, Settings.BoostForce, 0)
        end
    end
end)
