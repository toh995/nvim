-- @module plugins.nvim_treesitter
local M = {}

function M.config()
	local configs = require("nvim-treesitter.configs")

	-- use treesitter for folding
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	-- ensure that newly opened buffers start with all folds open
	vim.opt.foldlevelstart = 99

	configs.setup({
		-- TODO: remove `markdown_inline`, when
		-- this once this commit gets into `master`:
		-- https://github.com/nvim-treesitter/nvim-treesitter/commit/c7ba60a512772bf14e5f71074972225377eec1a0
		--
		-- More info: https://github.com/nvim-treesitter/nvim-treesitter/issues/5529
		ensure_installed = { "latex", "markdown_inline" },

		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- Syntax highlighting
		highlight = {
			enable = true,
		},
	})
end

return M
