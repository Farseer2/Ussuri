--[[
GUI Utility Library
Provides various GUI drawing utility methods
]]

local lib
local gui

gui = {
	styles = {
		["white"] = {255, 255, 255},
		["red"] = {200, 0, 0},
		["pink"] = {200, 0, 200},
		["yellow"] = {200, 200, 0},
		["blue"] = {0, 80, 200},
		["green"] = {0, 200, 80}
	},

	style_decompose = function(self, text)
		local out_text = {}
		local out_style = {}

		local unstyled = string.match(text, "^[^\b]+")
		if (unstyled) then
			out_text[1] = string.match(text, "^[^\b]+")
			out_style[1] = "white"
		end

		for style_piece, text_piece in string.gmatch(text, "\b(.-)\b([^\b]*)") do
			table.insert(out_text, text_piece)
			table.insert(out_style, style_piece)
		end

		return out_text, out_style
	end,

	style_add = function(self, name, style)
		if (not self.styles[name]) then
			self.styles[name] = style
		end
	end,

	prints = function(self, text, x, y)
		local text, style = self:style_decompose(text)
		local font = love.graphics.getFont()

		local atx, aty = x, y
		for id, piece in next, text do
			love.graphics.setColor(self.styles[style[id]])
			love.graphics.print(piece, atx, aty)

			local _, newlines = piece:gsub("\n", "")

			atx = atx + font:getWidth(piece)

			if (newlines > 0) then
				aty = aty + font:getHeight() * newlines
				atx = x
			end
		end
	end,

	init = function(self, engine)
		lib = engine.lib

		return self
	end
}

return gui