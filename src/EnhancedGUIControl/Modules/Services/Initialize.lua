local ApiDumpService = require(script.Parent.ApiDumpService)
local KeybindsService = require(script.Parent.KeybindsService)
local SettingsService = require(script.Parent.SettingsService)
local TemplatesService = require(script.Parent.TemplatesService)
local SettingsUiService = require(script.Parent.SettingsUiService)
local MainMenuUiService = require(script.Parent.MainMenuUiService)
local KeybindsUiService = require(script.Parent.KeybindsUiService)
local TemplatesUiService = require(script.Parent.TemplatesUiService)
local TemplatesEditorUiService = require(script.Parent.TemplatesEditorUiService)

--- Initialize ---
local Initialize = {}
local Initialized = false

function Initialize.StartService(plugin)
	if not Initialized then
		Initialized = true
		Initialize.InitializeVitals()Initialize.InitializeExtraneous(plugin)
	end
end

function Initialize.Clean()
	if Initialized then
		Initialize.CleanExtraneous()

		if not SettingsService.Get("AllowUserInput") then
			Initialize.CleanVitals()
		else
			if SettingsService.Get("ShowUserInputWarning") then
				warn("Enhanced GUI Control has been deactivated, but is still listening for your keybinds.")
			end
		end

		Initialized = false
	end
end

function Initialize.InitializeVitals()
	ApiDumpService.StartService()
	KeybindsService.StartService()
	TemplatesService.StartService()
	KeybindsService.Connect()
end

function Initialize.InitializeExtraneous(plugin)
	SettingsUiService.StartService()
	MainMenuUiService.StartService()
	KeybindsUiService.StartService()
	TemplatesUiService.StartService(plugin)
	TemplatesEditorUiService.StartService()
end

function Initialize.CleanVitals()
	ApiDumpService.Clean()
	KeybindsService.Clean()
	TemplatesService.Clean()
end

function Initialize.CleanExtraneous()
	SettingsUiService.Clean()
	MainMenuUiService.Clean()
	KeybindsUiService.Clean()
	TemplatesUiService.Clean()
	TemplatesEditorUiService.Clean()
end

function Initialize.ForceClean()
	Initialize.CleanExtraneous()
	Initialize.CleanVitals()
	Initialized = false
end

return Initialize
