--[[
Event Object
A drop-in replacement for functions with multiple bodies
]]

local event, meta

event = {
	handlers = {},

	call = function(self, ...)
		if (self.pre) then
			self:pre(...)
		end

		for key, value in next, self.handlers do
			value(...)
		end

		if (self.post) then
			self:post(...)
		end

		return self
	end,

	register = function(self, method)
		table.insert(self.handlers, method)

		return self
	end,

	init = function(self, engine)
		setmetatable(self, meta)
		engine.lib.oop:objectify(self)

		return self
	end
}

meta = {
	__call = event.call,
	__add = event.register
}

return event