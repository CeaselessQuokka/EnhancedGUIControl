--- Imports ---
local WidgetService = require(script.Parent.WidgetService)
local SettingsService = require(script.Parent.SettingsService)
local SettingController = require(script.Parent.Parent.Ui.Setting)

--- SettingsUiService ---
local Settings = {}
local Connections = {}
local StartedOnce = false
local PopupConnections = {}
local SettingsUiService = {}

function SettingsUiService.StartService()
	if not StartedOnce then
		StartedOnce = true

		for _, settingData in ipairs(SettingsService.GetSettings()) do
			if settingData.DataType == "Boolean" then
				local settingObject = SettingController.new(settingData.Id, settingData.Value)
				local settingGui = settingObject.Setting
				settingGui.Setting.Text = settingData.DisplayName
				settingGui.Description.Text = settingData.Description
				settingGui.Parent = WidgetService.SettingsList
				settingObject:Disconnect()
				Settings[settingData.Id] = settingObject
			elseif settingData.DataType == "Integer" then
				local settingGui = WidgetService.InputTemplate:Clone()
				settingGui.Name = settingData.Id
				settingGui.Setting.Text = settingData.DisplayName
				settingGui.Description.Text = settingData.Description
				settingGui.Input.Content.Text = settingData.Value
				settingGui.Parent = WidgetService.SettingsList
				Settings[settingData.Id] = settingGui
			end
		end

		WidgetService.SettingsList.CanvasSize = UDim2.new(0, 0, 0, WidgetService.SettingsLayout.AbsoluteContentSize.Y)
	end

	for _, setting in pairs(Settings) do
		if type(setting) == "table" then
			setting:Connect()
		else
			Connections[#Connections + 1] = setting.Input.Content.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					local successful, value = SettingsService.Set(setting.Name, setting.Input.Content.Text)

					if not successful then
						setting.Input.Content.Text = value
					end
				end
			end)
		end
	end

	Connections[#Connections + 1] = WidgetService.SettingsBackButton.MouseButton1Click:Connect(function()
		WidgetService.MainMenu.Visible = true
		WidgetService.SettingsMenu.Visible = false
		SettingsUiService._cleanPopupConnections()
	end)

	Connections[#Connections + 1] = WidgetService.SettingsResetButton.MouseButton1Click:Connect(function()
		local popup = WidgetService.ConfirmPopup
		popup.Message.Text = "Are you sure you want to reset all your settings to their defaults? This CANNOT be undone."
		SettingsUiService._cleanPopupConnections()
		popup.Visible = true

		PopupConnections[#PopupConnections + 1] = popup.Confirm.MouseButton1Click:Connect(function()
			popup.Visible = false
			SettingsUiService._cleanPopupConnections()
			SettingsService.ResetToDefaults()

			for _, settingData in ipairs(SettingsService.GetSettings()) do
				local setting = Settings[settingData.Id]

				if type(setting) == "table" then
					setting:Update(settingData.Value)
				else
					setting.Input.Content.Text = settingData.Value
				end
			end
		end)

		PopupConnections[#PopupConnections + 1] = popup.Cancel.MouseButton1Click:Connect(function()
			popup.Visible = false
			SettingsUiService._cleanPopupConnections()
		end)
	end)
end

function SettingsUiService.Clean()
	for _, settingObject in pairs(Settings) do
		if type(settingObject) == "table" then
			settingObject:Disconnect()
		end
	end

	for index = #Connections, 1, -1 do
		table.remove(Connections, index):Disconnect()
	end

	SettingsUiService._cleanPopupConnections()
end

function SettingsUiService._cleanPopupConnections()
	for index = #PopupConnections, 1, -1 do
		table.remove(PopupConnections, index):Disconnect()
	end
end

return SettingsUiService
