--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)

--- Functions ---
local function SwapGuis(id)
	if id == "SwapPositions" then
		ChangeHistoryService:SetWaypoint("BeforeGuiSwapping")

		local gui1 = nil
		local gui2 = nil

		for _, gui in ipairs(Selection:Get()) do
			if gui:IsA("GuiObject") then
				if gui1 then
					gui2 = gui
					break
				else
					gui1 = gui
				end
			end
		end

		if gui1 and gui2 then
			gui1.Position, gui2.Position = gui2.Position, gui1.Position
			gui1.AnchorPoint, gui2.AnchorPoint = gui2.AnchorPoint, gui1.AnchorPoint
		else
			warn("You must select two GUIs in order to swap their positions.")
		end

		ChangeHistoryService:SetWaypoint("AfterGuiSwapping")
	end
end

--- Aligning ---
local Connections = {}
local Swapping = {}

function Swapping.Connect()
	Swapping.Disconnect()
	Connections[#Connections + 1] = Event.new("KeybindFired", SwapGuis)
end

function Swapping.Disconnect()
	for index = #Connections, 1, - 1 do
		table.remove(Connections, index):Disconnect()
	end
end

return Swapping
