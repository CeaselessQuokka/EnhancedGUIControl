--- Services ---
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local WidgetService = require(script.Parent.WidgetService)
local KeybindsService = require(script.Parent.KeybindsService)
local SettingsService = require(script.Parent.SettingsService)

--- SettingsUiService ---
local Editing = {}
local Keybinds = {}
local Connections = {}
local StartedOnce = false
local PopupConnections = {}
local InputConnections = {}
local KeybindsUiService = {}

function KeybindsUiService.StartService()
	if not StartedOnce then
		StartedOnce = true

		for _, keybind in ipairs(KeybindsService.GetKeybinds()) do
			local keybindGui = WidgetService.KeybindTemplate:Clone()
			keybindGui.Name = keybind.Id
			keybindGui.Id.Text = keybind.Name
			keybindGui.Description.Text = keybind.Description
			KeybindsUiService._createKeys(keybindGui, keybind.Keys)
			keybindGui.Parent = WidgetService.KeybindsList
			Keybinds[keybind.Id] = keybindGui
		end

		WidgetService.KeybindsList.CanvasSize = UDim2.new(0, 0, 0, WidgetService.KeybindsLayout.AbsoluteContentSize.Y)
	end

	for id, keybindGui in pairs(Keybinds) do
		Connections[#Connections + 1] = keybindGui.Edit.MouseButton1Click:Connect(function()
			local keybind = KeybindsService.GetKeybindById(id)

			if Editing.Gui then
				KeybindsUiService._createKeys(Editing.Gui, Editing.Keys)
				Editing.Gui.Editing.Visible = false
				Editing.Gui.Id.Size = UDim2.new(1, -110, 0, 20)
				Editing.Gui.Id.Position = UDim2.new(0, 0, 0, 0)
				KeybindsUiService._cleanInputConnections()
			end

			Editing.Gui = keybindGui
			Editing.Keys = keybind.Keys
			Editing.Gui.Editing.Visible = true
			Editing.Gui.Id.Size = UDim2.new(1, -135, 0, 20)
			Editing.Gui.Id.Position = UDim2.new(0, 25, 0, 0)
			KeybindsUiService._connectInput(keybindGui, keybind)
		end)
	end

	Connections[#Connections + 1] = WidgetService.KeybindsBackButton.MouseButton1Click:Connect(function()
		WidgetService.MainMenu.Visible = true
		WidgetService.KeybindsMenu.Visible = false

		if Editing.Gui then
			KeybindsUiService._createKeys(Editing.Gui, Editing.Keys)
			Editing.Gui.Editing.Visible = false
			Editing.Gui.Id.Size = UDim2.new(1, -110, 0, 20)
			Editing.Gui.Id.Position = UDim2.new(0, 0, 0, 0)
			KeybindsUiService._cleanInputConnections()
			KeybindsService.Connect()
		else
			KeybindsUiService._cleanInputConnections()
			KeybindsService.Connect()
		end
	end)

	Connections[#Connections + 1] = WidgetService.KeybindsResetButton.MouseButton1Click:Connect(function()
		if Editing.Gui then
			KeybindsUiService._createKeys(Editing.Gui, Editing.Keys)
			Editing.Gui.Editing.Visible = false
			Editing.Gui.Id.Size = UDim2.new(1, -110, 0, 20)
			Editing.Gui.Id.Position = UDim2.new(0, 0, 0, 0)
			KeybindsUiService._cleanInputConnections()
			KeybindsService.Connect()
		end

		local popup = WidgetService.ConfirmPopup
		popup.Message.Text = "Are you sure you want to reset all your keybinds to their defaults? This CANNOT be undone. I mean it, if you actually set every keybind to something different and are resetting them, then you're nuts."
		KeybindsUiService._cleanInputConnections()
		popup.Visible = true

		PopupConnections[#PopupConnections + 1] = popup.Confirm.MouseButton1Click:Connect(function()
			popup.Visible = false
			KeybindsUiService._cleanPopupConnections()
			KeybindsService.ResetToDefaults()

			for _, keybind in ipairs(KeybindsService.GetKeybinds()) do
				KeybindsUiService._createKeys(Keybinds[keybind.Id], keybind.Keys)
			end
		end)

		PopupConnections[#PopupConnections + 1] = popup.Cancel.MouseButton1Click:Connect(function()
			popup.Visible = false
			KeybindsUiService._cleanPopupConnections()
		end)
	end)

	Connections[#Connections + 1] = Event.new("SettingChanged", function(id, _)
		if id == "UseKeypadKeybinds" then
			-- Is this a hack? Why yes, yes it is. :). Being fair... I'm tired.
			KeybindsService.ResetToDefaults()

			for _, keybindGui in pairs(Keybinds) do
				keybindGui:Destroy()
			end

			Keybinds = {}
			StartedOnce = false
			KeybindsUiService.Clean()
			KeybindsUiService.StartService()
		end
	end)
