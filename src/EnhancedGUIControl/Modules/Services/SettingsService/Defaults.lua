return {
	{
		Id = "AllowUserInput",
		Value = false,
		DataType = "Boolean",
		DisplayName = "Allow User Input",
		Description = "When true the plugin will check for your input while not activated."
	},

	{
		Id = "ShowUserInputWarning",
		Value = true,
		DataType = "Boolean",
		DisplayName = "Show User Input Warning",
		Description = "When true the plugin will display a warning when the \"Allow User Input\" setting is true."
	},

	{
		Id = "ShowGUISelectionWarning",
		Value = true,
		DataType = "Boolean",
		DisplayName = "Show GUI Selection Warning",
		Description = "When true shows a warning message if the GUI you are selecting is a child of a LayerCollector object."
	},

	{
		Id = "UseKeypadKeybinds",
		Value = true,
		DataType = "Boolean",
		DisplayName = "Use Keypad Keybinds",
		Description = "If true, then the keybinds that include the keypad are active. If false, it uses other keybinds and avoids any use of the keypad. NOTE: This overwrites keybind modifications when toggled."
	},

	{
		Id = "ShowAlignmentGUI",
		Value = true,
		DataType = "Boolean",
		DisplayName = "Show Alignment Buttons",
		Description = "When true it will display the alignment options on the main menu."
	},

	{
		Id = "PrintKeybinds",
		Value = true,
		DataType = "Boolean",
		DisplayName = "Print Keybinds",
		Description = "When true keybinds will be printed to the output when pressed if this is set to true."
	},

	{
		Id = "ZIndexIncrement",
		Value = 1,
		DataType = "Integer",
		DisplayName = "ZIndex Increment",
		Description = "When the assigned keybinds are pressed this is the amount the ZIndex will either decrement or increment by."
	}
}
