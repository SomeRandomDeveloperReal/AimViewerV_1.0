local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CurrentScriptVersion = 1.0
local UserInputService = game:GetService("UserInputService")

local AimViewPersonConfirm
local AimViewAllConfirm
local SelectPerson
local OnePlrStat
local AllPlrStat
local UI

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

local function startUp()
	local AimViewUI = Instance.new("ScreenGui")
	UI = AimViewUI
	AimViewUI.Name = "AimViewUI"
	AimViewUI.Parent = LocalPlayer.PlayerGui
	local bootUpUI = Instance.new("TextLabel")
	bootUpUI.Size = UDim2.new(0.234, 0, 0.121, 0)
	bootUpUI.Position = UDim2.new(0.393, 0, 0.444, 0)
	bootUpUI.Text = "Booting Up aim Viewer..."
	AimViewUI.Enabled = true
	bootUpUI.Parent = AimViewUI
	wait(1)
	local MainUI = Instance.new("Frame")
	MainUI.Name = "Main"
	local cornerUI = Instance.new("UICorner")
	cornerUI.Parent = MainUI
	MainUI.Position = UDim2.new(0.2, 0, 0.17, 0)
	MainUI.Size  = UDim2.new(0.665, 0, 0.672, 0)
	local TitleUI = Instance.new("TextLabel")
	TitleUI.Name = "Title"
	TitleUI.TextColor3 = Color3.new(1 ,1, 1)
	TitleUI.Position = UDim2.new(0.231, 0, -0.003, 0)
	TitleUI.Size = UDim2.new(0.5, 0, 0.112, 0)
	TitleUI.Text = "Aim Viewer"
	local ScriptVersion = Instance.new("TextLabel")
	ScriptVersion.TextColor3 = Color3.new(1 ,1, 1)
	ScriptVersion.Name = "Version"
	ScriptVersion.Position = UDim2.new(0.68, 0, -0.003, 0)
	ScriptVersion.Size = UDim2.new(0.316, 0, 0.045, 0)
	ScriptVersion.Text = "Version: "..CurrentScriptVersion
	local AVPersonStat = Instance.new("TextLabel")
	AVPersonStat.TextColor3 = Color3.new(1 ,1, 1)
	AVPersonStat.Name = "AimViewPersonStatus"
	AVPersonStat.Position = UDim2.new(0.574, 0, 0.548, 0)
	AVPersonStat.Size = UDim2.new(0.323, 0, 0.058, 0)
	AVPersonStat.Text = "Enter Player's Username (CASE SENSITIVE)"
	OnePlrStat = AVPersonStat
	local AVAllStat = Instance.new("TextLabel")
	AVAllStat.TextColor3 = Color3.new(1 ,1, 1)
	AVAllStat.Name = "AimViewAllStatus"
	AVAllStat.Position = UDim2.new(0.125, 0, 0.711, 0)
	AVAllStat.Size = UDim2.new(0.339, 0, 0.071, 0)
	AVAllStat.Text = "Disabled"
	AllPlrStat = AVAllStat
	local ActivateAVPerson = Instance.new("TextButton")
	ActivateAVPerson.TextColor3 = Color3.new(1 ,1, 1)
	ActivateAVPerson.Name = "AimViewPerson"
	ActivateAVPerson.Position = UDim2.new(0.573, 0, 0.449, 0)
	ActivateAVPerson.Size = UDim2.new(0.326, 0, 0.09, 0)
	ActivateAVPerson.Text = "Add Aim View to Player"
	local CornerUI2 = cornerUI:Clone()
	CornerUI2.Parent = ActivateAVPerson
	AimViewPersonConfirm = ActivateAVPerson
	local ActivateAVAll = Instance.new("TextButton")
	ActivateAVAll.TextColor3 = Color3.new(1 ,1, 1)
	ActivateAVAll.Name = "AimViewAll"
	ActivateAVAll.Position = UDim2.new(0.574, 0, 0.692, 0)
	ActivateAVAll.Size = UDim2.new(0.323, 0, 0.096, 0)
	ActivateAVAll.Text = "Aim View All"
	local CornerUI3 = cornerUI:Clone()
	CornerUI3.Parent = ActivateAVAll
	AimViewAllConfirm = ActivateAVAll
	local EnterUsername = Instance.new("TextBox")
	EnterUsername.TextColor3 = Color3.new(1 ,1, 1)
	EnterUsername.Name = "Username"
	EnterUsername.Position = UDim2.new(0.124, 0, 0.449, 0)
	EnterUsername.Size = UDim2.new(0.345, 0, 0.096, 0)
	EnterUsername.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
	EnterUsername.BorderSizePixel = 2
	EnterUsername.Text = ""
	EnterUsername.PlaceholderText = "Enter Target's Username"
	SelectPerson = EnterUsername
	local keybindReminder = Instance.new("TextLabel")
	keybindReminder.TextColor3 = Color3.new(1, 1, 1)
	keybindReminder.Name = "keybind"
	keybindReminder.Position = UDim2.new(0.233, 0, 0.921, 0)
	keybindReminder.Size = UDim2.new(0.448, 0, 0.077, 0)
	keybindReminder.Text =" Press [M] to Open/Close the Menu. Press [=] to Kill the script."
	print("AIM VIEWER: FINISHING SETUP")
	bootUpUI:Destroy()
	MainUI.Parent = AimViewUI
	TitleUI.Parent = MainUI
	ScriptVersion.Parent = MainUI
	AVPersonStat.Parent = MainUI
	AVAllStat.Parent = MainUI
	ActivateAVPerson.Parent = MainUI
	ActivateAVAll.Parent = MainUI
	EnterUsername.Parent = MainUI
	keybindReminder.Parent = MainUI
	print("AIM VIEWER SETUP COMPLETE")
	for i,TextLabels in pairs(MainUI:GetChildren()) do
		if TextLabels:IsA("TextLabel") then
			TextLabels.BackgroundTransparency = 1
		end
	end
	for i,TextButtons in pairs(MainUI:GetChildren()) do
		if TextButtons:IsA("TextButton") then
			TextButtons.BackgroundColor3 = Color3.new(0.235294, 0.235294, 0.235294)
		end
	end
	MainUI.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
