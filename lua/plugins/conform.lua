-- @module plugins.conform
local M = {}

function M.config()
	local conform = require("conform")

	conform.setup({
		formatters_by_ft = {
			go = { "gofmt" },
			haskell = { "fourmolu" },
			lua = { "stylua" },
			nix = { "alejandra" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			sh = { "shfmt" },
			toml = { "taplo" },
			-- Web dev
			javascript = { "prettierd", "eslint_d" },
			typescript = { "prettierd", "eslint_d" },
			css = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			handlebars = { "prettierd" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	})
end

return M
