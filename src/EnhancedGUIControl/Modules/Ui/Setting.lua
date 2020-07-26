--- Services ---
local TweenService = game:GetService("TweenService")

--- Imports ---
local SettingTemplate = script.Parent.Parent.Parent.Guis.Templates.Setting
local SettingsService = require(script.Parent.Parent.Services.SettingsService)

--- Constants ---
local SWITCH_TWEEN_INFO = TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0)
local TOGGLE_TWEEN_INFO = TweenInfo.new(0.125, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0)

local TOGGLE_PROPERTY_OFF = {
	ImageColor3 = Color3.fromRGB(237, 238, 240)
}

local TOGGLE_PROPERTY_ON = {
	ImageColor3 = Color3.fromRGB(134, 194, 240)
}

local SWITCH_PROPERTY_OFF = {
	Position = UDim2.new(0, 2, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5)
}

local SWITCH_PROPERTY_ON = {
	Position = UDim2.new(1, -2, 0.5, 0),
	AnchorPoint = Vector2.new(1, 0.5)
}

--- Setting ---
local Setting = {}
Setting.__index = Setting

function Setting.new(name, state)
	local settingGui = SettingTemplate:Clone()
	local toggleImage = settingGui.Toggle
	local switchButton = settingGui.Toggle.Switch
	settingGui.Name = name
	settingGui.Setting.Text = name

	local settingObject = setmetatable({
		Setting = settingGui,

		-- Private
		_name = name,
		_state = state,

		_tweens = {
			ToggleOff = TweenService:Create(toggleImage, TOGGLE_TWEEN_INFO, TOGGLE_PROPERTY_OFF),
			ToggleOn = TweenService:Create(toggleImage, TOGGLE_TWEEN_INFO, TOGGLE_PROPERTY_ON),
			SwitchOff = TweenService:Create(switchButton, SWITCH_TWEEN_INFO, SWITCH_PROPERTY_OFF),
			SwitchOn = TweenService:Create(switchButton, SWITCH_TWEEN_INFO, SWITCH_PROPERTY_ON)
		},

		_components = {
			Toggle = toggleImage,
			Switch = switchButton,
			Button = toggleImage.Button
		},

		_mouseConnection = nil
	}, Setting)

	settingObject:_forceUpdate()
	return settingObject
end

function Setting:Connect()
	self._mouseConnection = self._components.Button.MouseButton1Click:Connect(function()
		self:_toggle()
	end)
end

function Setting:Disconnect()
	local signal = self._mouseConnection

	if signal then
		signal:Disconnect()
	end

	self._mouseConnection = nil
end

function Setting:Update(value)
	self._state = value
	self:_forceUpdate()
end

function Setting:_toggle()
	local state = self._state
	local tweens = self._tweens
	state = not state
	self._state = state

	if not state then
		tweens.ToggleOff:Play()
		tweens.SwitchOff:Play()
	else
		tweens.ToggleOn:Play()
		tweens.SwitchOn:Play()
	end

	SettingsService.Set(self._name, state)
end

function Setting:_forceUpdate()
	local components = self._components
	local switchButton = components.Switch

	if not self._state then
		switchButton.Position = SWITCH_PROPERTY_OFF.Position
		switchButton.AnchorPoint = SWITCH_PROPERTY_OFF.AnchorPoint
		components.Toggle.ImageColor3 = TOGGLE_PROPERTY_OFF.ImageColor3
	else
		switchButton.Position = SWITCH_PROPERTY_ON.Position
		switchButton.AnchorPoint = SWITCH_PROPERTY_ON.AnchorPoint
		components.Toggle.ImageColor3 = TOGGLE_PROPERTY_ON.ImageColor3
	end
end

return Setting
