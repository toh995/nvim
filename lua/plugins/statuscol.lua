-- @module plugins.statuscol
local M = {}

function M.config()
	local builtin = require("statuscol.builtin")

	local const_ft = require("const.filetypes")

	require("statuscol").setup({
		ft_ignore = {
			const_ft.Aerial,
			const_ft.Help,
			const_ft.NvimTree,
		},
		segments = {
			-- Breakpoints
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
