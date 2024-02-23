-- @module plugins.dap
local M = {}

local setup_dapui

function M.config()
	local pkgs = {
		dapui = require("dapui"),
		user_icons = require("const.user_icons"),
	}

	setup_dapui(pkgs)

	require("plugins.dap.adapter_configs").configure()
	require("plugins.dap.autocmds").configure()
	require("plugins.dap.keybindings").configure()
	require("plugins.dap.signs_ui").configure()
end

function setup_dapui(pkgs)
	---@diagnostic disable-next-line: missing-fields
	pkgs.dapui.setup({
		---@diagnostic disable-next-line: missing-fields
		floating = {
			border = "rounded",
		},
		---@diagnostic disable-next-line: missing-fields
		controls = {
			icons = {
				disconnect = pkgs.user_icons.dap.Disconnect,
				pause = pkgs.user_icons.dap.Pause,
				play = pkgs.user_icons.dap.Play,
				run_last = pkgs.user_icons.dap.RunLast,
				step_back = pkgs.user_icons.dap.StepBack,
				step_into = pkgs.user_icons.dap.StepInto,
				step_out = pkgs.user_icons.dap.StepOut,
				step_over = pkgs.user_icons.dap.StepOver,
				terminate = pkgs.user_icons.dap.Terminate,
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
end

return M
