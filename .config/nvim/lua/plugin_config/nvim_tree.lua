-- @module plugin_config.nvim_tree
local nvim_tree = {}

local nt = require("nvim-tree")
-- local nt_api = require("nvim-tree.api")

local on_attach

function nvim_tree.configure()
	nt.setup({
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
		},

		on_attach = on_attach
	})
end

function on_attach(_)
	-- vim.keymap.set("", "e", function() nt_api.node.open.vertical() end)
end


return nvim_tree
