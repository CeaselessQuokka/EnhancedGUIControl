--- Imports ---
local Signal = require(script.Parent.Signal)

--- Event ---
local Event = {}
local Events = {}

--[[
	Constructs a new event object.
]]
function Event.new(name, callback)
	local signal = Signal.new()
	local eventData = Events[name]

	if eventData then
		eventData[#eventData + 1] = signal
	else
		Events[name] = {signal}
	end

	signal:Connect(callback)
	return signal
end

--[[
	Fires all signals that correspond to an event given "name".
]]
function Event.Fire(name, ...)
	local eventData = Events[name]

	if eventData then
		for index = #eventData, 1, -1 do
			local signal = eventData[index]

			if not signal or not signal.Callback then
				table.remove(eventData, index)
			else
				signal:Fire(...)
			end
		end
	end
end

return Event
