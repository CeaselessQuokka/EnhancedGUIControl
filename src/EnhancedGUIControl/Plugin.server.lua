local Toolbar = plugin:CreateToolbar("Dev Tools")
local Button = Toolbar:CreateButton("Enhanced GUI Control", "Align, move, and more with this plugin meant to help streamline your GUI creation.", "rbxassetid://5438452912", "Enhanced GUI Control")
local Enabled = false

--- Imports ---
require(script.Parent.Modules.Services.DataService).StartService(plugin)
local Event = require(script.Parent.Modules.Utilities.Event)
local WidgetService = require(script.Parent.Modules.Services.WidgetService)
local ServerInitializer = require(script.Parent.Modules.Services.Initialize)
local FeatureInitializer = require(script.Parent.Modules.Features.Initialize)
local SettingsService = require(script.Parent.Modules.Services.SettingsService)
WidgetService.StartService(plugin)
SettingsService.StartService()

--- Plugin ---
local Signal = nil

--[[
	Starts the services and connects the features. All events are connected in
	this function.
]]
local function Activate()
	if not Enabled then
		Enabled = true
		WidgetService:Enable()
		wait() -- Ugly hack to let Roblox update the sizes and such of the GUIs.
		ServerInitializer.StartService(plugin)
		FeatureInitializer.Connect(plugin)
		Button:SetActive(true)
	end
end

--[[
	Cleans up the services and disconnects the features. All events are
	disconnected in this function.
]]
local function Deactivate()
	if Enabled then
		WidgetService:Disable()
		ServerInitializer.Clean()
		FeatureInitializer.Disconnect()
		Button:SetActive(false)
		Enabled = false
	end
end

--[[
	Called when the plugin is be unloaded. Unloading occurs when the plugin
	is being removed or updated.
]]
local function Unload()
	if Enabled then
		if Signal then
			Signal:Disconnect()
		end

		ServerInitializer.ForceClean()
		FeatureInitializer.ForceDisconnect()
		Button:SetActive(false)
		Enabled = false
		Signal = nil
	end
end

Button.Click:Connect(function()
	if not Enabled then
		Activate()
	else
		Deactivate()
	end
end)

plugin.Unloading:Connect(Unload)
plugin.Deactivation:Connect(Deactivate)

if SettingsService.Get("AllowUserInput") then
	ServerInitializer.InitializeVitals()
	FeatureInitializer.Connect()

	if SettingsService.Get("ShowUserInputWarning") then
		warn("Enhanced GUI Control has started and is currently listening for your keybinds.")
	end
end

Signal = Event.new("SettingChanged", function(id, value)
	if id == "AllowUserInput" then
		if value then
			if not Enabled then
				ServerInitializer.InitializeVitals()
				FeatureInitializer.Connect()

				if SettingsService.Get("ShowUserInputWarning") then
					warn("Enhanced GUI Control has started and is currently listening for your keybinds.")
				end
			end
		else
			if not Enabled then
				ServerInitializer.CleanVitals()
				FeatureInitializer.Disconnect()
			end
		end
	end
end)
