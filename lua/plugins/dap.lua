-- @module plugins.dap
local M = {}

function M.config()
	local dap = require("dap")
	local dap_ext_vscode = require("dap.ext.vscode")
	local dapui = require("dapui")

	local user_icons = require("const.user_icons")

	--[[
  KEYBOARD SHORTCUTS
  - lua plugin debugging

  UI
  - breakpoint UI
  - repl rendering icons
  - Disable in DAP windows:
    - lualine
    - UFO
  - bufferline offset
  - bufferline "unsaved" icon
  ]]
	--
	vim.api.nvim_create_user_command("DE", dapui.toggle, {})
	vim.keymap.set("", "<leader>db", dap.toggle_breakpoint, { noremap = true })
	vim.keymap.set("", "<leader>dp", function()
		dapui.open()
		dap.continue()
	end, { noremap = true })
	vim.keymap.set("", "<leader>dl", dap.step_over, { noremap = true })
	vim.keymap.set("", "<leader>dh", dap.step_back, { noremap = true })
	vim.keymap.set("", "<leader>dr", dap.restart, { noremap = true })
	vim.keymap.set("", "<leader>ds", dap.terminate, { noremap = true })
	vim.keymap.set("", "<leader>dd", dap.disconnect, { noremap = true })
	vim.keymap.set("", "<leader>dk", function()
		dapui.eval(nil, { enter = true })
	end, { noremap = true })

	---@diagnostic disable-next-line: missing-fields
	dapui.setup({
		floating = {
			border = "rounded",
		},
		controls = {
			icons = {
				disconnect = user_icons.dap.Disconnect,
				pause = user_icons.dap.Pause,
				play = user_icons.dap.Play,
				run_last = user_icons.dap.RunLast,
				step_back = user_icons.dap.StepBack,
				step_into = user_icons.dap.StepInto,
				step_out = user_icons.dap.StepOut,
				step_over = user_icons.dap.StepOver,
				terminate = user_icons.dap.Terminate,
			},
		},
		layouts = {
			{
				elements = {
					{
						id = "breakpoints",
						size = 0.25,
					},
					{
						id = "stacks",
						size = 0.25,
					},
					{
						id = "watches",
						size = 0.25,
					},
					{
						id = "scopes",
						size = 0.25,
					},
				},
				position = "left",
				size = 40,
			},
			{
				elements = {
					{
						id = "repl",
						size = 0.5,
					},
					{
						id = "console",
						size = 0.5,
					},
				},
				position = "bottom",
				size = 10,
			},
		},
	})

	-- register adapter
	-- inspired by https://github.com/mxsdev/nvim-dap-vscode-js/issues/42#issuecomment-1519065750
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "js-debug-adapter",
			args = { "${port}", "localhost" },
		},
	}

	-- register configuration
	dap_ext_vscode.load_launchjs(nil, {
		["pwa-node"] = { "javascript", "typescript" },
	})

	-- nvim lua DAP
	dap.adapters.nlua = function(callback, config)
		---@diagnostic disable-next-line: undefined-field
		callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
	end

	dap.configurations["lua"] = {
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance",
		},
	}

	local augroup = vim.api.nvim_create_augroup("dap_custom", { clear = true })
	-- When switching tabpage, or opening a new tabpage:
	--    - If dapui was open, then keep it open
	--    - If dapui was closed, then keep it closed
	vim.api.nvim_create_autocmd({ "TabEnter" }, {
		group = augroup,
		pattern = { "*" },
		callback = function()
			dapui.toggle()
			dapui.toggle()
		end,
	})
end

return M
