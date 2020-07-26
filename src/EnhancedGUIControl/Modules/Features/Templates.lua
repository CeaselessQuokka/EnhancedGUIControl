--- Services ---
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local ApiDumpService = require(script.Parent.Parent.Services.ApiDumpService)
local TemplatesService = require(script.Parent.Parent.Services.TemplatesService)

--- Functions ---
local function Apply(templateData)
	ChangeHistoryService:SetWaypoint("BeforeGuiTemplates")

	for _, gui in ipairs(Selection:Get()) do
		if gui:IsA("GuiObject") then
			if gui.ClassName == templateData.ClassName then
				for property, value in pairs(templateData.Properties) do
					gui[property] = value
				end
			else
				local guiProperties = ApiDumpService.GetProperties(gui.ClassName, true)
				local guiPropertiesMap = {}
				local templateProperties = templateData.Properties

				for _, property in ipairs(guiProperties) do
					guiPropertiesMap[property] = true
				end

				for property, value in pairs(templateProperties) do
					if guiPropertiesMap[property] then
						gui[property] = value
					end
				end
			end
		end
	end

	ChangeHistoryService:SetWaypoint("AfterGuiTemplates")
end

local function ApplyTemplate(id)
	if id:match("^Template%d") then
		local templateData = TemplatesService.GetTemplateByIndex(tonumber(id:match("(%d)$")))

		if templateData then
			Apply(templateData)
		else
			warn("A template for that keybind doesn't exist.")
		end
	elseif id:match("^TemplateInsertion%d") then
		local templateData = TemplatesService.GetTemplateByIndex(tonumber(id:match("(%d)$")))

		if templateData then
			ChangeHistoryService:SetWaypoint("BeforeGuiTemplateInsertion")

			for _, layerCollector in ipairs(Selection:Get()) do
				if layerCollector:IsA("LayerCollector") and layerCollector.ClassName ~= "PluginGui" then
					local template = Instance.new(templateData.ClassName)

					for property, value in pairs(templateData.Properties) do
						template[property] = value
					end

					if not templateData.Properties.Name then
						template.Name = templateData.Id
					end

					template.Parent = layerCollector
				end
			end

			ChangeHistoryService:SetWaypoint("AfterGuiTemplateInsertion")
		else
			warn("A template for that keybind doesn't exist.")
		end
	end
end

--- Aligning ---
local Connections = {}
local Templates = {}

function Templates.Connect()
	Templates.Disconnect()
	Connections[#Connections + 1] = Event.new("KeybindFired", ApplyTemplate)
end

function Templates.Disconnect()
	for index = #Connections, 1, - 1 do
		table.remove(Connections, index):Disconnect()
	end
end

Templates.ApplyTemplate = Apply
return Templates
