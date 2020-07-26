--- Imports ---
local DataService = require(script.Parent.DataService)

--- Constants ---

--[[
	The key in which the templates are saved and loaded from.
]]
local TEMPLATES_KEY = "QDT_EnhancedGUIControl_TEMPLATES"

--- TemplatesService ---
local Templates = nil

local RobloxTypes = {
	Rect = Rect.new,
	UDim2 = UDim2.new,
	Color3 = Color3.new,
	Vector2 = Vector2.new,
	Vector3 = Vector3.new
}

local TemplatesService = {}

--[[
	Loads keybinds otherwise saves default keybinds.
	Provides an API that allows other services to modify certain keybinds.
]]
function TemplatesService.StartService()
	local data = DataService.Load(TEMPLATES_KEY)

	if data then
		Templates = TemplatesService._deserialize(data)
	else
		Templates = {}
	end
end

--[[
	If it exists, return a copy of the template data found by the index
	otherwise return nil.
]]
function TemplatesService.GetTemplateByIndex(index)
	local templateData = Templates[index]

	if templateData then
		return TemplatesService._copyTable(templateData)
	else
		return nil
	end
end

--[[
	Return a template given the ID or nil if it doesn't exist.
]]
function TemplatesService.GetTemplateById(id)
	for _, template in ipairs(Templates) do
		if template.Id == id then
			return template
		end
	end

	return nil
end

--[[
	Returns a copy of the templates data.
]]
function TemplatesService.GetTemplates()
	return TemplatesService._copyTable(Templates)
end

--[[
	Adds a template.
]]
function TemplatesService.Add(id, className, properties)
	if not TemplatesService.GetTemplateById(id) then
		local template = {
			Id = id,
			ClassName = className,
			Properties = properties
		}

		Templates[#Templates + 1] = template
		DataService.Save(TEMPLATES_KEY, TemplatesService._serialize())
		return true, template
	else
		return false
	end
end

--[[
	Removes a template.
]]
function TemplatesService.Remove(id)
	for index, template in ipairs(Templates) do
		if template.Id == id then
			table.remove(Templates, index)
			DataService.Save(TEMPLATES_KEY, Templates)
			return true
		end
	end

	return false
end

--[[
	Resets all templates.
]]
function TemplatesService.ResetToDefaults()
	Templates = {}
	DataService.Save(TEMPLATES_KEY, Templates)
end

--[[
	Cleans up the TemplatesService by
		- Resetting state (this in turn frees up memory).
]]
function TemplatesService.Clean()
	Templates = nil
end

--[[
	Converts data into a format that is compatible with JSON.
]]
function TemplatesService._serialize()
	local serializedTable = {}

	for index, templateData in ipairs(Templates) do
		local properties = {}

		local newData = {
			Id = templateData.Id,
			ClassName = templateData.ClassName,
			Properties = properties
		}

		for property, value in pairs(templateData.Properties) do
			if type(value) == "userdata" then
				properties[property] = TemplatesService._convertUserdata(value)
			else
				properties[property] = value
			end
		end

		serializedTable[index] = newData
	end

	return serializedTable
end

--[[
	Deserializes loaded data back into their Roblox types.
]]
function TemplatesService._deserialize(data)
	local deserializedTable = {}

	for index, templateData in ipairs(data) do
		local properties = {}

		local newData = {
			Id = templateData.Id,
			ClassName = templateData.ClassName,
			Properties = properties
		}

		for property, value in pairs(templateData.Properties) do
			if type(value) == "string" then
				local valueType, serializedValue = value:match(":(%w+):(.+)")

				if valueType then
					properties[property] = TemplatesService._convertSerializedValue(serializedValue, valueType)
				else
					properties[property] = value
				end
			else
				properties[property] = value
			end
		end

		deserializedTable[index] = newData
	end

	return deserializedTable
end

--[[
	Converts userdata into JSON-friendly data. Each value is prefixed with
	:Enum/ValueType:.
]]
function TemplatesService._convertUserdata(userdata)
	local robloxType = typeof(userdata)

	if robloxType == "UDim2" then
		return (":%s:%s"):format(robloxType, tostring(userdata):gsub("[%{%}]", ""):gsub("%s", ""))
	elseif robloxType == "Color3" or robloxType == "Vector2" or robloxType == "Vector3"  or robloxType == "Rect" then
		return (":%s:%s"):format(robloxType, tostring(userdata):gsub("%s", ""))
	else
		return (":%s:%s"):format(tostring(userdata.EnumType), userdata.Name)
	end
end

--[[
	Converts a serialized value into JSON-friendly data. Each value is prefixed with
	:Enum/ValueType:.
]]
function TemplatesService._convertSerializedValue(data, valueType)
	if RobloxTypes[valueType] then
		local components = {}

		for number in data:gmatch("[^,]+") do
			components[#components + 1] = tonumber(number)
		end

		return RobloxTypes[valueType](table.unpack(components))
	else
		return Enum[valueType][data]
	end
end

--[[
	Deep copies a table, but doesn't support cyclic tables and metatables.
]]
function TemplatesService._copyTable(dataType)
	local copy = nil

	if type(dataType) == "table" then
		copy = {}

		for key, value in pairs(dataType) do
			copy[TemplatesService._copyTable(key)] = TemplatesService._copyTable(value)
		end
	else
		copy = dataType
	end

	return copy
end

return TemplatesService
