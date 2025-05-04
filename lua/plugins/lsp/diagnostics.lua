-- @module plugins.lsp.diagnostics
local M = {}

function M.configure()
	local user_icons = require("const.user_icons")

	local severity_icons = {
		[vim.diagnostic.severity.ERROR] = user_icons.diagnostics.Error,
		[vim.diagnostic.severity.WARN] = user_icons.diagnostics.Warn,
		[vim.diagnostic.severity.INFO] = user_icons.diagnostics.Info,
		[vim.diagnostic.severity.HINT] = user_icons.diagnostics.Hint,
	}
	local severity_highlights = {
		[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
		[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
		[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
	}

	-- set up some diagnostic behavior
	vim.diagnostic.config({
		update_in_insert = true,
		severity_sort = true,
		float = { border = "rounded" },
		virtual_text = {
			prefix = function(diag) return severity_icons[diag.severity] end,
		},
		signs = {
			text = severity_icons,
			numhl = severity_highlights,
		},
	})
end

return M
