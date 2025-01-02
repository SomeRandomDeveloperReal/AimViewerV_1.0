local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--[[ EDIT BELOW ONLY ]]--

local KillSwitch = false -- Deletes all beams
local targetUsername = "TargetPlayerName" -- Replace with the desired username  (CASE SENSITIVE)
local trackAll = false -- Bypasses TargetUsername and adds targeting for all users (besides you)

--[[ EDIT ABOVE ONLY ]]--

local LocalPlayer = Players.LocalPlayer
local beams = {}

local function getPing()
    local ping = LocalPlayer:GetNetworkPing() -- Get the local player's ping
    return ping * 10 -- Scale the ping to use as an offset
end

local function createBeamForPlayer(player)
    if KillSwitch then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    local beamPart = Instance.new("Part")
    beamPart.Size = Vector3.new(0.2, 0.2, 50)
    beamPart.Anchored = true
    beamPart.CanCollide = false
    beamPart.CanTouch = false
    beamPart.CanQuery = false
    beamPart.Material = Enum.Material.Neon
    beamPart.BrickColor = BrickColor.new("Lime green")
    beamPart.Transparency = 0.5
    beamPart.Parent = Workspace
    table.insert(beams, beamPart)

    local redBeamPart = Instance.new("Part")
    redBeamPart.Size = Vector3.new(0.2, 0.2, 50)
    redBeamPart.Anchored = true
    redBeamPart.CanCollide = false
    redBeamPart.CanTouch = false
    redBeamPart.CanQuery = false
    redBeamPart.Material = Enum.Material.Neon
    redBeamPart.BrickColor = BrickColor.new("Bright red")
    redBeamPart.Transparency = 0.5
    redBeamPart.Parent = Workspace
    table.insert(beams, redBeamPart)

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if KillSwitch then
            connection:Disconnect()
            return
        end

        if head and beamPart.Parent then
            local lookVector = head.CFrame.LookVector
            local offset = Vector3.new(0, 0, -25) -- Keep the same distance for both beams
            beamPart.CFrame = CFrame.new(head.Position, head.Position + lookVector) * CFrame.new(offset)
            if redBeamPart and redBeamPart.Parent then
                local pingOffset = getPing() -- Get the ping-based offset
                -- Offset the red beam laterally based on ping
                redBeamPart.CFrame = CFrame.new(head.Position, head.Position + lookVector) * CFrame.new(offset + Vector3.new(pingOffset, 0, 0))
            end
        else
            connection:Disconnect()
        end
    end)

    return beamPart, redBeamPart
end

local function onCharacterAdded(character)
    if KillSwitch then return end

    local humanoid = character:WaitForChild("Humanoid")
    local player = Players:GetPlayerFromCharacter(character)

    if (trackAll and player ~= LocalPlayer) or player.Name == targetUsername then
        local beamPart, redBeamPart = createBeamForPlayer(player)
        
        humanoid.Died:Connect(function()
            if beamPart and beamPart.Parent then
                beamPart:Destroy()
            end
            if redBeamPart and redBeamPart.Parent then
                redBeamPart:Destroy()
            end
        end)
    end
end

local function activateKillSwitch()
    KillSwitch = true
    for _, beam in ipairs(beams) do
        if beam and beam.Parent then
            beam:Destroy()
        end
    end
    beams = {}
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

if KillSwitch == true then
	activateKillSwitch()
end

