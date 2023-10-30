-- @module plugins.lualine.components.diagnostics
local user_icons = require("const.user_icons")

return {
	"diagnostics",
	symbols = {
		error = user_icons.diagnostics.Error,
		warn = user_icons.diagnostics.Warn,
		info = user_icons.diagnostics.Hint,
		hint = user_icons.diagnostics.Info,
	},
}
