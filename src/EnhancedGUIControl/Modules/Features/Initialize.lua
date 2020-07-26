--- Imports ---
local Moving = require(script.Parent.Moving)
local ZIndex = require(script.Parent.ZIndex)
local Aligning = require(script.Parent.Aligning)
local Swapping = require(script.Parent.Swapping)
local Templates = require(script.Parent.Templates)
local ConstrainedAligning = require(script.Parent.ConstrainedAligning)
local SettingsService = require(script.Parent.Parent.Services.SettingsService)

--- Initialize ---
local Initialize = {}
local Initialized = false

function Initialize.Connect()
	if not Initialized then
		Initialized = true
		Moving.Connect()
		ZIndex.Connect()
		Aligning.Connect()
		Swapping.Connect()
		Templates.Connect()
		ConstrainedAligning.Connect()
	end
end

function Initialize.Disconnect()
	if Initialized then
		if SettingsService.Get("AllowUserInput") then
			Moving.Disconnect()
			ZIndex.Disconnect()
			Aligning.Disconnect()
			Swapping.Disconnect()
			Templates.Disconnect()
			ConstrainedAligning.Disconnect()
		end

		Initialized = false
	end
end

function Initialize.ForceDisconnect(arg1, arg2, arg3)
	Moving.Disconnect()
	ZIndex.Disconnect()
	Aligning.Disconnect()
	Swapping.Disconnect()
	Templates.Disconnect()
	ConstrainedAligning.Disconnect()
	Initialized = false
end

return Initialize
