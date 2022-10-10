-- @module plugin_config.telescope
local telescope = {}

local builtin = require("telescope.builtin")
local t = require("telescope")

function telescope.configure()
	-- setup
	t.setup({
		defaults = {
			mappings = {
				i = {
					["<C-u>"] = false,
				}
			}
		}
	})

	-- user commands, to launch various picker windows
	vim.api.nvim_create_user_command("F", function() builtin.find_files() end, {})
	vim.api.nvim_create_user_command("R", function() builtin.resume() end, {})
	vim.api.nvim_create_user_command("G",
		function(tbl)
			builtin.live_grep({
				search_dirs = { tbl.fargs[1] },
				glob_pattern = tbl.fargs[2],
				prompt_title = tbl.fargs[1].." "..tbl.fargs[2]
			})
		end,
		{
			nargs = "*",
			complete = "file",
		}
	)
end

return telescope
