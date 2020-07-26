--- Services ---
local HttpService = game:GetService("HttpService")

--- DataService ---
local Plugin = nil
local DataService = {}

--[[
	This service acts as a wrapper for SetSetting and GetSetting for
	convenient plugin data loading and saving.
]]
function DataService.StartService(plugin)
	Plugin = plugin
end

--[[
	Loads plugin data based off the provided key. If the data exists it is
	automatically converted from JSON to a table, or the correct data type.
	If the data for the key does not exist and defaults is specified then
	it will return a copy of the defaults and save the defaults.
]]
function DataService.Load(key, defaults)
	local data = Plugin:GetSetting(key)

	if data then
		return HttpService:JSONDecode(data)
	else
		if defaults then
			local newData = DataService._copyTable(defaults)
			DataService.Save(key, newData)
			return newData
		end
	end
end

--[[
	Saves plugin data by the provided key and data. The data is
	automatically converted to JSON.
]]
function DataService.Save(key, data)
	Plugin:SetSetting(key, HttpService:JSONEncode(data))
end

--[[
	Deep copies a table, but doesn't support cyclic tables and metatables.
]]
function DataService._copyTable(dataType)
	local copy = nil

	if type(dataType) == "table" then
		copy = {}

		for key, value in pairs(dataType) do
			copy[DataService._copyTable(key)] = DataService._copyTable(value)
		end
	else
		copy = dataType
	end

	return copy
end

return DataService
