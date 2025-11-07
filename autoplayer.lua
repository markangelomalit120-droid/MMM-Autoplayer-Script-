_G.Settings = {AutoMatch = false, AutoNotes = false, Distance = 55}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ScreenGui, ArrowsContainer, HitRemote, AutoplayerFrame, ToggleButton, MainFrame, TogglePlayerBtn, AutoplayerStatusLabel

local function setupServices()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return false end
    ScreenGui = PlayerGui:FindFirstChild("MainGui")
    if not ScreenGui then return false end
    ArrowsContainer = ScreenGui:FindFirstChild("MainFrame") and ScreenGui.MainFrame:FindFirstChild("Arrows")
    if not ArrowsContainer then return false end
    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not Remotes then return false end
    HitRemote = Remotes:FindFirstChild("Hit")
    if not HitRemote then return false end
    return true
end

local function sendHit(index) HitRemote:FireServer(index) end

local function AutoplayerLoop()
    if not _G.Settings.AutoNotes or not ArrowsContainer then return end
    for i = 1, 4 do
        local Lane = ArrowsContainer:FindFirstChild("Lane"..i)
        if Lane and Lane:IsA("Frame") then
            local nearestNote = nil
            local minDistance = _G.Settings.Distance + 1
            for _, note in ipairs(Lane:GetChildren()) do
                if note:IsA("ImageLabel") and (note.Name == "Note" or note.Name == "Hold" or note.Name == "HoldEnd") then
                    local noteDistance = math.abs(note.Position.Y.Scale - 0.5)
                    if noteDistance < minDistance then
                        minDistance = noteDistance
                        nearestNote = note
                    end
                end
            end
            if nearestNote and minDistance <= _G.Settings.Distance / 1000 then sendHit(i) end
        end
    end
end
RunService.Heartbeat:Connect(AutoplayerLoop)

local function updateToggleStatus()
    if AutoplayerStatusLabel then
        if _G.Settings.AutoNotes then
            AutoplayerStatusLabel.Text = "Status: ON"
            AutoplayerStatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
        else
            AutoplayerStatusLabel.Text = "Status: OFF"
            AutoplayerStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end
end

local function createGUI()
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AutoplayerGUI"
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = LocalPlayer:FindFirstChild("PlayerGui")

    AutoplayerFrame = Instance.new("Frame")
    AutoplayerFrame.Name = "AutoplayerFrame"
    AutoplayerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    AutoplayerFrame.BorderSizePixel = 0
    AutoplayerFrame.Size = UDim2.new(0, 200, 0, 150)
    AutoplayerFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
    AutoplayerFrame.Active = true
    AutoplayerFrame.Draggable = false
    AutoplayerFrame.ClipsDescendants = true
    AutoplayerFrame.Parent = Gui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = AutoplayerFrame

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Header.Size = UDim2.new(1, 0, 0, 25)
    Header.BorderSizePixel = 0
    Header.Parent = AutoplayerFrame
    Header.Active = true
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "FNF Autoplayer (Team Edition)"
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSansBold
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Parent = Header

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainContent"
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, -25)
    MainFrame.Position = UDim2.new(0, 0, 0, 25)
    MainFrame.Parent = AutoplayerFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.Parent = MainFrame

    AutoplayerStatusLabel = Instance.new("TextLabel")
    AutoplayerStatusLabel.Name = "StatusLabel"
    AutoplayerStatusLabel.Text = "Status: OFF"
    AutoplayerStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    AutoplayerStatusLabel.TextSize = 15
    AutoplayerStatusLabel.Font = Enum.Font.SourceSansBold
    AutoplayerStatusLabel.BackgroundTransparency = 1
    AutoplayerStatusLabel.Size = UDim2.new(1, -20, 0, 20)
    AutoplayerStatusLabel.Parent = MainFrame
    
    TogglePlayerBtn = Instance.new("TextButton")
    TogglePlayerBtn.Name = "TogglePlayerButton"
    TogglePlayerBtn.Text = "Toggle Autoplayer"
    TogglePlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TogglePlayerBtn.TextSize = 16
    TogglePlayerBtn.Font = Enum.Font.SourceSans
    TogglePlayerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TogglePlayerBtn.Size = UDim2.new(0, 180, 0, 30)
    TogglePlayerBtn.Parent = MainFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 5)
    ToggleCorner.Parent = TogglePlayerBtn

    TogglePlayerBtn.MouseButton1Click:Connect(function()
        _G.Settings.AutoNotes = not _G.Settings.AutoNotes
        updateToggleStatus()
    end)
    
    ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "OpenCloseButton"
    ToggleButton.Text = "Toggle UI"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    ToggleButton.Size = UDim2.new(0, 75, 0, 25)
    ToggleButton.Position = UDim2.new(0.5, -37.5, 0.9, 0)
    ToggleButton.Parent = Gui 

    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            AutoplayerFrame.Size = UDim2.new(0, 200, 0, 150)
        else
            AutoplayerFrame.Size = UDim2.new(0, 200, 0, 25)
        end
    end)
    
    local dragging = false
    local dragStart = Vector2.new(0, 0)
    local startPos = UDim2.new(0, 0, 0, 0)

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.Target == Header or input.Target == Title then
                dragging = true
                dragStart = UserInputService:GetMouseLocation()
                startPos = AutoplayerFrame.Position
            end
        end
    end

    local function onInputChanged(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = UserInputService:GetMouseLocation() - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            AutoplayerFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end

    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
    
    updateToggleStatus()
end

if setupServices() then
    createGUI()
end
