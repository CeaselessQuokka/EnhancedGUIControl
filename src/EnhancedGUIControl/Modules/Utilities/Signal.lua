--- Signal ---
local Signal = {}
Signal.__index = Signal

--[[
	Construct a new signal object.
]]
function Signal.new()
	return setmetatable({}, Signal)
end

--[[
	Connects a callback to the signal.
]]
function Signal:Connect(callback)
	self.Callback = callback
end

--[[
	Sets the callback to nil. The Event module will clean this up if it tries
	to fire it.
]]
function Signal:Disconnect()
	self.Callback = nil
end

--[[
	Fires the signal with the given parameters.
]]
function Signal:Fire(...)
	if self.Callback then
		self.Callback(...)
	end
end

return Signal
