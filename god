--[[

Coding: utf-8
Copyright (C) 2024 github.com/donfushii

--]]


local ImperiumLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/donfushii/Library/main/Imperium"))()

local Windows = ImperiumLib:Window("Imperium", Color3.fromRGB(255, 102, 178), Enum.KeyCode.V) -- 44, 120, 224 -- Default Colour --
ImperiumLib:Notification("Notification", "Welcome to Imperium. Thanks for using my HUB, Soon we will bring more.", "Okay!")

-- [ TABS ] --

local MainTAB = Windows:Tab("Main")
local GameTAB = Windows:Tab("Game")
local TargetTAB = Windows:Tab("Target")
local MiscTAB = Windows:Tab("Misc")
local AnimTAB = Windows:Tab("Animations")
local CreditsTAB = Windows:Tab("Credits")



-- [ VARIABLE'S ] --

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local player = Players.LocalPlayer
local humanoid = plr.Character.Humanoid

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Light = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local mouse = plr:GetMouse()
local ScriptWhitelist = {}
local ForceWhitelist = {}

local TargetedPlayer = nil
local PotionTool = nil
local SavedCheckpoint = nil




-- [ FUNCTION'S ] --

local function SendNotify(title, message, duration)
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = message, Duration = duration;})
end

--

_G.shield = function(id)
	if not table.find(ForceWhitelist,id) then
		table.insert(ForceWhitelist, id)
	end
end

--

local function GetPing()
	return (game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())/1000
end

--

local function GetPlayer(UserDisplay)
	if UserDisplay ~= "" then
        for i,v in pairs(Players:GetPlayers()) do
            if v.Name:lower():match(UserDisplay) or v.DisplayName:lower():match(UserDisplay) then
                return v
            end
        end
		return nil
	else
		return nil
    end
end

--

local function GetCharacter(Player)
	if Player.Character then
		return Player.Character
	end
end

--

local function GetRoot(Player)
	if GetCharacter(Player):FindFirstChild("HumanoidRootPart") then
		return GetCharacter(Player).HumanoidRootPart
	end
end

--

local function TeleportTO(posX,posY,posZ,player,method)
	pcall(function()
		if method == "safe" then
			task.spawn(function()
				for i = 1,30 do
					task.wait()
					GetRoot(plr).Velocity = Vector3.new(0,0,0)
					if player == "pos" then
						GetRoot(plr).CFrame = CFrame.new(posX,posY,posZ)
					else
						GetRoot(plr).CFrame = CFrame.new(GetRoot(player).Position)+Vector3.new(0,2,0)
					end
				end
			end)
		else
			GetRoot(plr).Velocity = Vector3.new(0,0,0)
			if player == "pos" then
				GetRoot(plr).CFrame = CFrame.new(posX,posY,posZ)
			else
				GetRoot(plr).CFrame = CFrame.new(GetRoot(player).Position)+Vector3.new(0,2,0)
			end
		end
	end)
end

--

local function PredictionTP(player,method)
	local root = GetRoot(player)
	local pos = root.Position
	local vel = root.Velocity
	GetRoot(plr).CFrame = CFrame.new((pos.X)+(vel.X)*(GetPing()*3.5),(pos.Y)+(vel.Y)*(GetPing()*2),(pos.Z)+(vel.Z)*(GetPing()*3.5))
	if method == "safe" then
		task.wait()
		GetRoot(plr).CFrame = CFrame.new(pos)
		task.wait()
		GetRoot(plr).CFrame = CFrame.new((pos.X)+(vel.X)*(GetPing()*3.5),(pos.Y)+(vel.Y)*(GetPing()*2),(pos.Z)+(vel.Z)*(GetPing()*3.5))
	end
end

--

local function Touch(x,root)
	pcall(function()
		x = x:FindFirstAncestorWhichIsA("Part")
		if x then
			if firetouchinterest then
				task.spawn(function()
					firetouchinterest(x, root, 1)
					task.wait()
					firetouchinterest(x, root, 0)
				end)
			end
		end
	end)
end

--

