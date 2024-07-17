-- @module plugins.better_escape
local M = {}

-- Export for usage elsewhere
M.keystring = "kj"

-- Copied from https://github.com/max397574/better-escape.nvim?tab=readme-ov-file#rewrite
local function handle_escape()
	vim.api.nvim_input("<esc>")
	local current_line = vim.api.nvim_get_current_line()
	if current_line:match("^%s+j$") then
		vim.schedule(function() vim.api.nvim_set_current_line("") end)
	end
end

function M.config()
	require("better_escape").setup({
		mappings = {
			i = {
				k = { j = handle_escape },
			},
		},
	})
end

return M
