--- Defaults Keybinds ---
local Defaults = {
	-- Aligning
	{
		Id = "TopLeftAlign",
		Name = "Align all selected GUIs to Top-Left",
		Keys = {"KeypadZero", "KeypadSeven"},
		Description = "Aligns a GUI to the top-left of its parent."
	},

	{
		Id = "TopCenterAlign",
		Name = "Align all selected GUIs to Top-Center",
		Keys = {"KeypadZero", "KeypadEight"},
		Description = "Aligns a GUI to the top-center of its parent."
	},

	{
		Id = "TopRightAlign",
		Name = "Align all selected GUIs to Top-Right",
		Keys = {"KeypadZero", "KeypadNine"},
		Description = "Aligns a GUI to the top-right of its parent."
	},

	{
		Id = "CenterLeftAlign",
		Name = "Align all selected GUIs to Center-Left",
		Keys = {"KeypadZero", "KeypadFour"},
		Description = "Aligns a GUI to the center-left of its parent."
	},

	{
		Id = "CenterAlign",
		Name = "Align all selected GUIs to Center-",
		Keys = {"KeypadZero", "KeypadFive"},
		Description = "Aligns a GUI to the center of its parent."
	},

	{
		Id = "CenterRightAlign",
		Name = "Align all selected GUIs to Center-Right",
		Keys = {"KeypadZero", "KeypadSix"},
		Description = "Aligns a GUI to the center-right of its parent."
	},

	{
		Id = "BottomLeftAlign",
		Name = "Align all selected GUIs to Bottom-Left",
		Keys = {"KeypadZero", "KeypadOne"},
		Description = "Aligns a GUI to the bottom-left of its parent."
	},

	{
		Id = "BottomCenterAlign",
		Name = "Align all selected GUIs to Bottom-Center",
		Keys = {"KeypadZero", "KeypadTwo"},
		Description = "Aligns a GUI to the bottom-center of its parent."
	},

	{
		Id = "BottomRightAlign",
		Name = "Align all selected GUIs to Bottom-Right",
		Keys = {"KeypadZero", "KeypadThree"},
		Description = "Aligns a GUI to the bottom-right of its parent."
	},

	-- Moving
	{
		Id = "MoveUpLeft",
		Name = "Move GUI Up-Left",
		Keys = {"KeypadEnter", "KeypadSeven"},
		Description = "Moves all selected GUIs up-left by their respective size."
	},

	{
		Id = "MoveUp",
		Name = "Move GUI Up",
		Keys = {"KeypadEnter", "KeypadEight"},
		Description = "Moves all selected GUIs up by their respective size."
	},

	{
		Id = "MoveUpRight",
		Name = "Move GUI Up-Right",
		Keys = {"KeypadEnter", "KeypadNine"},
		Description = "Moves all selected GUIs up-right by their respective size."
	},

	{
		Id = "MoveLeft",
		Name = "Move GUI Left",
		Keys = {"KeypadEnter", "KeypadFour"},
		Description = "Moves all selected GUIs left by their respective size."
	},

	{
		Id = "MoveRight",
		Name = "Move GUI Right",
		Keys = {"KeypadEnter", "KeypadSix"},
		Description = "Moves all selected GUIs right by their respective size."
	},

	{
		Id = "MoveDownLeft",
		Name = "Move GUI Down-Left",
		Keys = {"KeypadEnter", "KeypadOne"},
		Description = "Moves all selected GUIs down-left by their respective size."
	},

	{
		Id = "MoveDown",
		Name = "Move GUI Down",
		Keys = {"KeypadEnter", "KeypadTwo"},
		Description = "Moves all selected GUIs down by their respective size."
	},

	{
		Id = "MoveDownRight",
		Name = "Move GUI Down-Right",
		Keys = {"KeypadEnter", "KeypadThree"},
		Description = "Moves all selected GUIs down-right by their respective size."
	},

	-- Swapping
	{
		Id = "SwapPositions",
		Name = "Swap Positions",
		Keys = {"KeypadZero", "KeypadEnter"},
		Description = "Swap the positions of two GUIs."
	},

	-- ZIndex Control
	{
		Id = "DecrementZIndex",
		Name = "Decrement ZIndex",
		Keys = {"KeypadEnter", "KeypadMinus"},
		Description = "Decrements the ZIndex of all selected GUIs by the value specified in the settings."
	},

	{
		Id = "IncrementZIndex",
		Name = "Increment ZIndex",
		Keys = {"KeypadEnter", "KeypadPlus"},
		Description = "Decrements the ZIndex of all selected GUIs by the value specified in the settings."
	},

	-- Templates
	{
		Id = "Template1",
		Name = "Template 1",
		Keys = {"LeftControl", "KeypadOne"},
		Description = "Applies the first template's properties to all selected GUIs."
	},

	{
		Id = "Template2",
		Name = "Template 2",
		Keys = {"LeftControl", "KeypadTwo"},
		Description = "Applies the second template's properties to all selected GUIs."
	},

	{
		Id = "Template3",
		Name = "Template 3",
		Keys = {"LeftControl", "KeypadThree"},
		Description = "Applies the third template's properties to all selected GUIs."
	},

	{
		Id = "Template4",
		Name = "Template 4",
		Keys = {"LeftControl", "KeypadFour"},
		Description = "Applies the fourth template's properties to all selected GUIs."
	},

	{
		Id = "Template5",
		Name = "Template 5",
		Keys = {"LeftControl", "KeypadFive"},
		Description = "Applies the fifth template's properties to all selected GUIs."
	},

	{
		Id = "Template6",
		Name = "Template 6",
		Keys = {"LeftControl", "KeypadSix"},
		Description = "Applies the sixth template's properties to all selected GUIs."
	},

	{
		Id = "Template7",
		Name = "Template 7",
		Keys = {"LeftControl", "KeypadSeven"},
		Description = "Applies the seventh template's properties to all selected GUIs."
	},

	{
		Id = "Template8",
		Name = "Template 8",
		Keys = {"LeftControl", "KeypadEight"},
		Description = "Applies the eighth template's properties to all selected GUIs."
	},

	{
		Id = "Template9",
		Name = "Template 9",
		Keys = {"LeftControl", "KeypadNine"},
		Description = "Applies the ninth template's properties to all selected GUIs."
	},

	-- Template Insert
	{
		Id = "TemplateInsertion1",
		Name = "Template 1",
		Keys = {"LeftControl", "LeftShift", "KeypadOne"},
		Description = "Inserts the first template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion2",
		Name = "Template 2",
		Keys = {"LeftControl", "LeftShift", "KeypadTwo"},
		Description = "Inserts the second template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion3",
		Name = "Template 3",
		Keys = {"LeftControl", "LeftShift", "KeypadThree"},
		Description = "Inserts the third template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion4",
		Name = "Template 4",
		Keys = {"LeftControl", "LeftShift", "KeypadFour"},
		Description = "Inserts the fourth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion5",
		Name = "Template 5",
		Keys = {"LeftControl", "LeftShift", "KeypadFive"},
		Description = "Inserts the fifth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion6",
		Name = "Template 6",
		Keys = {"LeftControl", "LeftShift", "KeypadSix"},
		Description = "Inserts the sixth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion7",
		Name = "Template 7",
		Keys = {"LeftControl", "LeftShift", "KeypadSeven"},
		Description = "Inserts the seventh template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion8",
		Name = "Template 8",
		Keys = {"LeftControl", "LeftShift", "KeypadEight"},
		Description = "Inserts the eighth template into all selected LayerCollectors."
	},

	{
		Id = "TemplateInsertion9",
		Name = "Template 9",
		Keys = {"LeftControl", "LeftShift", "KeypadNine"},
		Description = "Inserts the ninth template into all selected LayerCollectors."
	},

	-- Constrained Aligning
	{
		Id = "TopConstrainedAlign",
		Name = "Align GUI to the Top",
		Keys = {"LeftControl", "KeypadEnter", "KeypadEight"},
		Description = "Aligns all selected GUIs to the top while conserving their X positions."
	},

	{
		Id = "LeftConstrainedAlign",
		Name = "Align GUI to the Left",
		Keys = {"LeftControl", "KeypadEnter", "KeypadFour"},
		Description = "Aligns all selected GUIs to the left while conserving their Y positions."
	},

	{
		Id = "RightConstrainedAlign",
		Name = "Align GUI to the Right",
		Keys = {"LeftControl", "KeypadEnter", "KeypadSix"},
		Description = "Aligns all selected GUIs to the right while conserving their Y positions."
	},

	{
		Id = "BottomConstrainedAlign",
		Name = "Align GUI to the Bottom",
		Keys = {"LeftControl", "KeypadEnter", "KeypadTwo"},
		Description = "Aligns all selected GUIs to the bottom while conserving their X positions."
	},
}

for _, keybind in ipairs(Defaults) do
	table.sort(keybind.Keys)
end

return Defaults
