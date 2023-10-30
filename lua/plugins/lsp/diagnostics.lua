-- @module plugins.lsp.diagnostics
local M = {}

function M.configure()
	local user_icons = require("const.user_icons")

	-- set up some diagnostic behavior
	vim.diagnostic.config({
		update_in_insert = true,
		severity_sort = true,
		float = { border = "rounded" },
		-- TODO: in nvim 0.10.0+, for the prefix we can pass in
		-- a function which returns the diagnostics icon, based on
		-- the severity
		virtual_text = { prefix = "●" },
	})

	-- set the icons for the signs column
	-- i.e. the column left of the line numbers
	for name, icon in pairs(user_icons.diagnostics) do
		local hl = "DiagnosticSign" .. name
		vim.fn.sign_define(hl, {
			text = icon,
			texthl = hl,
			numhl = hl,
		})
	end
end

return M
