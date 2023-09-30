-- @module plugin_config.nvim_tree
local nvim_tree = {}

local open_nvim_tree

function nvim_tree.config()
	local nt = require("nvim-tree")
	local api = require("nvim-tree.api")

	-- setup
	nt.setup({
		open_on_tab = true,
		git = { ignore = false },
		view = { adaptive_size = true },
		-- J and K are reserved for tab navigation
		-- TODO: fix this
		remove_keymaps = { "J", "K" },
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
		},
	})

	-- keymappings to open/close the file explorer
	vim.keymap.set("", "<leader>nt", function()
		api.tree.toggle(true)
	end, { noremap = true })

	-- open nvim tree on startup
	vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
end

-- open the tree if startup buffer is a directory, is empty or is unnamed
function open_nvim_tree(data)
	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1
	if not no_name and not directory then
		return
	end
	-- change to the directory
	if directory then
		vim.cmd.cd(data.file)
	end
	-- open the tree
	require("nvim-tree.api").tree.open()
end

return nvim_tree
