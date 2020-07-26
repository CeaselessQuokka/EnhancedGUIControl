--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local WidgetService = require(script.Parent.WidgetService)

--- SettingsUiService ---
local State = {
	Connections = {}
}

local Connections = {}
local TemplatesEditorUiService = {}

function TemplatesEditorUiService.StartService()
	Connections[#Connections + 1] = WidgetService.TemplateScrapButton.MouseButton1Click:Connect(function()
		WidgetService.TemplateEditorMenu.Visible = false
		TemplatesEditorUiService._cleanState()
		WidgetService.TemplatesMenu.Visible = true
	end)

	Connections[#Connections + 1] = WidgetService.TemplateSaveButton.MouseButton1Click:Connect(function()
		WidgetService.TemplateEditorMenu.Visible = false
		Event.Fire("CreateTemplate", State.Id, State.ClassName, State.Properties)
		TemplatesEditorUiService._cleanState()
		WidgetService.TemplatesMenu.Visible = true
	end)

	Connections[#Connections + 1] = Event.new("EditTemplate", function(id, className, properties)
		local layoutOrder = 0
		local previewGui = Instance.new(className)
		local editedProperties = {}
		local defaultProperties = {}
		State.Id = id
		State.ClassName = className
		State.Properties = editedProperties
		State.PreviewGui = previewGui
		previewGui.Parent = WidgetService.TemplateEditorMenu.Viewport.Background

		for property, value in pairs(properties) do
			local propertyGui = WidgetService.PropertyTemplate:Clone()
			propertyGui.Property.Text = property
			propertyGui.Parent = WidgetService.TemplatesEditorList
			defaultProperties[property] = previewGui[property]

			if previewGui[property] ~= value then
				layoutOrder = layoutOrder - 1

				if property == "ZIndex" then
					previewGui[property] = 10
				else
					previewGui[property] = value
				end

				propertyGui.LayoutOrder = layoutOrder
				editedProperties[property] = value
				TemplatesEditorUiService._check(propertyGui)
			else
				if property == "ZIndex" then
					previewGui[property] = 10
				elseif property == "Size" then
					previewGui[property] = UDim2.new(1, 0, 1, 0)
				end

				TemplatesEditorUiService._uncheck(propertyGui)
			end

			State.Connections[#State.Connections + 1] = propertyGui.Checkbox.MouseButton1Click:Connect(function()
				if editedProperties[property] ~= nil then
					if property == "ZIndex" then
						previewGui[property] = 10
					elseif property == "Size" then
						previewGui[property] = UDim2.new(1, 0, 1, 0)
					else
						previewGui[property] = defaultProperties[property]
					end

					editedProperties[property] = nil
					TemplatesEditorUiService._uncheck(propertyGui)
				else
					if property == "ZIndex" then
						previewGui[property] = 10
					else
						previewGui[property] = value
					end

					editedProperties[property] = value
					TemplatesEditorUiService._check(propertyGui)
				end
			end)
		end

		WidgetService.TemplatesEditorList.CanvasSize = UDim2.new(
			0, 0,
			0, WidgetService.TemplatesEditorLayout.AbsoluteContentSize.Y
		)
	end)
end

function TemplatesEditorUiService.Clean()
	TemplatesEditorUiService._cleanState()

	for index = #Connections, 1, -1 do
		table.remove(Connections, index):Disconnect()
	end

	if WidgetService.TemplateEditorMenu.Visible then
		WidgetService.MainMenu.Visible = true
		WidgetService.TemplateEditorMenu.Visible = false
	end
end

function TemplatesEditorUiService._check(propertyGui)
	local checkbox = propertyGui.Checkbox
	local checkboxTick = checkbox.Tick
	local checkboxInner = checkbox.Checkbox
	checkbox.ImageColor3 = Color3.fromRGB(134, 194, 240)
	checkboxTick.Visible = true
	checkboxInner.Visible = false
end

function TemplatesEditorUiService._uncheck(propertyGui)
	local checkbox = propertyGui.Checkbox
	local checkboxTick = checkbox.Tick
	local checkboxInner = checkbox.Checkbox
	checkbox.ImageColor3 = Color3.fromRGB(120, 120, 120)
	checkboxTick.Visible = false
	checkboxInner.Visible = true
end

function TemplatesEditorUiService._cleanState()
	local connections = State.Connections
	State.Id = nil
	State.ClassName = nil
	State.Properties = nil

	if State.PreviewGui then
		State.PreviewGui:Destroy()
	end

	State.PreviewGui = nil

	for index = #connections, 1, -1 do
		table.remove(connections, index):Disconnect()
	end

	for _, gui in ipairs(WidgetService.TemplatesEditorList:GetChildren()) do
		if gui.ClassName == WidgetService.PropertyTemplate.ClassName then
			gui:Destroy()
		end
	end
end

return TemplatesEditorUiService
