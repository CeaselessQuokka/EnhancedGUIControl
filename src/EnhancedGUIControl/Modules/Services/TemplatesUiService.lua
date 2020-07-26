--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local WidgetService = require(script.Parent.WidgetService)
local ApiDumpService = require(script.Parent.ApiDumpService)
local TemplatesService = require(script.Parent.TemplatesService)
local TemplatesFeature = require(script.Parent.Parent.Features.Templates)

--- SettingsUiService ---
local Plugin = nil
local Templates = {}
local Connections = {}
local StartedOnce = false
local PopupConnections = {}
local SelectedTemplateData = nil
local TemplatesUiService = {}

function TemplatesUiService.StartService(plugin)
	if not StartedOnce then
		Plugin = plugin
		StartedOnce = true

		for _, templateData in ipairs(TemplatesService.GetTemplates()) do
			TemplatesUiService._createTemplate(templateData)
		end

		TemplatesUiService._updateCanvasSize()
	end

	Connections[#Connections + 1] = Event.new("CreateTemplate", function(id, className, properties)
		TemplatesUiService._createTemplate(select(2, TemplatesService.Add(id, className, properties)))
		TemplatesUiService._updateCanvasSize()
	end)

	Connections[#Connections + 1] = WidgetService.TemplatesBackButton.MouseButton1Click:Connect(function()
		WidgetService.MainMenu.Visible = true
		WidgetService.TemplatesMenu.Visible = false
		TemplatesUiService._cleanPopupConnections()
	end)

	Connections[#Connections + 1] = WidgetService.TemplateCreateButton.MouseButton1Click:Connect(function()
		local popup = WidgetService.CreateTemplatePopup
		TemplatesUiService._cleanPopupConnections()
		popup.Visible = true
		WidgetService.ConfirmPopup.Visible = false

		PopupConnections[#PopupConnections + 1] = popup.Confirm.MouseButton1Click:Connect(function()
			local input = popup.Input.Content.Text

			if #input > 0 then
				for _, gui in ipairs(Selection:Get()) do
					if gui:IsA("GuiObject") then
						local className = gui.ClassName
						local properties = ApiDumpService.GetProperties(className, true)
						local propertiesMap = {}

						for _, property in ipairs(properties) do
							propertiesMap[property] = gui[property]
						end

						if not TemplatesService.GetTemplateById(input) then
							popup.Visible = false
							TemplatesUiService._cleanPopupConnections()
							WidgetService.TemplatesMenu.Visible = false
							WidgetService.TemplateEditorMenu.Visible = true
							Event.Fire("EditTemplate", input, className, propertiesMap)
						else
							warn("A template by the same name already exists.")
						end

						return
					end
				end

				warn("You must select a GuiObject (Frame, ScrollingFrame, TextLabel/Image, etc) as a template.")
			else
				warn("A template's name cannot be blank.")
			end
		end)

		PopupConnections[#PopupConnections + 1] = popup.Cancel.MouseButton1Click:Connect(function()
			popup.Visible = false
			TemplatesUiService._cleanPopupConnections()
		end)
	end)

	Connections[#Connections + 1] = WidgetService.TemplatesResetButton.MouseButton1Click:Connect(function()
		local popup = WidgetService.ConfirmPopup
		popup.Message.Text = "Are you sure you want to delete all your templates? This CANNOT be undone."
		TemplatesUiService._cleanPopupConnections()
		popup.Visible = true

		PopupConnections[#PopupConnections + 1] = popup.Confirm.MouseButton1Click:Connect(function()
			popup.Visible = false
			TemplatesUiService._cleanPopupConnections()
			TemplatesService.ResetToDefaults()

			for _, templateGui in ipairs(WidgetService.TemplatesList:GetChildren()) do
				if templateGui.ClassName == WidgetService.TemplateTemplate.ClassName then
					templateGui:Destroy()
				end
			end

			WidgetService.TemplatesList.CanvasSize = UDim2.new(0, 0, 0, 0)
		end)

		PopupConnections[#PopupConnections + 1] = popup.Cancel.MouseButton1Click:Connect(function()
			popup.Visible = false
			TemplatesUiService._cleanPopupConnections()
		end)
	end)
end

function TemplatesUiService.Clean()
	for index = #Connections, 1, -1 do
		table.remove(Connections, index):Disconnect()
	end

	SelectedTemplateData = nil
	TemplatesUiService._cleanPopupConnections()
end

function TemplatesUiService._createTemplate(templateData)
	local templateGui = WidgetService.TemplateTemplate:Clone()
	local templatePreview = Instance.new(templateData.ClassName)
	templateGui.Name = templateData.Id
	templateGui.Title.Text = templateData.Id
	templatePreview.Parent = templateGui.Background
	templateGui.Parent = WidgetService.TemplatesList

	for property, value in pairs(templateData.Properties) do
		templatePreview[property] = value
	end

	templatePreview.ZIndex = 10

	if not templateData.Properties.Size then
		templatePreview.Size = UDim2.new(1, 0, 1, 0)
	end

	Templates[templateData.Id] = templateGui

	templateGui.Button.MouseButton1Click:Connect(function()
		SelectedTemplateData = templateData
		TemplatesUiService._showMenu()
	end)
end

function TemplatesUiService._updateCanvasSize()
	WidgetService.TemplatesList.CanvasSize = UDim2.new(
		0, 0,
		0, WidgetService.TemplatesLayout.AbsoluteContentSize.Y + 8
	)
end

function TemplatesUiService._showMenu()
	local menu = Plugin:CreatePluginMenu("QDT_EnhancedGUIControl_TEMPLATE_MENU", "Template Actions")

	menu:AddNewAction("Apply_Template", "Apply Template to All Selected GUIs").Triggered:Connect(function()
		TemplatesFeature.ApplyTemplate(SelectedTemplateData)
		SelectedTemplateData = nil
	end)

	menu:AddNewAction("Insert_Template", "Insert Template Into All Selected LayerCollectors").Triggered:Connect(function()
		ChangeHistoryService:SetWaypoint("BeforeGuiTemplateInsertion")

		for _, layerCollector in ipairs(Selection:Get()) do
			if layerCollector:IsA("LayerCollector") and layerCollector.ClassName ~= "PluginGui" then
				local template = Instance.new(SelectedTemplateData.ClassName)

				for property, value in pairs(SelectedTemplateData.Properties) do
					template[property] = value
				end

				if not SelectedTemplateData.Properties.Name then
					template.Name = SelectedTemplateData.Id
				end

				template.Parent = layerCollector
			end
		end

		ChangeHistoryService:SetWaypoint("AfterGuiTemplateInsertion")
		SelectedTemplateData = nil
	end)

	menu:AddNewAction("Delete_Template", "Delete Template").Triggered:Connect(function()
		local id = SelectedTemplateData.Id
		Templates[id]:Destroy()
		Templates[id] = nil
		TemplatesService.Remove(id)
		SelectedTemplateData = nil
		TemplatesUiService._updateCanvasSize()
	end)

	menu:ShowAsync()
	menu:Destroy()
end

function TemplatesUiService._cleanPopupConnections()
	for index = #PopupConnections, 1, -1 do
		table.remove(PopupConnections, index):Disconnect()
	end
end

return TemplatesUiService
