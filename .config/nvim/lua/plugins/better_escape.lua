-- @module plugins.better_escape
local M = {}

function M.config()
	require("better_escape").setup({
		mapping = { "jk", "kj" },
		clear_empty_lines = true,
	})
end

return M
