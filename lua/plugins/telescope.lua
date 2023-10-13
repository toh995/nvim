-- @module plugins.telescope
local M = {}

function M.config()
	local actions = require("telescope.actions")
	local builtin = require("telescope.builtin")
	local telescope = require("telescope")

	-- setup
	telescope.setup({
		defaults = {
			cache_picker = { num_pickers = 20 },
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

	vim.api.nvim_create_user_command("R", builtin.resume, {})

	--[[ 
  https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions

  todo:
    - vim.api.nvim_create_user_command("RS", builtin.pickers, {})
    - builtin.quickfix 
    - builtin.quickfixhistory
    - builtin.oldfiles
    - builtin.colorscheme
    - builtin.diagnostics
  --]]

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
