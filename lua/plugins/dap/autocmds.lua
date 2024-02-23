-- @module plugins.dap.autocmds
local M = {}

function M.configure()
	local dapui = require("dapui")

	local window = require("plugins.dap.helpers.window")

	local augroup = vim.api.nvim_create_augroup("dap_custom", { clear = true })
	-- When switching tabpage, or opening a new tabpage:
	--    - If dapui was open, then keep it open
	--    - If dapui was closed, then keep it closed
	vim.api.nvim_create_autocmd({ "TabEnter" }, {
		group = augroup,
		pattern = { "*" },
		callback = function()
			if window.is_open() then
				dapui.toggle()
				dapui.toggle()
				window.after_open()
			end
		end,
	})
end

return M
