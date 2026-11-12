local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GMLK = require(ReplicatedStorage.Modules.Library.GMLK)

local CoinCounter = { Priority = 10 }

function CoinCounter:Init()
	self.Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AddCoin")
end

function CoinCounter:Start()
	local Gui = Instance.new("ScreenGui")
	Gui.Name = "GMLKCoinCounter"
	Gui.ResetOnSpawn = false
	Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	local Button = Instance.new("TextButton")
	Button.Name = "AddCoin"
	Button.Size = UDim2.fromOffset(240, 52)
	Button.Position = UDim2.fromScale(0.5, 0.5)
	Button.AnchorPoint = Vector2.new(0.5, 0.5)
	Button.Text = "Add coin"
	Button.TextSize = 22
	Button.Parent = Gui

	Button.Activated:Connect(function()
		task.spawn(function()
			local Success, Balance, Detail = pcall(self.Remote.InvokeServer, self.Remote, 1)
			if not Success then
				warn("[GMLK Coin Counter] Request failed:", Balance)
			elseif type(Balance) == "number" then
				print("[GMLK Coin Counter] Coin added. Balance: " .. GMLK.Number.Abbreviate(Balance, 0))
			elseif type(Detail) == "number" then
				warn("[GMLK Coin Counter] Rate limited. Retry in " .. math.ceil(Detail) .. "s")
			else
				warn("[GMLK Coin Counter] Request rejected:", Detail or Balance)
			end
		end)
	end)
end

return CoinCounter
