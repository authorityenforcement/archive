-- This shi is universal btw.

local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Player.LocalPlayer

-- I copied TerminalVibes work flow because i wanna be like him XD
-- he still neg diffs me through knowledge of coding tho :(
-- Managers, the stuff where it does the work
local ProximityManager = {Proximities = {}}

function ProximityManager:Add(prompt)
	if prompt:IsA("ProximityPrompt") then
		table.insert(self.Proximities, prompt)
	end
end

function ProximityManager:Remove(prompt)
	local t = self.Proximities
	for i = 1, #t do
		if t[i] == prompt then
			t[i] = t[#t]
			t[#t] = nil
			break
		end
	end
end

function ProximityManager:Pulse()
	local validPrompts = {}
	local tIdx = 0

	-- Filter out invalid parents
	-- also this shi is unnecessary for most games
	-- but who cares.
	for i = 1, #self.Proximities do
        local t = self.Proximities[i]
        if t:IsDescendantOf(workspace) then
            tIdx = tIdx + 1
            validPrompts[tIdx] = t
        end
    end

	for i = 1, tIdx do
		local main = validPrompts[i]
		if main.Enabled then
			local parent = main.Parent
			local pos = parent:IsA("BasePart") and parent.Position
				or parent:IsA("Attachment") and parent.WorldPosition
				or parent:IsA("Model") and parent:GetPivot().Position
			
			if pos and LocalPlayer:DistanceFromCharacter(pos) < 5 then
				fireproximityprompt(main)
			end
		end
	end
end


-- Init ye 
local queried = workspace:QueryDescendants("ProximityPrompt")
for _, v in ipairs(queried) do
	ProximityManager:Add(v)
end

workspace.DescendantAdded:Connect(function(inst)
	ProximityManager:Add(inst)
end)
workspace.DescendantRemoving:Connect(function(inst)
	if inst:IsA("ProximityPrompt") then ProximityManager:Remove(inst) end
end)
RunService.RenderStepped:Connect(function()
	ProximityManager:Pulse()
end)