local function GetPush()
	local TempPush = nil
	pcall(function()
		if plr.Backpack:FindFirstChild("Push") then
			PushTool = plr.Backpack.Push
			PushTool.Parent = plr.Character
			TempPush = PushTool
		end
		for i,v in pairs(Players:GetPlayers()) do
			if v.Character:FindFirstChild("Push") then
				TempPush = v.Character.Push
			end
		end
	end)
	return TempPush
end

--

local function CheckPotion()
	if plr.Backpack:FindFirstChild("potion") then
		PotionTool = plr.Backpack:FindFirstChild("potion")
		return true
	elseif plr.Character:FindFirstChild("potion") then
		PotionTool = plr.Character:FindFirstChild("potion")
		return true
	else
		return false
	end
end

--

local function Push(Target)
	local Push = GetPush()
	local FixTool = nil
	if Push ~= nil then
		local args = {[1] = Target.Character}
		GetPush().PushTool:FireServer(unpack(args))
	end
	if plr.Character:FindFirstChild("Push") then
		plr.Character.Push.Parent = plr.Backpack
	end
	if plr.Character:FindFirstChild("ModdedPush") then
		FixTool = plr.Character:FindFirstChild("ModdedPush")
		FixTool.Parent = plr.Backpack
		FixTool.Parent = plr.Character
	end
	if plr.Character:FindFirstChild("ClickTarget") then
		FixTool = plr.Character:FindFirstChild("ClickTarget")
		FixTool.Parent = plr.Backpack
		FixTool.Parent = plr.Character
	end
	if plr.Character:FindFirstChild("potion") then
		FixTool = plr.Character:FindFirstChild("potion")
		FixTool.Parent = plr.Backpack
		FixTool.Parent = plr.Character
	end
end

--

local function ToggleRagdoll(bool)
	pcall(function()
		plr.Character["Falling down"].Disabled = bool
		plr.Character["Swimming"].Disabled = bool
		plr.Character["StartRagdoll"].Disabled = bool
		plr.Character["Pushed"].Disabled = bool
		plr.Character["RagdollMe"].Disabled = bool
	end)
end

--

local function ToggleVoidProtection(bool)
	if bool then
		game.Workspace.FallenPartsDestroyHeight = 0/0
	else
		game.Workspace.FallenPartsDestroyHeight = -500
	end
end

--

local function ToggleFling(bool)
	local TouchFling = bool
	task.spawn(function()
		if bool then
			local RVelocity = nil
			repeat
				pcall(function()
					RVelocity = GetRoot(plr).Velocity 
					GetRoot(plr).Velocity = Vector3.new(math.random(-150,150),-25000,math.random(-150,150))
					RunService.RenderStepped:wait()
					GetRoot(plr).Velocity = RVelocity
				end)
				RunService.Heartbeat:wait()
			until TouchFling == print("ON")
		else
			TouchFling = print("OFF")
		end
	end)
end




