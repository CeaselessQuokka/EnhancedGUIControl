--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)

--- Functions ---
local function Align(gui, alignment)
	local guiPosition = gui.Position
	local guiAnchorPoint = gui.AnchorPoint

	if alignment == "TopConstrainedAlign" then
		gui.Position = UDim2.new(guiPosition.X.Scale, guiPosition.X.Offset, 0, 0)
		gui.AnchorPoint = Vector2.new(guiAnchorPoint.X, 0)
	elseif alignment == "LeftConstrainedAlign" then
		gui.Position = UDim2.new(0, 0, guiPosition.Y.Scale, guiPosition.Y.Offset)
		gui.AnchorPoint = Vector2.new(0, guiAnchorPoint.Y)
	elseif alignment == "RightConstrainedAlign" then
		gui.Position = UDim2.new(1, 0, guiPosition.Y.Scale, guiPosition.Y.Offset)
		gui.AnchorPoint = Vector2.new(1, guiAnchorPoint.Y)
	elseif alignment == "BottomConstrainedAlign" then
		gui.Position = UDim2.new(guiPosition.X.Scale, guiPosition.X.Offset, 1, 0)
		gui.AnchorPoint = Vector2.new(guiAnchorPoint.X, 1)
	end
end

local function AlignGuis(alignment)
	if alignment:match("ConstrainedAlign$") then
		ChangeHistoryService:SetWaypoint("BeforeGuiConstrainedAlignment")

		for _, gui in ipairs(Selection:Get()) do
			if gui:IsA("GuiObject") then
				Align(gui, alignment)
			end
		end

		ChangeHistoryService:SetWaypoint("AfterGuiConstrainedAlignment")
	end
end

--- ConstrainedAligning ---
local Connections = {}
local ConstrainedAligning = {}

function ConstrainedAligning.Connect()
	ConstrainedAligning.Disconnect()
	Connections[#Connections + 1] = Event.new("KeybindFired", AlignGuis)
end

function ConstrainedAligning.Disconnect()
	for index = #Connections, 1, - 1 do
		table.remove(Connections, index):Disconnect()
	end
end

return ConstrainedAligning
