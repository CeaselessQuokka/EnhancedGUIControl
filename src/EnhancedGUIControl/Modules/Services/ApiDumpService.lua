--- Services ---
local HttpService = game:GetService("HttpService")

--- Imports ---
local DataService = require(script.Parent.DataService)

--- Constants ---

--[[
	The URL to get the API dump data from.
	CloneTrooper1019 provides the JSON of class and enum data at this URL.
	What a really nice guy, right? WRONG! He is a really, really nice guy for this.
	This is used to support GUI templates.
]]
local API_DUMP_URL = "https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/API-Dump.json"

--[[
	The number of seconds in three days.
	This constant is used to check if three days has passed since the last
	time the API dump was updated. This is to minimize overhead, especially
	since the JSON requested is more than two megabytes of data (that's a lot of data!).
]]
local API_DUMP_CACHE_TIME = 259200

--[[
	The key in which the API dump is saved and loaded from.
]]
local API_DUMP_KEY = "QDT_EnhancedGUIControl_API_DUMP"

--- ApiDumpService ---
local ApiDump = nil
local ApiDumpService = {}

--[[
	Entry point for the service. Loads the saved API dump if it exists else
	it is requested from the URL. If the data exists but the API dump cache
	time has been met or surpassed then the data is requested and overwritten.
]]
function ApiDumpService.StartService()
	local loadedApiDump = DataService.Load(API_DUMP_KEY)

	if not loadedApiDump or loadedApiDump and os.time() - loadedApiDump.LastLoaded >= API_DUMP_CACHE_TIME then
		ApiDump = {
			Dump = HttpService:JSONDecode(HttpService:GetAsync(API_DUMP_URL, false)),
			LastLoaded = os.time()
		}

		DataService.Save(API_DUMP_KEY, ApiDump)
	else
		ApiDump = loadedApiDump
	end
end

--[[
	Gets properties from both specified class names, and then gets the
	properties in common between them.
]]
function ApiDumpService.GetIntersectingProperties(className1, className2)
	local properties1 = ApiDumpService.GetProperties(className1, true)
	local properties2 = ApiDumpService.GetProperties(className2, true)
	local intersectedProperties = {}

	if #properties1 > #properties2 then
		local map = {}

		for _, property in ipairs(properties2) do
			map[property] = true
		end

		for _, property in ipairs(properties1) do
			if map[property] then
				table.insert(intersectedProperties, property)
			end
		end
	else
		local map = {}

		for _, property in ipairs(properties1) do
			map[property] = true
		end

		for _, property in ipairs(properties2) do
			if map[property] then
				table.insert(intersectedProperties, property)
			end
		end
	end

	return intersectedProperties
end

--[[
	A function that iteratively calls the private get property names function
	to get all properties of the specified class name.
]]
function ApiDumpService.GetProperties(className, namesOnly)
	local properties = {}
	local superclass = className

	while superclass ~= "<<<ROOT>>>" do
		local _properties, _superclass = ApiDumpService._getProperties(superclass, namesOnly)

		for _, property in ipairs(_properties) do
			table.insert(properties, namesOnly and property or ApiDumpService._copyTable(property))
		end

		superclass = _superclass
	end

	return properties
end

--[[
	Cleans up the ApiDumpService by
		- Resetting state (this in turn frees up memory).
]]
function ApiDumpService.Clean()
	ApiDump = nil
end

--[[
	A private function that gets all property data (or names) for the specified class name.
	It also returns the superclass of the given class name to help out the public function.
]]
function ApiDumpService._getProperties(className, namesOnly)
	local properties = {}
	local superclass = nil

	for _, classData in ipairs(ApiDump.Dump.Classes) do
		if classData.Name == className then
			superclass = classData.Superclass

			for _, memberData in ipairs(classData.Members) do
				if memberData.MemberType == "Property" then
					if ApiDumpService._isValidMember(memberData) then
						table.insert(properties, namesOnly and memberData.Name or memberData)
					end
				end
			end
		end
	end

	return properties, superclass
end

--[[
	A private function used to check if a certain member contains the specified tag.
]]
function ApiDumpService._hasTag(memberData, tag)
	for _, _tag in ipairs(memberData.Tags) do
		if _tag == tag then
			return true
		end
	end

	return false
end

--[[
	Utilizes the private has tag function to check if a member is valid.
	A member is considered valid if it is not deprecated, is not read only,
	and is not hidden.

	NOTE: This function has also been hardcoded to ignore properties with a value type of
	LocalizationTable, Instance, GuiObject, and Camera. This is because (as far as I know)
	there is no possible way to store an instance (without serializing it).
]]
function ApiDumpService._isValidMember(memberData)
	local valueType = memberData.ValueType.Name

	local canPass = (
		valueType ~= "LocalizationTable" and
		valueType ~= "GuiObject" and
		valueType ~= "Instance" and
		valueType ~= "Camera" and
		ApiDumpService._isValidSecurity(memberData)
	)

	if canPass then
		if memberData.Tags then
			return (
				not ApiDumpService._hasTag(memberData, "Deprecated") and
				not ApiDumpService._hasTag(memberData, "ReadOnly") and
				not ApiDumpService._hasTag(memberData, "Hidden")
			)
		else
			return true
		end
	else
		return false
	end
end

function ApiDumpService._isValidSecurity(memberData)
	local security = memberData.Security

	if security == "string" then
		return security == "None"
	else
		for _, _security in pairs(security) do
			if _security ~= "None" then
				return false
			end
		end
	end

	return true
end

--[[
	Deep copies a table, but doesn't support cyclic tables and metatables.
]]
function ApiDumpService._copyTable(dataType)
	local copy = nil

	if type(dataType) == "table" then
		copy = {}

		for key, value in pairs(dataType) do
			copy[ApiDumpService._copyTable(key)] = ApiDumpService._copyTable(value)
		end
	else
		copy = dataType
	end

	return copy
end

return ApiDumpService
