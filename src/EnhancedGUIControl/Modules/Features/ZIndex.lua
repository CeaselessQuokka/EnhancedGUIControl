--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local SettingsService = require(script.Parent.Parent.Services.SettingsService)

--- Functions ---
local function ChangeZIndex(id)
	if id:match("ZIndex$") then
		local zIndexInc = SettingsService.Get("ZIndexIncrement")
		ChangeHistoryService:SetWaypoint("BeforeGuiZIndex")

		if id == "DecrementZIndex" then
			for _, gui in ipairs(Selection:Get()) do
				if gui:IsA("GuiObject") then
					gui.ZIndex = gui.ZIndex - zIndexInc
				end
			end
		else
			for _, gui in ipairs(Selection:Get()) do
				if gui:IsA("GuiObject") then
					gui.ZIndex = gui.ZIndex + zIndexInc
				end
			end
		end

		ChangeHistoryService:SetWaypoint("AfterGuiZIndex")
	end
end

--- Aligning ---
local Connections = {}
local ZIndex = {}

function ZIndex.Connect()
	ZIndex.Disconnect()
	Connections[#Connections + 1] = Event.new("KeybindFired", ChangeZIndex)
end

function ZIndex.Disconnect()
	for index = #Connections, 1, - 1 do
		table.remove(Connections, index):Disconnect()
	end
end

return ZIndex