end

function KeybindsUiService.Clean()
	for index = #Connections, 1, -1 do
		table.remove(Connections, index):Disconnect()
	end

	KeybindsUiService._cleanPopupConnections()
	KeybindsUiService._cleanInputConnections()

	if SettingsService.Get("AllowUserInput") then
		KeybindsService.Connect()
	end
end

function KeybindsUiService._cleanPopupConnections()
	for index = #PopupConnections, 1, -1 do
		table.remove(PopupConnections, index):Disconnect()
	end
end

function KeybindsUiService._cleanInputConnections()
	Editing.Gui = nil
	Editing.Keys = nil

	for index = #InputConnections, 1, -1 do
		table.remove(InputConnections, index):Disconnect()
	end
end

function KeybindsUiService._createKeys(keybindGui, keysTbl)
	local keys = keybindGui.Keys
	local layout = keys.Layout

	for _, child in ipairs(keys:GetChildren()) do
		if child.ClassName == WidgetService.KeyTemplate.ClassName then
			child:Destroy()
		end
	end

	for _, key in ipairs(keysTbl) do
		local keyGui = WidgetService.KeyTemplate:Clone()
		keyGui.Size = UDim2.new(0, KeybindsUiService._getTextSize(key) + 12, 1, 0)
		keyGui.Content.Text = key
		keyGui.Parent = keys
	end

	keys.CanvasSize = UDim2.new(0, layout.AbsoluteContentSize.X, 0, 0)
end

function KeybindsUiService._getTextSize(content)
	local keyTemplate = WidgetService.KeyTemplate.Content
	local textSize = keyTemplate.TextSize
	return TextService:GetTextSize(content, textSize, keyTemplate.Font, Vector2.new(math.huge, textSize)).X
end

function KeybindsUiService._connectInput(keybindGui, keybind)
	local newKeys
	KeybindsService.Disconnect()

	if Editing.Gui then
		KeybindsUiService._createKeys(Editing.Gui, Editing.Keys)
	end

	InputConnections[#InputConnections + 1] = UserInputService.InputBegan:Connect(function(inputObject, _)
		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			newKeys = KeybindsService.GetKeysPressed()
			KeybindsUiService._createKeys(keybindGui, newKeys)
		end
	end)

	InputConnections[#InputConnections + 1] = keybindGui.Set.MouseButton1Click:Connect(function()
		local successful, existentKeybind = KeybindsService.Set(keybind.Id, newKeys)

		if successful then
			keybindGui.Editing.Visible = false
			keybindGui.Id.Size = UDim2.new(1, -110, 0, 20)
			keybindGui.Id.Position = UDim2.new(0, 0, 0, 0)
			KeybindsUiService._cleanInputConnections()
			KeybindsUiService._createKeys(keybindGui, newKeys)
			KeybindsService.Connect()
		else
			KeybindsUiService._createKeys(keybindGui, existentKeybind.Keys)
		end
	end)

	InputConnections[#InputConnections + 1] = keybindGui.Cancel.MouseButton1Click:Connect(function()
		KeybindsUiService._createKeys(keybindGui, KeybindsService.GetKeybindById(keybind.Id).Keys)
		keybindGui.Editing.Visible = false
		keybindGui.Id.Size = UDim2.new(1, -110, 0, 20)
		keybindGui.Id.Position = UDim2.new(0, 0, 0, 0)
		KeybindsUiService._cleanInputConnections()
		KeybindsService.Connect()
	end)
end

return KeybindsUiService
