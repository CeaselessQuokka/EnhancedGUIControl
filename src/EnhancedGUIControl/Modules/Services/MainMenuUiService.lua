--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local WidgetService = require(script.Parent.WidgetService)
local AligningFeature = require(script.Parent.Parent.Features.Aligning)
local SettingsService = require(script.Parent.SettingsService)

--- Constants ---
local INTEREST_NAME = "QDT_EnhancedGUIControl_ALIGNMENT_INTEREST"

--- MainMenuUiService ---
local Connections = {}
local AlignmentConnections = {}
local MainMenuUiService = {}

function MainMenuUiService.StartService()
	for _, button in ipairs(WidgetService.MainMenuButtons:GetChildren()) do
		Connections[#Connections + 1] = button.MouseButton1Click:Connect(function()
			for _, menu in ipairs(WidgetService.Menus:GetChildren()) do
				menu.Visible = menu.Name == button.Name
			end
		end)
	end

	Connections[#Connections + 1] = Selection.SelectionChanged:Connect(function()
		if SettingsService.Get("ShowAlignmentGUI") then
			for _, gui in ipairs(Selection:Get()) do
				if gui:IsA("GuiObject") then
					MainMenuUiService._setupAlignment(gui)
					return
				end
			end
		end

		MainMenuUiService._cleanAlignmentConnections()
	end)

	Connections[#Connections + 1] = Event.new("SettingChanged", function(id, value)
		if id == "ShowAlignmentGUI" then
			if value then
				for _, gui in ipairs(Selection:Get()) do
					if gui:IsA("GuiObject") then
						MainMenuUiService._setupAlignment(gui)
						break
					end
				end
			else
				MainMenuUiService._cleanAlignmentConnections()
			end
		end
	end)

	if SettingsService.Get("ShowAlignmentGUI") then
		for _, gui in ipairs(Selection:Get()) do
			if gui:IsA("GuiObject") then
				MainMenuUiService._setupAlignment(gui)
				break
			end
		end
	end
end

function MainMenuUiService.Clean()
	for index = #Connections, 1, -1 do
		table.remove(Connections, index):Disconnect()
	end

	MainMenuUiService._cleanAlignmentConnections()
end

function MainMenuUiService._setupAlignment(gui)
	MainMenuUiService._cleanAlignmentConnections()
	local root = gui
	local interest = Instance.new("StringValue")
	interest.Name = INTEREST_NAME
	interest.Parent = gui

	while root and not root:IsA("LayerCollector") and root.ClassName ~= "PluginGui" do
		root = root.Parent
	end

	if root then
		for _, guiObject in ipairs(root:GetChildren()) do
			guiObject:Clone().Parent = WidgetService.GuiCopyContainer
		end

		local interestCopy = WidgetService.GuiCopyContainer:FindFirstChild(INTEREST_NAME, true)
		local guiCopy = interestCopy.Parent
		local buttons = WidgetService.AlignmentButtons:Clone()

		if gui.Parent.AbsoluteSize.X < gui.Parent.AbsoluteSize.Y then
			for _, button in ipairs(buttons:GetChildren()) do
				button.SizeConstraint = Enum.SizeConstraint.RelativeXX
			end
		end

		buttons.Parent = guiCopy.Parent
		interest:Destroy()

		for _, button in ipairs(buttons:GetChildren()) do
			AlignmentConnections[#AlignmentConnections + 1] = button.MouseButton1Click:Connect(function()
				ChangeHistoryService:SetWaypoint("BeforeGuiAlignment")
				AligningFeature.Align(gui, button.Name)
				AligningFeature.Align(guiCopy, button.Name)
				ChangeHistoryService:SetWaypoint("AfterGuiAlignment")
			end)
		end

		AlignmentConnections[#AlignmentConnections + 1] = gui:GetPropertyChangedSignal("Parent"):Connect(function()
			MainMenuUiService._setupAlignment(gui)
		end)
	else
		if SettingsService.Get("ShowGUISelectionWarning") then
			warn(("No ScreenGui, SurfaceGui, or BillboardGui root found for %q."):format(gui.Name))
		end
	end

	interest:Destroy()
end

function MainMenuUiService._cleanAlignmentConnections()
	for index = #AlignmentConnections, 1, -1 do
		table.remove(AlignmentConnections, index):Disconnect()
	end

	WidgetService.GuiCopyContainer:ClearAllChildren()
end

return MainMenuUiService
