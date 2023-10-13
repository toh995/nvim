-- @module plugins.lualine.components.lsp_status
local lsp_progress = require("lsp-progress")

lsp_progress.setup({
	spin_update_time = 75,
	format = function(client_messages)
		return #client_messages > 0 and table.concat(client_messages, " ") or ""
	end,
})

return lsp_progress.progress