-- [ TAB #1 ] --

MainTAB:Button("📍 ・ Push All", function()
	local oldpos = GetRoot(plr).Position
	for i,v in pairs(Players:GetPlayers()) do
		pcall(function()
			if (v ~= plr) and (not table.find(ScriptWhitelist,v.UserId)) and (not table.find(ForceWhitelist,v.UserId)) then
				PredictionTP(v)
				task.wait(GetPing()+0.05)
				Push(v)
			end
		end)
	end
	TeleportTO(oldpos.X,oldpos.Y,oldpos.Z,"pos","safe")
end)

MainTAB:Button("📍 ・ Modded Push", function()
	local ModdedPush = Instance.new("Tool")
	ModdedPush.Name = "Modded Push"
	ModdedPush.RequiresHandle = false
	ModdedPush.TextureId = "rbxassetid://14478599909"
	ModdedPush.ToolTip = "Modded push"

	local function ActivateTool()
		local root = GetRoot(plr)
		local hit = mouse.Target
		local person = nil
		if hit and hit.Parent then
			if hit.Parent:IsA("Model") then
				person = game.Players:GetPlayerFromCharacter(hit.Parent)
			elseif hit.Parent:IsA("Accessory") then
				person = game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
			end
			if person then
				local pushpos = root.CFrame
				PredictionTP(person)
				task.wait(GetPing()+0.05)
				Push(person)
				root.CFrame = pushpos
			end
		end
	end

	ModdedPush.Activated:Connect(function()
		ActivateTool()
	end)
	ModdedPush.Parent = plr.Backpack
end)

MainTAB:Button("📍 ・ Potion Dick", function()
	if CheckPotion() then
		PotionTool.Parent = plr.Character
		PotionTool.GripUp = Vector3.new(1,0,0)
		PotionTool.GripPos = Vector3.new(1.5, 0.5, -1.1)
		PotionTool.Parent = plr.Backpack
		PotionTool.Parent = plr.Character
    else
		PotionTool.Parent = plr.Character
		PotionTool.GripUp = Vector3.new(0, 0, 0)
		PotionTool.GripPos = Vector3.new(0, 0, 0)
		PotionTool.Parent = plr.Backpack
		PotionTool.Parent = plr.Character
	end
end)


---- [ ] ----


MainTAB:Toggle("📌 ・ Anti Ragdoll", false, function(bool)

	AntiRagdollFunction = GetRoot(plr).ChildAdded:Connect(function(Force)
		if Force.Name == "PushForce" then
			Force.MaxForce = Vector3.new(0,0,0)
			Force.Velocity = Vector3.new(0,0,0)
		end
	end)

	ToggleRagdoll(bool)

end)

MainTAB:Toggle("📌 ・ Anti Fling", false, function(bool)
	
	local AntiFling = bool

	if AntiFling == true then
	    _G.AntiFlingToggled = true
	    loadstring(game:HttpGet('https://raw.githubusercontent.com/blackheartedcurse/punkz-Scripts/main/Anti%20fling.lua'))()
	else
		_G.AntiFlingToggled = false
	end
end)

MainTAB:Toggle("📌 ・ Touch Fling [FIXING]", false, function(bool)

	local fixpos = GetRoot(plr).Position
	ToggleVoidProtection(true)
	ToggleFling(bool)
	TeleportTO(fixpos.X,fixpos.Y,fixpos.Z,"pos","safe")
	ToggleVoidProtection(false)

end)

MainTAB:Toggle("📌 ・ Void Protection", false, function(bool)

	ToggleVoidProtection(bool)

end)

MainTAB:Toggle("📌 ・ Fake Lag", false, function(bool)
 
	_G.FakeLag = bool

	local LocalPlayer = game:GetService("Players").LocalPlayer
	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if _G.FakeLag then
	        while _G.FakeLag do
	            for i,v in pairs(game.Players:GetChildren()) do
	                HumanoidRootPart.Anchored = true
	            wait(0.2)
	                HumanoidRootPart.Anchored = false
	            wait()
            end
	end

end)




-- [ TAB #2 ] --

GameTAB:Button("📍 ・ Minefield", function()
	TeleportTO(-65, 23, -151,"pos","safe")
end)

GameTAB:Button("📍 ・ Balloon", function()
	TeleportTO(-118, 23, -126,"pos","safe")
end)

GameTAB:Button("📍 ・ Normal Stairs", function()
	TeleportTO(-6, 203, -496,"pos","safe")
end)

GameTAB:Button("📍 ・ Moving Stairs", function()
	TeleportTO(-210, 87, -224,"pos","safe")
end)

GameTAB:Button("📍 ・ Spiral Stairs", function()
	TeleportTO(151, 847, -306,"pos","safe")
end)

GameTAB:Button("📍 ・ Skyscraper", function()
	TeleportTO(142, 1033, -192,"pos","safe")
end)

GameTAB:Button("📍 ・ Pool", function()
	TeleportTO(-133, 65, -321,"pos","safe")
end)

---- [ ] ----

GameTAB:Button("📌 ・ Teleport Cannon #1", function()
	TeleportTO(-61, 34, -228,"pos","safe")
end)

GameTAB:Button("📌 ・ Teleport Cannon #2", function()
	TeleportTO(50, 34, -228,"pos","safe")
end)

GameTAB:Button("📌 ・ Teleport Cannon #3", function()
	TeleportTO(-6, 35, -106,"pos","safe")
end)




-- [ TAB #3 ] --

TargetTAB:Textbox("・ Set Target [FIXING]", true, function(t)
	local LabelText = TargetedPlayer
	local LabelTarget = GetPlayer(LabelText)
	UpdateTarget(LabelTarget)
end)

TargetTAB:Button("📍 ・ Goto", function()
	if TargetedPlayer ~= nil then
		TeleportTO(0,0,0,Players[TargetedPlayer],"safe")
	end
end)

TargetTAB:Button("📍 ・ Whitelist", function()
	if TargetedPlayer ~= nil then
		if table.find(ScriptWhitelist, Players[TargetedPlayer].UserId) then
			for i,v in pairs(ScriptWhitelist) do
				if v == Players[TargetedPlayer].UserId then
					table.remove(ScriptWhitelist, i)
				end
			end
			SendNotify("[NOTIFICATION]",TargetedPlayer.." Was removed from whitelist.",5)
		else
			table.insert(ScriptWhitelist, Players[TargetedPlayer].UserId)
			SendNotify("[NOTIFICATION]",TargetedPlayer.." Was added to whitelist.", 5)
		end
	end
end)

---- [ ] ----

TargetTAB:Toggle("📌 ・ View", false, function(bool)
	local ViewTarget = bool
	if TargetedPlayer ~= nil then
		if ViewTarget == print("Viewing")  then
			repeat
				pcall(function()
					game.Workspace.CurrentCamera.CameraSubject = Players[TargetedPlayer].Character.Humanoid
				end)
				task.wait(0.5)
			until ViewTarget == print("UnViewing")  
			game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
		end
	end
end)




-- [ TAB #4 ] --

MiscTAB:Slider("📌 ・ WalkSpeed", 5, 200, 16, function(value)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = (value)
end)

MiscTAB:Slider("📌 ・ JumpPower", 5, 450, 50, function(value)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (value)
end)

---- [ ] ----

MiscTAB:Button("📍 ・ Save Spawn", function()
	SavedCheckpoint = GetRoot(plr).Position
	SendNotify("[NOTIFICATION]", "Checkpoint saved successfully.", 5)
end)

MiscTAB:Button("📍 ・ Clear Spawn", function()
	SavedCheckpoint = nil
	SendNotify("[NOTIFICATION]", "Checkpoint cleared successfully.", 5)
end)




-- [ TAB #4 ] --

AnimTAB:Button("📍 ・ Vampire", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083445855"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083450166"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083473930"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083462077"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083455352"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083443587"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Hero", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616111295"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616113536"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616122287"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616117076"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616115533"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616104706"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616108001"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Zombie", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616158929"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616160636"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Mage", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=707742142"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=707855907"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=707897309"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=707861613"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=707853694"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=707826056"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Ghost", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Elder", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=845397899"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=845400520"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=845403856"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=845386501"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=845398858"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=845392038"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=845396048"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Levitation", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Astronaut", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=891621366"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=891633237"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=891667138"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=891636393"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=891627522"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=891609353"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=891617961"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Ninja", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=656117400"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=656118341"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=656121766"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=656118852"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=656114359"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=656115606"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Werewolf", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083195517"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083214717"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083178339"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083216690"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083218792"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083182000"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083189019"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Cartoon", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=742637544"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=742638445"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=742640026"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=742638842"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=742637942"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=742636889"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=742637151"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Pirate", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=750781874"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=750782770"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=750785693"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=750783738"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=750782230"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=750779899"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=750780242"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Sneaky", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1132473842"
    Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1132477671"
    Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1132510133"
    Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1132494274"
    Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1132489853"
    Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1132461372"
    Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1132469004"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Toy", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=782841498"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782845736"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=782843345"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=782842708"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=782847020"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=782843869"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=782846423"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)

AnimTAB:Button("📍 ・ Knight", function()
	local Animate = plr.Character.Animate
	Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=657595757"
	Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=657568135"
	Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=657552124"
	Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=657564596"
	Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=658409194"
	Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=658360781"
	Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=657600338"
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end)




-- [ TAB #5 ] --

CreditsTAB:Label("・ Owner   :  @donfushii")
CreditsTAB:Label("・ Tester    :  @ImperiumClothes")

CreditsTAB:Button("📍 ・ Copy Discord", function()
	setclipboard("discord.gg/UBcYG3sA")
end)

CreditsTAB:Colorpicker("📍 ・ UI Color",Color3.fromRGB(44, 120, 224), function(t)
    ImperiumLib:ChangePresetColor(Color3.fromRGB(t.R * 255, t.G * 255, t.B * 255))
end)
