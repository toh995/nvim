-- @module plugins.better_escape
local M = {}

M.keystring = "kj"

function M.config()
	require("better_escape").setup({
		mapping = { M.keystring },
		clear_empty_lines = true,
	})
end

return M
