--[[
UI Container
A UI item that contains other items
Inherits ui.base
]]

local lib
local ui_container
local point_in_item

ui_container = {
	clips_children = false,
	children = {},

	add = function(self, object)
		table.insert(self.children, object)
	end,

	register = function(self, key, object)
		self.children[key] = object
	end,

	remove = function(self, key)
		self.children[key] = nil
	end,

	draw = function(self, event)
		love.graphics.push()
		love.graphics.setColor(255, 255, 255)
		love.graphics.translate(self.x, self.y)

		if (self.clips_children) then
			local abs_pos_x, abs_pos_y = self:get_absolute_position(event.stack)

			love.graphics.setScissor(abs_pos_x, abs_pos_y, self.width, self.height)
		end

		local stack = event.stack
		stack[#stack + 1] = self
		event.up = self

		for key, child in next, self.children do
			child:draw(event)
		end

		stack[#stack] = nil
		event.up = stack[#stack]

		love.graphics.setScissor()
		love.graphics.pop()
	end,

	mousedown = function(self, event)
		local mouse_x, mouse_y = event.x, event.y
		local trans_x, trans_y = mouse_x - self.x, mouse_y - self.y

		local stack = event.stack
		stack[#stack + 1] = self
		event.up = self

		if (not self.clips_children or self.visible and point_in_item(self, mouse_x, mouse_y)) then
			local searching = true

			for key, child in next, self.children do
				if (child.visible) then
					if (searching and point_in_item(child, trans_x, trans_y)) then
						if (child.mousedown) then
							event.x = trans_x - child.x
							event.y = trans_y - child.y

							child:mousedown(event)
						end

						searching = false
					else
						if (child.mousedown_sibling) then
							child:mousedown_sibling(event)
						end
					end
				end
			end
		end

		stack[#stack] = nil
		event.up = stack[#stack]

		event.x = mouse_x
		event.y = mouse_y
	end,

	init = function(self, engine)
		lib = engine.lib

		point_in_item = lib.ui.point_in_item

		lib.oop:objectify(self)
		self:inherit(lib.ui.base, true)
	end
}

ui_container.event = {
	draw = ui_container.draw,
	mousedown = ui_container.mousedown
}

return ui_container