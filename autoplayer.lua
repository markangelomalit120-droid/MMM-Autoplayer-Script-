_G.Settings = {AutoMatch = false,AutoNotes = true,Distance = 55}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if not PlayerGui then return end
local ScreenGui = PlayerGui:FindFirstChild("MainGui")
if not ScreenGui then return end
local ArrowsContainer = ScreenGui:FindFirstChild("MainFrame") and ScreenGui.MainFrame:FindFirstChild("Arrows")
if not ArrowsContainer then return end
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then return end
local HitRemote = Remotes:FindFirstChild("Hit")
if not HitRemote then return end
local function sendHit(index) HitRemote:FireServer(index) end
local function AutoPlayerLoop()
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
RunService.Heartbeat:Connect(AutoPlayerLoop)
if _G.Settings.AutoMatch == false then
    local AutoMatchToggleRemote = Remotes:FindFirstChild("ToggleAutoMatch")
    if AutoMatchToggleRemote then AutoMatchToggleRemote:FireServer(false) end
end
