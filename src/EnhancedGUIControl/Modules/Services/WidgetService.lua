--- Widget ---
local Guis = script.Parent.Parent.Parent.Guis
local Templates = Guis.Templates
local Widget = {}

function Widget.StartService(plugin)
	local pluginGui = Guis.Main
	local menus = pluginGui.Menus

	local pluginWidget = plugin:CreateDockWidgetPluginGui(
		"QDT_EnhancedGUIControl_WIDGET",
		DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Right, false, true, 0, 0, 360, 200)
	)

	pluginWidget.ZIndexBehavior = Enum.ZIndexBehavior.Global
	pluginWidget.Title = "Enhanced GUI Control"
	pluginGui.Parent = pluginWidget

	-- UI Fields
	Widget.Menus = menus
	Widget.Widget = pluginGui
	Widget.PluginWidget = pluginWidget

	-- Popups
	Widget.ConfirmPopup = pluginGui.ConfirmPopup
	Widget.CreateTemplatePopup = pluginGui.CreateTemplatePopup

	-- Menus
	Widget.MainMenu = menus.Main
	Widget.KeybindsMenu = menus.Keybinds
	Widget.SettingsMenu = menus.Settings
	Widget.TemplatesMenu = menus.Templates
	Widget.TemplateEditorMenu = menus.TemplateEditor

	-- Lists
	Widget.KeybindsList = Widget.KeybindsMenu.List
	Widget.SettingsList = Widget.SettingsMenu.List
	Widget.TemplatesList = Widget.TemplatesMenu.List
	Widget.TemplatesEditorList = Widget.TemplateEditorMenu.List

	-- Layouts
	Widget.KeybindsLayout = Widget.KeybindsList.Layout
	Widget.SettingsLayout = Widget.SettingsList.Layout
	Widget.TemplatesLayout = Widget.TemplatesList.Layout
	Widget.TemplatesEditorLayout = Widget.TemplatesEditorList.Layout

	-- Back Buttons
	Widget.KeybindsBackButton = Widget.KeybindsMenu.Back
	Widget.SettingsBackButton = Widget.SettingsMenu.Back
	Widget.TemplatesBackButton = Widget.TemplatesMenu.Back

	-- Reset to Defaults Buttons
	Widget.KeybindsResetButton = Widget.KeybindsMenu.Reset
	Widget.SettingsResetButton = Widget.SettingsMenu.Reset
	Widget.TemplatesResetButton = Widget.TemplatesMenu.Delete

	-- Templates
	Widget.KeyTemplate = Templates.Key
	Widget.InputTemplate = Templates.Input
	Widget.KeybindTemplate = Templates.Keybind
	Widget.SettingTemplate = Templates.Setting
	Widget.PropertyTemplate = Templates.Property
	Widget.TemplateTemplate = Templates.Template

	-- Misc Buttons
	Widget.MainMenuButtons = Widget.MainMenu.Buttons
	Widget.TemplateSaveButton = Widget.TemplateEditorMenu.Save
	Widget.TemplateScrapButton = Widget.TemplateEditorMenu.Scrap
	Widget.TemplateCreateButton = Widget.TemplatesMenu.Create

	-- Misc UI Fields
	Widget.AlignmentButtons = Guis.AlignmentButtons
	Widget.GuiCopyContainer = Widget.MainMenu.Alignment.GuiCopy
	Widget.ViewportBackground = Widget.TemplateEditorMenu.Viewport.Background
end

function Widget.Enable()
	Widget.PluginWidget.Enabled = true
end

function Widget.Disable()
	Widget.PluginWidget.Enabled = false
end

return Widget
