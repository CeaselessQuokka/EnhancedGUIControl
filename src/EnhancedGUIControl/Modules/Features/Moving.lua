--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)

--- Functions ---
local function Move(gui, direction)
	local size = gui.Size
	local multiplier = nil

	if direction == "MoveUpLeft" then
		multiplier = Vector2.new(-1, -1)
	elseif direction == "MoveUp" then
		multiplier = Vector2.new(0, -1)
	elseif direction == "MoveUpRight" then
		multiplier = Vector2.new(1, -1)
	elseif direction == "MoveLeft" then
		multiplier = Vector2.new(-1, 0)
	elseif direction == "MoveRight" then
		multiplier = Vector2.new(1, 0)
	elseif direction == "MoveDownLeft" then
		multiplier = Vector2.new(-1, 1)
	elseif direction == "MoveDown" then
		multiplier = Vector2.new(0, 1)
	elseif direction == "MoveDownRight" then
		multiplier = Vector2.new(1, 1)
	end

	if multiplier then
		local sizeX = size.X
		local sizeY = size.Y
		local multiplierX = multiplier.X
		local multiplierY = multiplier.Y

		local positionOffset = UDim2.new(
			sizeX.Scale * multiplierX, sizeX.Offset * multiplierX,
			sizeY.Scale * multiplierY, sizeY.Offset * multiplierY
		)

		gui.Position = gui.Position + positionOffset
	end
end

local function MoveGuis(direction)
	if direction:match("^Move") then
		ChangeHistoryService:SetWaypoint("BeforeGuiMoving")

		for _, gui in ipairs(Selection:Get()) do
			if gui:IsA("GuiObject") then
				Move(gui, direction)
			end
		end

		ChangeHistoryService:SetWaypoint("AfterGuiMoving")
	end
end

--- Aligning ---
local Connections = {}
local Moving = {}

function Moving.Connect()
	Moving.Disconnect()
	Connections[#Connections + 1] = Event.new("KeybindFired", MoveGuis)
end

function Moving.Disconnect()
	for index = #Connections, 1, - 1 do
		table.remove(Connections, index):Disconnect()
	end
end

return Moving
