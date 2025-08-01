-- @module plugins.lsp
local M = {}

function M.config()
	-- Set up mason FIRST
	require("mason").setup({
		ui = { border = "rounded" },
	})
	require("mason-lspconfig").setup({ automatic_installation = false })

	-- Set up other stuff
	require("plugins.lsp.diagnostics").configure()
	require("plugins.lsp.keybindings").configure()
	require("plugins.lsp.server_configs").configure()
end

return M
