-- @module plugin_config.nvim_tree
local nvim_tree = {}

function nvim_tree.configure()
	require("nvim-tree").setup()
end

return nvim_tree
