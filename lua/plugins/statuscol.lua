-- @module plugins.statuscol
local M = {}

function M.config()
	local builtin = require("statuscol.builtin")

	require("statuscol").setup({
		-- @todo: extract filetypes into const file
		ft_ignore = { "aerial", "help", "NvimTree" },
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
