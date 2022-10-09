-- @module plugin_config.nvim_treesitter
local nvim_treesitter = {}

local configs = require("nvim-treesitter.configs")

function nvim_treesitter.configure()
	configs.setup({
		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- Syntax highlighting
		highlight = {
			enable = true,
		},
	})
end

return nvim_treesitter
