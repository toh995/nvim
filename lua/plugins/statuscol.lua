-- @module plugins.statuscol
local M = {}

function M.config()
	local builtin = require("statuscol.builtin")

	local const_ft = require("const.filetypes")

	require("statuscol").setup({
		ft_ignore = {
			const_ft.Aerial,
			const_ft.DapRepl,
			const_ft.DapuiBreakpoints,
			const_ft.DapuiConsole,
			const_ft.DapuiScopes,
			const_ft.DapuiStacks,
			const_ft.DapuiWatches,
			const_ft.Help,
			const_ft.NvimTree,
		},
		segments = {
			-- Breakpoints
			-- Signs defined in `plugins.dap.signs_ui`
			{
				sign = {
					name = { "Dap*" },
					auto = true,
				},
			},
			-- Line numbers
			{
				text = { builtin.lnumfunc, " " },
				condition = { true, builtin.not_empty },
				click = "v:lua.ScLa",
			},
			-- Gitsigns + diagnostics
			-- Diagnostic signs defined in `plugins.lsp.diagnostics`
			{
				sign = {
					namespace = { "gitsign*" },
					name = { "Diagnostic*" },
					auto = true,
				},
			},
			-- Fold symbols
			{
				text = {
					function(...) return builtin.foldfunc(...) .. "  " end,
				},
				click = "v:lua.ScFa",
			},
		},
	})
end

return M
