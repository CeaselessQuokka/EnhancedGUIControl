--- Defaults Keybinds ---
local Defaults = {
	-- Aligning
	{
		Id = "TopLeftAlign",
		Name = "Align all selected GUIs to Top-Left",
		Keys = {"Tab", "One"},
		Description = "Aligns a GUI to the top-left of its parent."
	},

	{
		Id = "TopCenterAlign",
		Name = "Align all selected GUIs to Top-Center",
		Keys = {"Tab", "Two"},
		Description = "Aligns a GUI to the top-center of its parent."
	},

	{
		Id = "TopRightAlign",
		Name = "Align all selected GUIs to Top-Right",
		Keys = {"Tab", "Three"},
		Description = "Aligns a GUI to the top-right of its parent."
	},

	{
		Id = "CenterLeftAlign",
		Name = "Align all selected GUIs to Center-Left",
		Keys = {"Tab", "Four"},
		Description = "Aligns a GUI to the center-left of its parent."
	},

	{
		Id = "CenterAlign",
		Name = "Align all selected GUIs to Center-",
		Keys = {"Tab", "Five"},
		Description = "Aligns a GUI to the center of its parent."
	},

	{
		Id = "CenterRightAlign",
		Name = "Align all selected GUIs to Center-Right",
		Keys = {"Tab", "Six"},
		Description = "Aligns a GUI to the center-right of its parent."
	},

	{
		Id = "BottomLeftAlign",
		Name = "Align all selected GUIs to Bottom-Left",
		Keys = {"Tab", "Seven"},
		Description = "Aligns a GUI to the bottom-left of its parent."
	},

	{
		Id = "BottomCenterAlign",
		Name = "Align all selected GUIs to Bottom-Center",
		Keys = {"Tab", "Eight"},
		Description = "Aligns a GUI to the bottom-center of its parent."
	},

	{
		Id = "BottomRightAlign",
		Name = "Align all selected GUIs to Bottom-Right",
		Keys = {"Tab", "Nine"},
		Description = "Aligns a GUI to the bottom-right of its parent."
	},

	-- Moving
	{
		Id = "MoveUpLeft",
		Name = "Move GUI Up-Left",
		Keys = {"LeftAlt", "One"},
		Description = "Moves all selected GUIs up-left by their respective size."
	},

	{
		Id = "MoveUp",
		Name = "Move GUI Up",
		Keys = {"LeftAlt", "Two"},
		Description = "Moves all selected GUIs up by their respective size."
	},

	{
		Id = "MoveUpRight",
		Name = "Move GUI Up-Right",
		Keys = {"LeftAlt", "Three"},
		Description = "Moves all selected GUIs up-right by their respective size."
	},

	{
		Id = "MoveLeft",
		Name = "Move GUI Left",
		Keys = {"LeftAlt", "Four"},
		Description = "Moves all selected GUIs left by their respective size."
	},

	{
		Id = "MoveRight",
		Name = "Move GUI Right",
		Keys = {"LeftAlt", "Six"},
		Description = "Moves all selected GUIs right by their respective size."
	},

	{
		Id = "MoveDownLeft",
		Name = "Move GUI Down-Left",
		Keys = {"LeftAlt", "Seven"},
		Description = "Moves all selected GUIs down-left by their respective size."
	},

	{
		Id = "MoveDown",
		Name = "Move GUI Down",
		Keys = {"LeftAlt", "Eight"},
		Description = "Moves all selected GUIs down by their respective size."
	},

	{
		Id = "MoveDownRight",
		Name = "Move GUI Down-Right",
		Keys = {"LeftAlt", "Nine"},
		Description = "Moves all selected GUIs down-right by their respective size."
	},

	-- Swapping
	{
		Id = "SwapPositions",
		Name = "Swap Positions",
		Keys = {"LeftControl", "Return"},
		Description = "Swap the positions of two GUIs."
	},

	-- ZIndex Control
	{
		Id = "DecrementZIndex",
		Name = "Decrement ZIndex",
		Keys = {"LeftControl", "BackSlash"},
		Description = "Decrements the ZIndex of all selected GUIs by the value specified in the settings."
	},

	{
		Id = "IncrementZIndex",
		Name = "Increment ZIndex",
		Keys = {"LeftControl", "Quote"},
		Description = "Decrements the ZIndex of all selected GUIs by the value specified in the settings."
	},

	-- Templates
	{
		Id = "Template1",
		Name = "Template 1",
		Keys = {"LeftControl", "LeftShift", "One"},
		Description = "Applies the first template's properties to all selected GUIs."
	},

	{
		Id = "Template2",
		Name = "Template 2",
		Keys = {"LeftControl", "LeftShift", "Two"},
		Description = "Applies the second template's properties to all selected GUIs."
	},

	{
		Id = "Template3",
		Name = "Template 3",
		Keys = {"LeftControl", "LeftShift", "Three"},
		Description = "Applies the third template's properties to all selected GUIs."
	},

	{
		Id = "Template4",
		Name = "Template 4",
		Keys = {"LeftControl", "LeftShift", "Four"},
		Description = "Applies the fourth template's properties to all selected GUIs."
	},

	{
		Id = "Template5",
		Name = "Template 5",
		Keys = {"LeftControl", "LeftShift", "Five"},
		Description = "Applies the fifth template's properties to all selected GUIs."
	},

	{
		Id = "Template6",
		Name = "Template 6",
		Keys = {"LeftControl", "LeftShift", "Six"},
		Description = "Applies the sixth template's properties to all selected GUIs."
	},

	{
		Id = "Template7",
		Name = "Template 7",
		Keys = {"LeftControl", "LeftShift", "Seven"},
		Description = "Applies the seventh template's properties to all selected GUIs."
	},

	{
		Id = "Template8",
		Name = "Template 8",
		Keys = {"LeftControl", "LeftShift", "Eight"},
		Description = "Applies the eighth template's properties to all selected GUIs."
	},

	{
		Id = "Template9",
		Name = "Template 9",
		Keys = {"LeftControl", "LeftShift", "Nine"},
		Description = "Applies the ninth template's properties to all selected GUIs."
	},

	-- Template Insert
	{
		Id = "TemplateInsertion1",
		Name = "Template 1",
		Keys = {"LeftControl", "LeftAlt", "One"},
		Description = "Inserts the first template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion2",
		Name = "Template 2",
		Keys = {"LeftControl", "LeftAlt", "Two"},
		Description = "Inserts the second template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion3",
		Name = "Template 3",
		Keys = {"LeftControl", "LeftAlt", "Three"},
		Description = "Inserts the third template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion4",
		Name = "Template 4",
		Keys = {"LeftControl", "LeftAlt", "Four"},
		Description = "Inserts the fourth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion5",
		Name = "Template 5",
		Keys = {"LeftControl", "LeftAlt", "Five"},
		Description = "Inserts the fifth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion6",
		Name = "Template 6",
		Keys = {"LeftControl", "LeftAlt", "Six"},
		Description = "Inserts the sixth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion7",
		Name = "Template 7",
		Keys = {"LeftControl", "LeftAlt", "Seven"},
		Description = "Inserts the seventh template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion8",
		Name = "Template 8",
		Keys = {"LeftControl", "LeftAlt", "Eight"},
		Description = "Inserts the eighth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion9",
		Name = "Template 9",
		Keys = {"LeftControl", "LeftAlt", "Nine"},
		Description = "Inserts the ninth template into all selected LayerCollectors."
	},

	-- Constrained Aligning
	{
		Id = "TopConstrainedAlign",
		Name = "Align GUI to the Top",
		Keys = {"LeftShift", "LeftAlt", "One"},
		Description = "Aligns all selected GUIs to the top while conserving their X positions."
	},

	{
		Id = "LeftConstrainedAlign",
		Name = "Align GUI to the Left",
		Keys = {"LeftShift", "LeftAlt", "Two"},
		Description = "Aligns all selected GUIs to the left while conserving their Y positions."
	},

	{
		Id = "RightConstrainedAlign",
		Name = "Align GUI to the Right",
		Keys = {"LeftShift", "LeftAlt", "Three"},
		Description = "Aligns all selected GUIs to the right while conserving their Y positions."
	},

	{
		Id = "BottomConstrainedAlign",
		Name = "Align GUI to the Bottom",
		Keys = {"LeftShift", "LeftAlt", "Four"},
		Description = "Aligns all selected GUIs to the bottom while conserving their X positions."
	},
}

for _, keybind in ipairs(Defaults) do
	table.sort(keybind.Keys)
end

return Defaults
