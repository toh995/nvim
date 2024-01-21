-- @module plugins.indent_blankline
local M = {}

function M.config()
	local ibl = require("ibl")
	ibl.setup({
		scope = {
			show_start = false,
			show_end = false,
		},
	})
end

return M
