-- @module plugins.dap.keybindings
local M = {}

function M.configure()
	local dap = require("dap")
	local dap_repl = require("dap.repl")
	local dapui = require("dapui")
	local osv = require("osv")

	local window = require("plugins.dap.helpers.window")

	-- neovim lua debugging
	vim.api.nvim_create_user_command("OSV", function() osv.launch({ port = 8086 }) end, {})

	-- Clear DAP REPL
	dap_repl.commands = vim.tbl_extend("force", dap_repl.commands, {
		clear = { "", ".clear" },
	})

	-- Other keybindings
	vim.keymap.set("", "<leader>de", function()
		dapui.toggle()
		if window.is_open() then
			window.after_open()
		end
	end, { noremap = true })
	vim.keymap.set("", "<leader>db", dap.toggle_breakpoint, { noremap = true })
	vim.keymap.set("", "<leader>dp", function()
		dapui.open()
		window.after_open()
		dap.continue()
	end, { noremap = true })
	vim.keymap.set("", "<leader>dl", dap.step_over, { noremap = true })
	vim.keymap.set("", "<leader>dh", dap.step_back, { noremap = true })
	vim.keymap.set("", "<leader>dr", dap.run_last, { noremap = true })
	vim.keymap.set("", "<leader>ds", dap.terminate, { noremap = true })
	vim.keymap.set("", "<leader>dd", dap.disconnect, { noremap = true })
	---@diagnostic disable-next-line: missing-fields
	vim.keymap.set("", "<leader>dk", function() dapui.eval(nil, { enter = true }) end, { noremap = true })
end

return M
