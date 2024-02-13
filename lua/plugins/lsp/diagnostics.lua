-- @module plugins.lsp.diagnostics
local M = {}

function M.configure()
	local user_icons = require("const.user_icons")

	-- set up some diagnostic behavior
	vim.diagnostic.config({
		update_in_insert = true,
		severity_sort = true,
		float = { border = "rounded" },
		-- TODO: in nvim 0.10.0+, for the prefix we can pass in
		-- a function which returns the diagnostics icon, based on
		-- the severity
		virtual_text = { prefix = user_icons.ui.CircleFilled },
	})

	-- set the signs for the sign/status column
	vim.fn.sign_define({
		{
			name = "DiagnosticSignError",
			texthl = "DiagnosticSignError",
			numhl = "DiagnosticSignError",
			text = user_icons.diagnostics.Error,
		},
		{
			name = "DiagnosticSignWarn",
			texthl = "DiagnosticSignWarn",
			numhl = "DiagnosticSignWarn",
			text = user_icons.diagnostics.Warn,
		},
		{
			name = "DiagnosticSignHint",
			texthl = "DiagnosticSignHint",
			numhl = "DiagnosticSignHint",
			text = user_icons.diagnostics.Hint,
		},
		{
			name = "DiagnosticSignInfo",
			texthl = "DiagnosticSignInfo",
			numhl = "DiagnosticSignInfo",
			text = user_icons.diagnostics.Info,
		},
	})
end

return M
