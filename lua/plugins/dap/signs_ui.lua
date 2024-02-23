-- @module plugins.dap.signs_ui
local M = {}

function M.configure()
	local user_icons = require("const.user_icons")

	vim.fn.sign_define({
		{
			name = "DapBreakpoint",
			text = user_icons.dap.Breakpoint,
			texthl = "DapBreakpoint",
			numhl = "DapBreakpoint",
		},
		{
			name = "DapBreakpointRejected",
			text = user_icons.dap.BreakpointRejected,
			texthl = "DapBreakpoint",
			numhl = "DapBreakpoint",
		},
		{
			name = "DapStopped",
			text = user_icons.dap.Stopped,
			texthl = "DapStopped",
			numhl = "DapStopped",
		},
	})
end

return M
