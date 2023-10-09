-- @module plugin_config.nvim_treesitter
local M = {}

function M.config()
	local configs = require("nvim-treesitter.configs")

	-- use treesitter for folding
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	-- ensure that newly opened buffers start with all folds open
	vim.opt.foldlevelstart = 99

	configs.setup({
		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- Syntax highlighting
		highlight = {
			enable = true,
		},
	})
end

return M
