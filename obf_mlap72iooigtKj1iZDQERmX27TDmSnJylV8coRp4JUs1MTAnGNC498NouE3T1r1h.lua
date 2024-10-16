local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

local window = DrRayLibrary:Load("KillEh", "Default")

local tab = DrRayLibrary.newTab("CLICK HERE!", "ImageIdHere")

tab.newButton("Car Fly", "Made by Killeh (little bit buggy)", function()
    
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xovanDJX/Backup/main/Venyx%20UI%20Library"))()
    local venyx = library.new("KILL/EH | Universal Vehicle Speed | By KILLEH", 5013109572)
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    
    local themes = {
        Background = Color3.fromRGB(61, 60, 124), 
        Glow = Color3.fromRGB(60, 63, 221), 
        Accent = Color3.fromRGB(55, 52, 90), 
        LightContrast = Color3.fromRGB(64, 65, 128), 
        DarkContrast = Color3.fromRGB(32, 33, 64),  
        TextColor = Color3.fromRGB(255, 255, 255)
    }
    
    local function GetVehicleFromDescendant(Descendant)
        return
            Descendant:FindFirstAncestor(LocalPlayer.Name .. "\'s Car") or
            (Descendant:FindFirstAncestor("Body") and Descendant:FindFirstAncestor("Body").Parent) or
            (Descendant:FindFirstAncestor("Misc") and Descendant:FindFirstAncestor("Misc").Parent) or
            Descendant:FindFirstAncestorWhichIsA("Model")
    end
    
    local function TeleportVehicle(CoordinateFrame: CFrame)
        local Parent = LocalPlayer.Character.Parent
        local Vehicle = GetVehicleFromDescendant(LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").SeatPart)
        LocalPlayer.Character.Parent = Vehicle
        local success, response = pcall(function()
            return Vehicle:SetPrimaryPartCFrame(CoordinateFrame)
        end)
        if not success then
            return Vehicle:MoveTo(CoordinateFrame.Position)
        end
    end
    
    
    local vehiclePage = venyx:addPage("Vehicle", 8356815386)
    local usageSection = vehiclePage:addSection("Usage")
    local velocityEnabled = true;
    usageSection:addToggle("Keybinds Active", velocityEnabled, function(v) velocityEnabled = v end)
    local flightSection = vehiclePage:addSection("Flight")
    local flightEnabled = false
    local flightSpeed = 1
    flightSection:addToggle("Enabled", false, function(v) flightEnabled = v end)
    flightSection:addSlider("Speed", 100, 0, 800, function(v) flightSpeed = v / 100 end)
    local defaultCharacterParent 
    RunService.Stepped:Connect(function()
        local Character = LocalPlayer.Character
        if flightEnabled == true then
            if Character and typeof(Character) == "Instance" then
                local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                if Humanoid and typeof(Humanoid) == "Instance" then
                    local SeatPart = Humanoid.SeatPart
                    if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                        local Vehicle = GetVehicleFromDescendant(SeatPart)
                        if Vehicle and Vehicle:IsA("Model") then
                            Character.Parent = Vehicle
                            if not Vehicle.PrimaryPart then
                                if SeatPart.Parent == Vehicle then
                                    Vehicle.PrimaryPart = SeatPart
                                else
                                    Vehicle.PrimaryPart = Vehicle:FindFirstChildWhichIsA("BasePart")
                                end
                            end
                            local PrimaryPartCFrame = Vehicle:GetPrimaryPartCFrame()
                            Vehicle:SetPrimaryPartCFrame(CFrame.new(PrimaryPartCFrame.Position, PrimaryPartCFrame.Position + workspace.CurrentCamera.CFrame.LookVector) * (UserInputService:GetFocusedTextBox() and CFrame.new(0, 0, 0) or CFrame.new((UserInputService:IsKeyDown(Enum.KeyCode.D) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -flightSpeed) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.E) and flightSpeed / 2) or (UserInputService:IsKeyDown(Enum.KeyCode.Q) and -flightSpeed / 2) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.S) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -flightSpeed) or 0)))
                            SeatPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            SeatPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        else
            if Character and typeof(Character) == "Instance" then
                Character.Parent = defaultCharacterParent or Character.Parent
                defaultCharacterParent = Character.Parent
            end
        end
    end)
    local speedSection = vehiclePage:addSection("Acceleration")
    local velocityMult = 0.025;
    speedSection:addSlider("Multiplier (Thousandths)", 25, 0, 50, function(v) velocityMult = v / 1000; end)
    local velocityEnabledKeyCode = Enum.KeyCode.W;
    speedSection:addKeybind("Velocity Enabled", velocityEnabledKeyCode, function()
        if not velocityEnabled then
            return
        end
        while UserInputService:IsKeyDown(velocityEnabledKeyCode) do
            task.wait(0)
            local Character = LocalPlayer.Character
            if Character and typeof(Character) == "Instance" then
                local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                if Humanoid and typeof(Humanoid) == "Instance" then
                    local SeatPart = Humanoid.SeatPart
                    if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                        SeatPart.AssemblyLinearVelocity *= Vector3.new(1 + velocityMult, 1, 1 + velocityMult)
                    end
                end
            end
            if not velocityEnabled then
                break
            end
        end
    end, function(v) velocityEnabledKeyCode = v.KeyCode end)
    local decelerateSelection = vehiclePage:addSection("Deceleration")
    local qbEnabledKeyCode = Enum.KeyCode.S
    local velocityMult2 = 0.15
    decelerateSelection:addSlider("Brake Force (Thousandths)", velocityMult2*1000, 0, 300, function(v) velocityMult2 = v / 1000; end)
    decelerateSelection:addKeybind("Quick Brake Enabled", qbEnabledKeyCode, function()
        if not velocityEnabled then
            return
        end
        while UserInputService:IsKeyDown(qbEnabledKeyCode) do
            task.wait(0)
            local Character = LocalPlayer.Character
            if Character and typeof(Character) == "Instance" then
                local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                if Humanoid and typeof(Humanoid) == "Instance" then
                    local SeatPart = Humanoid.SeatPart
                    if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                        SeatPart.AssemblyLinearVelocity *= Vector3.new(1 - velocityMult2, 1, 1 - velocityMult2)
                    end
                end
            end
            if not velocityEnabled then
                break
            end
        end
    end, function(v) qbEnabledKeyCode = v.KeyCode end)
    decelerateSelection:addKeybind("Stop the Vehicle", Enum.KeyCode.P, function(v)
        if not velocityEnabled then
            return
        end
        local Character = LocalPlayer.Character
        if Character and typeof(Character) == "Instance" then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid and typeof(Humanoid) == "Instance" then
                local SeatPart = Humanoid.SeatPart
                if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                    SeatPart.AssemblyLinearVelocity *= Vector3.new(0, 0, 0)
                    SeatPart.AssemblyAngularVelocity *= Vector3.new(0, 0, 0)
                end
            end
        end
    end)
    local springSection = vehiclePage:addSection("Springs")
    springSection:addToggle("Visible", false, function(v)
        local Character = LocalPlayer.Character
        if Character and typeof(Character) == "Instance" then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid and typeof(Humanoid) == "Instance" then
                local SeatPart = Humanoid.SeatPart
                if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                    local Vehicle = GetVehicleFromDescendant(SeatPart)
                    for _, SpringConstraint in pairs(Vehicle:GetDescendants()) do
                        if SpringConstraint:IsA("SpringConstraint") then
                            SpringConstraint.Visible = v
                        end
                    end
                end
            end
        end
    end)
    repeat
        task.wait(0)
    until game:IsLoaded() and game.PlaceId > 0
    if game.PlaceId == 3351674303 then
        local drivingEmpirePage = venyx:addPage("Wayfort", 8357222903)
        local dealershipSection = drivingEmpirePage:addSection("Vehicle Dealership")
        local dealershipList = {}
        for index, value in pairs(workspace:WaitForChild("Game"):WaitForChild("Dealerships"):WaitForChild("Dealerships"):GetChildren()) do
            table.insert(dealershipList, value.Name)
        end
        dealershipSection:addDropdown("Dealership", dealershipList, function(v)
            game:GetService("ReplicatedStorage").Remotes.Location:FireServer("Enter", v)
        end)
    elseif game.PlaceId == 891852901 then
        local greenvillePage = venyx:addPage("Greenville", 8360925727)
    elseif game.PlaceId == 54865335 then
        local ultimateDrivingPage = venyx:addPage("Westover", 8360954483)
    elseif game.PlaceId == 5232896677 then
        local pacificoPage = venyx:addPage("Pacifico", 3028235557)
    end
    local infoPage = venyx:addPage("Information", 8356778308)
    local discordSection = infoPage:addSection("Killeh")
    discordSection:addButton(syn and "Join The Official Discord server" or "Join Creator's Discord Server", function()
    if syn then syn.request({ Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST",Headers = {["Content-Type"] = "application/json",["Origin"] = "https://discord.com"},
    Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER",args = {code = "cVgfFnrrhp"},nonce = game:GetService("HttpService"):GenerateGUID(false)}),}) return end
    setclipboard("https://discord.gg/cVgfFnrrhp")
    end)
end)

    tab.newButton("Aimbot", "Made by Killeh", function()

--// Cache

local loadstring, game, getgenv, setclipboard = loadstring, game, getgenv, setclipboard

--// Loaded check

if getgenv().Aimbot then return end

--// Load Aimbot V2 (Raw)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()

--// Variables

local Aimbot = getgenv().Aimbot
local Settings, FOVSettings, Functions = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions

local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Library

local Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}

--// Frame

Library.UnloadCallback = Functions.Exit

local MainFrame = Library:CreateWindow({
	Name = "KILLEH / AIMBOT",
	Themeable = {
		Image = "7059346386",
		Info = "MADE BY FLYRY\nPowered by Pepsi's UI Library",
		Credit = false
	},
	Background = "",
	Theme = [[{"__Designer.Colors.section":"ADC7FF","__Designer.Colors.topGradient":"1B242F","__Designer.Settings.ShowHideKey":"Enum.KeyCode.RightShift","__Designer.Colors.otherElementText":"54637D","__Designer.Colors.hoveredOptionBottom":"38667D","__Designer.Background.ImageAssetID":"","__Designer.Colors.unhoveredOptionTop":"407495","__Designer.Colors.innerBorder":"2C4168","__Designer.Colors.unselectedOption":"4E6EA0","__Designer.Background.UseBackgroundImage":true,"__Designer.Files.WorkspaceFile":"Aimbot V2","__Designer.Colors.main":"23A0FF","__Designer.Colors.outerBorder":"162943","__Designer.Background.ImageColor":"FFFFFF","__Designer.Colors.tabText":"C9DFF1","__Designer.Colors.elementBorder":"111D26","__Designer.Colors.sectionBackground":"0E141C","__Designer.Colors.selectedOption":"558AC2","__Designer.Colors.background":"11182A","__Designer.Colors.bottomGradient":"202B42","__Designer.Background.ImageTransparency":95,"__Designer.Colors.hoveredOptionTop":"4885A0","__Designer.Colors.elementText":"7692B8","__Designer.Colors.unhoveredOptionBottom":"5471C4"}]]
})

--// Tabs

local SettingsTab = MainFrame:CreateTab({
	Name = "Settings"
})

local FOVSettingsTab = MainFrame:CreateTab({
	Name = "FOV Settings"
})

local FunctionsTab = MainFrame:CreateTab({
	Name = "Functions"
})

--// Settings - Sections

local Values = SettingsTab:CreateSection({
	Name = "Values"
})

local Checks = SettingsTab:CreateSection({
	Name = "Checks"
})

local ThirdPerson = SettingsTab:CreateSection({
	Name = "Third Person"
})

--// FOV Settings - Sections

local FOV_Values = FOVSettingsTab:CreateSection({
	Name = "Values"
})

local FOV_Appearance = FOVSettingsTab:CreateSection({
	Name = "Appearance"
})

--// Functions - Sections

local FunctionsSection = FunctionsTab:CreateSection({
	Name = "Functions"
})

--// Settings / Values

Values:AddToggle({
	Name = "Enabled",
	Value = Settings.Enabled,
	Callback = function(New, Old)
		Settings.Enabled = New
	end
}).Default = Settings.Enabled

Values:AddToggle({
	Name = "Toggle",
	Value = Settings.Toggle,
	Callback = function(New, Old)
		Settings.Toggle = New
	end
}).Default = Settings.Toggle

Settings.LockPart = Parts[1]; Values:AddDropdown({
	Name = "Lock Part",
	Value = Parts[1],
	Callback = function(New, Old)
		Settings.LockPart = New
	end,
	List = Parts,
	Nothing = "Head"
}).Default = Parts[1]

Values:AddTextbox({ -- Using a Textbox instead of a Keybind because the UI Library doesn't support Mouse inputs like Left Click / Right Click...
	Name = "Hotkey",
	Value = Settings.TriggerKey,
	Callback = function(New, Old)
		Settings.TriggerKey = New
	end
}).Default = Settings.TriggerKey

--[[
Values:AddKeybind({
	Name = "Hotkey",
	Value = Settings.TriggerKey,
	Callback = function(New, Old)
		Settings.TriggerKey = stringmatch(tostring(New), "Enum%.[UserInputType]*[KeyCode]*%.(.+)")
	end,
}).Default = Settings.TriggerKey
]]

Values:AddSlider({
	Name = "Sensitivity",
	Value = Settings.Sensitivity,
	Callback = function(New, Old)
		Settings.Sensitivity = New
	end,
	Min = 0,
	Max = 1,
	Decimals = 2
}).Default = Settings.Sensitivity

--// Settings / Checks

Checks:AddToggle({
	Name = "Team Check",
	Value = Settings.TeamCheck,
	Callback = function(New, Old)
		Settings.TeamCheck = New
	end
}).Default = Settings.TeamCheck

Checks:AddToggle({
	Name = "Wall Check",
	Value = Settings.WallCheck,
	Callback = function(New, Old)
		Settings.WallCheck = New
	end
}).Default = Settings.WallCheck

Checks:AddToggle({
	Name = "Alive Check",
	Value = Settings.AliveCheck,
	Callback = function(New, Old)
		Settings.AliveCheck = New
	end
}).Default = Settings.AliveCheck

--// Settings / ThirdPerson

ThirdPerson:AddToggle({
	Name = "Enable Third Person",
	Value = Settings.ThirdPerson,
	Callback = function(New, Old)
		Settings.ThirdPerson = New
	end
}).Default = Settings.ThirdPerson

ThirdPerson:AddSlider({
	Name = "Sensitivity",
	Value = Settings.ThirdPersonSensitivity,
	Callback = function(New, Old)
		Settings.ThirdPersonSensitivity = New
	end,
	Min = 0.1,
	Max = 5,
	Decimals = 1
}).Default = Settings.ThirdPersonSensitivity

--// FOV Settings / Values

FOV_Values:AddToggle({
	Name = "Enabled",
	Value = FOVSettings.Enabled,
	Callback = function(New, Old)
		FOVSettings.Enabled = New
	end
}).Default = FOVSettings.Enabled

FOV_Values:AddToggle({
	Name = "Visible",
	Value = FOVSettings.Visible,
	Callback = function(New, Old)
		FOVSettings.Visible = New
	end
}).Default = FOVSettings.Visible

FOV_Values:AddSlider({
	Name = "Amount",
	Value = FOVSettings.Amount,
	Callback = function(New, Old)
		FOVSettings.Amount = New
	end,
	Min = 10,
	Max = 300
}).Default = FOVSettings.Amount

--// FOV Settings / Appearance

FOV_Appearance:AddToggle({
	Name = "Filled",
	Value = FOVSettings.Filled,
	Callback = function(New, Old)
		FOVSettings.Filled = New
	end
}).Default = FOVSettings.Filled

FOV_Appearance:AddSlider({
	Name = "Transparency",
	Value = FOVSettings.Transparency,
	Callback = function(New, Old)
		FOVSettings.Transparency = New
	end,
	Min = 0,
	Max = 1,
	Decimal = 1
}).Default = FOVSettings.Transparency

FOV_Appearance:AddSlider({
	Name = "Sides",
	Value = FOVSettings.Sides,
	Callback = function(New, Old)
		FOVSettings.Sides = New
	end,
	Min = 3,
	Max = 60
}).Default = FOVSettings.Sides

FOV_Appearance:AddSlider({
	Name = "Thickness",
	Value = FOVSettings.Thickness,
	Callback = function(New, Old)
		FOVSettings.Thickness = New
	end,
	Min = 1,
	Max = 50
}).Default = FOVSettings.Thickness

FOV_Appearance:AddColorpicker({
	Name = "Color",
	Value = FOVSettings.Color,
	Callback = function(New, Old)
		FOVSettings.Color = New
	end
}).Default = FOVSettings.Color

FOV_Appearance:AddColorpicker({
	Name = "Locked Color",
	Value = FOVSettings.LockedColor,
	Callback = function(New, Old)
		FOVSettings.LockedColor = New
	end
}).Default = FOVSettings.LockedColor

--// Functions / Functions

FunctionsSection:AddButton({
	Name = "Reset Settings",
	Callback = function()
		Functions.ResetSettings()
		Library.ResetAll()
	end
})

FunctionsSection:AddButton({
	Name = "Restart",
	Callback = Functions.Restart
})

FunctionsSection:AddButton({
	Name = "Exit",
	Callback = function()
		Functions:Exit()
		Library.Unload()
	end
})

FunctionsSection:AddButton({
	Name = "Copy Script Page",
	Callback = function()
		setclipboard("https://github.com/Exunys/Aimbot-V2")
	end
})
end)



tab.newButton("Esp", "Made by Killeh (little bit buggy)", function()


    pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))() end)

end)