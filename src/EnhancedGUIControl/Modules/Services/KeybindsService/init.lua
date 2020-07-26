--- Services ---
local UserInputService = game:GetService("UserInputService")

--- Imports ---
local Event = require(script.Parent.Parent.Utilities.Event)
local DataService = require(script.Parent.DataService)
local SettingsService = require(script.Parent.SettingsService)

--- Constants ---

--[[
	The key in which the keybinds are saved and loaded from.
]]
local KEYBINDS_KEY = "QDT_EnhancedGUIControl_KEYBINDS"

--- KeybindsService ---
local Keybinds = nil
local KeybindsMap = {}
local InputConnection = nil
local DefaultKeybinds = nil
local KeybindsService = {}

--[[
	Loads keybinds otherwise saves default keybinds.
	Provides an API that allows other services to modify certain keybinds.
]]
function KeybindsService.StartService()
	DefaultKeybinds = SettingsService.Get("UseKeypadKeybinds") and require(script.Defaults) or
		require(script.NoKeypadDefaults)

	Keybinds = DataService.Load(KEYBINDS_KEY, DefaultKeybinds)
	KeybindsMap = {}

	for _, keybind in ipairs(Keybinds) do
		KeybindsMap[table.concat(keybind.Keys, "")] = keybind.Id
	end
end

--[[
	Checks if a keybind exists given the id. Returns a keybind copy if it
	exists otherwise returns nil.
]]
function KeybindsService.GetKeybindById(id)
	for _, keybind in ipairs(Keybinds) do
		if keybind.Id == id then
			return KeybindsService._copyTable(keybind)
		end
	end

	return nil
end

--[[
	If the keybind exists, then the corresponding ID of the keybind is returned
	otherwise nil is returned.
]]
function KeybindsService.GetKeybindByKeys(keys)
	return KeybindsMap[table.concat(keys, "")]
end

--[[
	Returns a copy of the keybinds.
]]
function KeybindsService.GetKeybinds()
	return KeybindsService._copyTable(Keybinds)
end

--[[
	Changes an existing keybind to the new array of keys. If that set of keys
	already exists it returns false and a copy of the keybind that exists.
]]
function KeybindsService.Set(id, keys)
	local existentKeybindId = KeybindsService.GetKeybindByKeys(keys)

	if not existentKeybindId then
		local keybind = KeybindsService._getKeybindById(id)
		KeybindsMap[table.concat(keys, "")] = id
		KeybindsMap[table.concat(keybind.Keys, "")] = nil
		keybind.Keys = KeybindsService._copyTable(keys)
		DataService.Save(KEYBINDS_KEY, Keybinds)
		return true
	else
		local keybind = KeybindsService.GetKeybindById(existentKeybindId)
		warn(("This keybind already exists for %q"):format(keybind.Name))
		return false, keybind
	end
end

--[[
	Resets keybinds to their defaults.
]]
function KeybindsService.ResetToDefaults()
	DefaultKeybinds = SettingsService.Get("UseKeypadKeybinds") and require(script.Defaults) or
		require(script.NoKeypadDefaults)

	Keybinds = KeybindsService._copyTable(DefaultKeybinds)
	KeybindsMap = {}

	for _, keybind in ipairs(Keybinds) do
		KeybindsMap[table.concat(keybind.Keys, "")] = keybind.Id
	end

	DataService.Save(KEYBINDS_KEY, Keybinds)
end

--[[
	Connects user input.
]]
function KeybindsService.Connect()
	KeybindsService.Disconnect()

	InputConnection = UserInputService.InputBegan:Connect(function(_, _)
		local keys = KeybindsService.GetKeysPressed()
		local keybindId = #keys > 0 and KeybindsService.GetKeybindByKeys(keys)

		if keybindId then
			if SettingsService.Get("PrintKeybinds") then
				print("Keybind detected: " .. KeybindsService._beautifyKeys(keys))
			end

			Event.Fire("KeybindFired", keybindId)
		end
	end)
end

--[[
	Disconnects user input.
]]
function KeybindsService.Disconnect()
	if InputConnection then
		InputConnection:Disconnect()
	end

	InputConnection = nil
end

--[[
	Gets the keys that are pressed, and transforms it into the expected format.
]]
function KeybindsService.GetKeysPressed()
	local keys = {}

	for index, inputObject in ipairs(UserInputService:GetKeysPressed()) do
		local keyCode = inputObject.KeyCode

		if keyCode ~= Enum.KeyCode.Unknown then
			keys[index] = keyCode.Name
		end
	end

	table.sort(keys)
	return keys
end

--[[
	Cleans up the KeybindsService by
		- Disconnecting the UserInputService signal.
		- Resetting state (this in turn frees up memory).
]]
function KeybindsService.Clean()
	Keybinds = nil
	KeybindsMap = {}
	KeybindsService.Disconnect()
end

--[[
	Checks if a keybind exists given the id. Returns the keybind object
	otherwise returns nil.
]]
function KeybindsService._getKeybindById(id)
	for _, keybind in ipairs(Keybinds) do
		if keybind.Id == id then
			return keybind
		end
	end

	return nil
end

--[[
	A private function that returns a beautified string of keys for printing.
	Only used if the PrintKeybinds setting is true.
]]
function KeybindsService._beautifyKeys(keys)
	local beautifiedString = ""

	for index, key in ipairs(keys) do
		if index == #keys then
			beautifiedString = beautifiedString .. ("'%s'"):format(key)
		else
			beautifiedString = beautifiedString .. ("'%s' + "):format(key)
		end
	end

	return beautifiedString
end

--[[
	Deep copies a table, but doesn't support cyclic tables and metatables.
]]
function KeybindsService._copyTable(dataType)
	local copy = nil

	if type(dataType) == "table" then
		copy = {}

		for key, value in pairs(dataType) do
			copy[KeybindsService._copyTable(key)] = KeybindsService._copyTable(value)
		end
	else
		copy = dataType
	end

	return copy
end

return KeybindsService
