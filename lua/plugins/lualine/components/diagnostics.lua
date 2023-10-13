-- @module plugins.lualine.components.diagnostics
local DiagnosticIcons = require("plugins.lsp.diagnostics").Icons

return {
	"diagnostics",
	symbols = {
		error = DiagnosticIcons.ERROR,
		warn = DiagnosticIcons.WARN,
		info = DiagnosticIcons.INFO,
		hint = DiagnosticIcons.HINT,
	},
}