end

startUp()



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
                redBeamPart.CFrame = CFrame.new(head.Position, head.Position + lookVector) * CFrame.new(offset + Vector3.new(0, 0, 0))
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
	task.wait()
	KillSwitch = false
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end)

AimViewPersonConfirm.MouseButton1Up:Connect(function()
	targetUsername = SelectPerson.Text
	local CheckPlr = Players:FindFirstChild(targetUsername)
	if CheckPlr then
		OnePlrStat.Text = "Player Found"
	else
		OnePlrStat.Text = "Player Not Found"
		wait(1)
		OnePlrStat.Text = "Enter Player's Username (CASE SENSITIVE)"
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			onCharacterAdded(player.Character)
		end
	end
end)

AimViewAllConfirm.MouseButton1Up:Connect(function()
	if trackAll == true then
		trackAll = false
		activateKillSwitch()
		AllPlrStat.Text = "Disabled"
	else
		AllPlrStat.Text = "Enabling..."
		trackAll = true
		task.wait()
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				onCharacterAdded(player.Character)
			end
		end
		task.wait()
		AllPlrStat.Text = "Enabled"
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.M then
		if UI.Enabled == true then
			UI.Enabled = false
		else
			UI.Enabled = true
		end
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Equals then
		warn("AIM VIEWER CLOSING")
		activateKillSwitch()
		UI.Enabled = false
		UI:Destroy()
		script:Destroy()
	end
end)

if KillSwitch == true then
	activateKillSwitch()
end

