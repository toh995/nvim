-- @module plugins.nvim_treesitter
local M = {}

function M.config()
	local configs = require("nvim-treesitter.configs")

	---@diagnostic disable-next-line: missing-fields
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
		highlight = { enable = true },

		-- Auto-complete HTML tags
		autotag = { enable = true },

		-- Auto-insert `end`
		endwise = { enable = true },

		textobjects = {
			select = {
				enable = true,
				keymaps = {
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
				},
			},
		},

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "K",
				node_decremental = "J",
			},
		},
	})
end

return M
