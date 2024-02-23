-- @module plugins.dap.windows
local M = {}

---@return boolean
function M.is_open()
	local dapui_windows = require("dapui.windows")
	for _, win_layout in ipairs(dapui_windows.layouts) do
		if win_layout:is_open() then
			return true
		end
	end
	return false
end

---@type boolean
local has_escaped_repl = false

---@return nil
function M.after_open()
	local baleia = require("baleia").setup()
	local util_vim = require("util.vim.init")
	local WinOptManager = require("util.vim.win_opt_manager")

	local const_ft = require("const.filetypes")

	-- set up ANSI-escape in the dap repl
	if not has_escaped_repl then
		local repl_bufnrs = util_vim.build_ft_to_bufnrs()[const_ft.DapRepl]
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

return M
