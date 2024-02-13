-- @module plugins.dap
local M = {}

local after_open
local build_ft_to_bufnrs
local build_ft_to_winnrs
local WinOptManager

function M.config()
	local dap = require("dap")
	local dap_ext_vscode = require("dap.ext.vscode")
	local dapui = require("dapui")
	local baleia = require("baleia").setup()

	local const_ft = require("const.filetypes")
	local user_icons = require("const.user_icons")

	--[[
  KEYBOARD SHORTCUTS
  - lua plugin debugging

  UI
  - breakpoint UI
  - switch the "arrow" icons to chevron
  
  - command to clear the repl
  - update cmp source
  - double-check "missing-fields"
  - generalize "WinOptManager"...?
  ]]
	--

	vim.keymap.set("", "<leader>de", function()
		dapui.toggle()
		after_open(const_ft, baleia)
	end, { noremap = true })
	vim.keymap.set("", "<leader>db", dap.toggle_breakpoint, { noremap = true })
	vim.keymap.set("", "<leader>dp", function()
		dapui.open()
		after_open(const_ft, baleia)
		dap.continue()
	end, { noremap = true })
	vim.keymap.set("", "<leader>dl", dap.step_over, { noremap = true })
	vim.keymap.set("", "<leader>dh", dap.step_back, { noremap = true })
	vim.keymap.set("", "<leader>dr", dap.run_last, { noremap = true })
	vim.keymap.set("", "<leader>ds", dap.terminate, { noremap = true })
	vim.keymap.set("", "<leader>dd", dap.disconnect, { noremap = true })
	vim.keymap.set("", "<leader>dk", function() dapui.eval(nil, { enter = true }) end, { noremap = true })

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
			after_open(const_ft, baleia)
		end,
	})
end

---@type boolean
local has_escaped_repl = false

function after_open(const_ft, baleia)
	-- set up ANSI-escape in the dap repl
	if not has_escaped_repl then
		local repl_bufnrs = build_ft_to_bufnrs()[const_ft.DapRepl]
		for _, bufnr in ipairs(repl_bufnrs) do
			baleia.automatically(bufnr)
		end
		has_escaped_repl = true
	end

	local win_opt_mgr = WinOptManager:new()

	local all_dap_fts = {
		const_ft.DapRepl,
		const_ft.DapuiBreakpoints,
		const_ft.DapuiConsole,
		const_ft.DapuiScopes,
		const_ft.DapuiStacks,
		const_ft.DapuiWatches,
	}

	-- Disable folds
	for _, ft in ipairs(all_dap_fts) do
		win_opt_mgr:set(ft, "foldenable", false)
	end

	-- Set up the statusline hl group
	for _, ft in ipairs(all_dap_fts) do
		win_opt_mgr:append(ft, "winhighlight", "StatusLine:NormalBg,StatusLineNC:Normal")
	end

	-- Set up horizontal dividers between windows
	for _, ft in ipairs({
		const_ft.DapuiScopes,
		const_ft.DapuiWatches,
		const_ft.DapuiStacks,
	}) do
		-- win_opt_mgr:append(ft, "fillchars", "stl:━,stlnc:━")
		win_opt_mgr:append(ft, "fillchars", "stl:─,stlnc:─")
	end

	-- Set up winbar
	win_opt_mgr:set(const_ft.DapuiScopes, "winbar", "%#Normal#Variables")
	win_opt_mgr:set(const_ft.DapuiWatches, "winbar", "%#Normal#Watch")
	win_opt_mgr:set(const_ft.DapuiStacks, "winbar", "%#Normal#Call Stack")
	win_opt_mgr:set(const_ft.DapuiBreakpoints, "winbar", "%#Normal#Breakpoints")
end

---@return table<string, integer[]>
function build_ft_to_bufnrs()
	local ret = {}
	local buffers = vim.fn.getbufinfo()
	for _, buf in ipairs(buffers) do
		local ft = vim.bo[buf.bufnr].filetype
		ret[ft] = ret[ft] or {}
		table.insert(ret[ft], buf.bufnr)
	end
	return ret
end

---@return table<string, integer[]>
function build_ft_to_winnrs()
	local ret = {}
	for ft, bufnrs in pairs(build_ft_to_bufnrs()) do
		ret[ft] = ret[ft] or {}
		for _, bufnr in ipairs(bufnrs) do
			local winnrs = vim.fn.win_findbuf(bufnr)
			for _, winnr in ipairs(winnrs) do
				table.insert(ret[ft], winnr)
			end
		end
	end
	return ret
end

---@class WinOptManager
---@field private ft_to_winnrs table<string, integer[]> a map from filetype to window numbers
WinOptManager = {}
function WinOptManager:new()
	self.ft_to_winnrs = build_ft_to_winnrs()
	return self
end

---@param ft string the filetype
---@param opt_name string
---@param val any
function WinOptManager:set(ft, opt_name, val)
	local winnrs = self.ft_to_winnrs[ft]
	for _, winnr in ipairs(winnrs) do
		vim.wo[winnr][opt_name] = val
		-- vim.api.nvim_set_option_value(opt_name, val, { win = winnr, scope = "local" })
	end
end

---@param ft string the filetype
---@param opt_name string
---@param append_val string
function WinOptManager:append(ft, opt_name, append_val)
	if append_val == "" then
		error("passed in an empty `append_val`")
		return
	end
	local winnrs = self.ft_to_winnrs[ft]
	for _, winnr in ipairs(winnrs) do
		local cur_val = vim.wo[winnr][opt_name]
		local new_val = (cur_val == "" and append_val) or cur_val .. "," .. append_val
		vim.wo[winnr][opt_name] = new_val
		-- vim.api.nvim_set_option_value(opt_name, new_val, { win = winnr, scope = "local" })
	end
end

return M
