-- @module plugin_config.telescope
local telescope = {}

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local t = require("telescope")

function telescope.configure()
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
		builtin.find_files()
	end, {})
	vim.api.nvim_create_user_command("R", function()
		builtin.resume()
	end, {})
	vim.api.nvim_create_user_command("G", function(tbl)
		builtin.live_grep({
			search_dirs = { tbl.fargs[1] },
			glob_pattern = tbl.fargs[2],
			prompt_title = tbl.fargs[1] .. " " .. tbl.fargs[2],
		})
	end, {
		nargs = "*",
		complete = "file",
	})
end

return telescope
