-- @module plugins.statuscol
local M = {}

function M.config()
	local builtin = require("statuscol.builtin")

	local ft = require("const.filetypes")

	require("statuscol").setup({
		ft_ignore = {
			ft.Aerial,
			ft.Help,
			ft.NvimTree,
		},
		segments = {
			-- Fold symbols
			{
				text = {
					function(...)
						return builtin.foldfunc(...) .. " "
					end,
				},
				click = "v:lua.ScFa",
			},
			-- Signs column (git + diagnostics)
			{ text = { "%s" }, click = "v:lua.ScSa" },
			-- Line numbers
			{
				text = { builtin.lnumfunc, " " },
				condition = { true, builtin.not_empty },
				click = "v:lua.ScLa",
			},
		},
	})
end

return M
