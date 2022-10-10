-- @module plugin_config.nvim_tree
local nvim_tree = {}

local nt = require("nvim-tree")
local api = require("nvim-tree.api")

local on_attach

function nvim_tree.configure()
	-- setup
	nt.setup({
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
		},
		git = {
			ignore = false,
		},
		on_attach = on_attach
	})

	-- keymappings to open/close the file explorer
	vim.keymap.set("", "<leader>nt", function() api.tree.toggle(true) end, { noremap = true })
end

function on_attach(_)
	-- vim.keymap.set("", "e", function() api.node.open.vertical() end, { noremap = true })
end


return nvim_tree
