-- @module plugin_config.telescope
local telescope = {}

local t = require("telescope")
local builtin = require("telescope.builtin")

function telescope.configure()
	-- keyboard shortcuts
	vim.keymap.set("", "<leader>f", builtin.find_files, {})

	t.setup({
		defaults = {
			mappings = {
				i = {
					["<C-u>"] = false
				}
			}
		}
	})
end

return telescope
