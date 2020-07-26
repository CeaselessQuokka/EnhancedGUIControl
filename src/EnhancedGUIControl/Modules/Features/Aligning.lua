--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)

--- Functions ---
local function Align(gui, alignment)
	local position = nil

	if alignment == "TopLeftAlign" then
		position = Vector2.new(0, 0)
	elseif alignment == "TopCenterAlign" then
		position = Vector2.new(0.5, 0)
	elseif alignment == "TopRightAlign" then
		position = Vector2.new(1, 0)
	elseif alignment == "CenterLeftAlign" then
		position = Vector2.new(0, 0.5)
	elseif alignment == "CenterAlign" then
		position = Vector2.new(0.5, 0.5)
	elseif alignment == "CenterRightAlign" then
		position = Vector2.new(1, 0.5)
	elseif alignment == "BottomLeftAlign" then
		position = Vector2.new(0, 1)
	elseif alignment == "BottomCenterAlign" then
		position = Vector2.new(0.5, 1)
	elseif alignment == "BottomRightAlign" then
		position = Vector2.new(1, 1)
	end

	if position then
		gui.Position = UDim2.new(position.X, 0, position.Y, 0)
		gui.AnchorPoint = position
	end
end

local function AlignGuis(alignment)
	if alignment:match("Align$") then
		ChangeHistoryService:SetWaypoint("BeforeGuiAlignment")

		for _, gui in ipairs(Selection:Get()) do
			if gui:IsA("GuiObject") then
				Align(gui, alignment)
			end
		end

		ChangeHistoryService:SetWaypoint("AfterGuiAlignment")
	end
end

--- Aligning ---
local Connections = {}
local Aligning = {}

function Aligning.Connect()
	Aligning.Disconnect()
	Connections[#Connections + 1] = Event.new("KeybindFired", AlignGuis)
end

function Aligning.Disconnect()
	for index = #Connections, 1, - 1 do
		table.remove(Connections, index):Disconnect()
	end
end

Aligning.Align = Align
return Aligning
