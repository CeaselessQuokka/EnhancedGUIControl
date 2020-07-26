--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local DataService = require(script.Parent.DataService)
local Sanitization = require(script.Parent.Parent.Utilities.Sanitization)

--- Constants ---

--[[
	The key in which the settings are saved and loaded from.
]]
local PLUGIN_SETTINGS_KEY = "QDT_EnhancedGUIControl_SETTINGS"

--- SettingsService ---
local Settings = nil
local DefaultSettings = require(script.Defaults)
local SettingsService = {}

--[[
	Loads plugin settings otherwise saves default settings.
]]
function SettingsService.StartService()
	Settings = DataService.Load(PLUGIN_SETTINGS_KEY, DefaultSettings)
end

--[[
	Gets a setting by its id (if it exists) otherwise returns nil.
]]
function SettingsService.Get(id)
	for _, settingData in ipairs(Settings) do
		if settingData.Id == id then
			return settingData.Value
		end
	end

	return nil
end

--[[
	Gets a setting by its id (if it exists) otherwise returns nil.
]]
function SettingsService.GetSettingData(id)
	for _, settingData in ipairs(Settings) do
		if settingData.Id == id then
			return settingData
		end
	end

	return nil
end

--[[
	Returns the settings.
]]
function SettingsService.GetSettings()
	return SettingsService._copyTable(Settings)
end

--[[
	Sets a setting provided the id and value. The value is automatically
	type checked. If the value is deemed invalid then it will spit a
	warning in the output and return false, otherwise it returns true.
	The setting is then updated and saved instantly.
]]
function SettingsService.Set(id, value)
	local settingData = SettingsService.GetSettingData(id)
	local dataType = settingData.DataType
	local min = settingData.Min
	local max = settingData.Max

	if Sanitization[dataType](value, min, max) then
		settingData.Value = value
		DataService.Save(PLUGIN_SETTINGS_KEY, Settings)
		Event.Fire("SettingChanged", id, value)
		return true
	else
		warn(("%q type expected got %q"):format(dataType, Sanitization.GetType(value, min, max)))
		return false, settingData.Value
	end
end

--[[
	Resets settings to their defaults.
]]
function SettingsService.ResetToDefaults()
	Settings = SettingsService._copyTable(DefaultSettings)
	DataService.Save(PLUGIN_SETTINGS_KEY, Settings)
end

--[[
	Cleans up the SettingsService by
		- Resetting state (this in turn frees up memory).
]]
function SettingsService.Clean()
	Settings = nil
end

--[[
	Deep copies a table, but doesn't support cyclic tables and metatables.
]]
function SettingsService._copyTable(dataType)
	local copy = nil

	if type(dataType) == "table" then
		copy = {}

		for key, value in pairs(dataType) do
			copy[SettingsService._copyTable(key)] = SettingsService._copyTable(value)
		end
	else
		copy = dataType
	end

	return copy
end

return SettingsService
