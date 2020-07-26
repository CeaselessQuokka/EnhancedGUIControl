--- Sanitization ---
local function String(_string)
	return type(_string) == "string"
end

local function Number(number, min, max)
	number = tonumber(number)

	if number then
		if min then
			if number < min then
				return false
			end
		end

		if max then
			if number > max then
				return false
			end
		end

		return true
	end

	return false
end

local function Integer(number, min, max)
	return Number(number, min, max) and number % 1 == 0
end

local function Boolean(value)
	return value == true or value == false or value == "true" or value == "false"
end

--[[
	Type checks input. Returns true if the input is valid and false otherwise.
]]
return {
	String = String,
	Number = Number,
	Integer = Integer,
	Boolean = Boolean,

	GetType = function(...)
		return (
			(Boolean(...) and "Boolean") or
			(Number(...) and "Number") or
			(Integer(...) and "Integer") or
			(String(...) and "String") or
			"Unknown"
		)
	end
}
