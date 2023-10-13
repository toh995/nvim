-- @module plugins.telescope
local M = {}

function M.config()
	local actions = require("telescope.actions")
	local builtin = require("telescope.builtin")
	local t = require("telescope")

	-- setup
	t.setup({
		defaults = {
			mappings = {
				i = {
					["<C-u>"] = false,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
			},
		},
	})

	-- user commands, to launch various picker windows
	vim.api.nvim_create_user_command("F", function()
		builtin.find_files({ hidden = true })
	end, {})

	vim.api.nvim_create_user_command("R", function()
		builtin.resume()
	end, {})

	vim.api.nvim_create_user_command("G", function(tbl)
		local filepath = tbl.fargs[1] or "."
		local glob_pattern = tbl.fargs[2] or ""

		builtin.live_grep({
			search_dirs = { filepath },
			glob_pattern = glob_pattern,
			prompt_title = "Grep in " .. filepath .. " " .. glob_pattern,
		})
	end, {
		nargs = "*",
		complete = "file",
	})
end

return M
