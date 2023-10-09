-- @module plugin_config.lsp
local M = {}

function M.config()
	-- Set up mason FIRST
	require("mason").setup()
	require("mason-lspconfig").setup({ automatic_installation = false })

	-- Set up other stuff
	require("plugin_config.lsp.auto_complete").configure()
	require("plugin_config.lsp.auto_format").configure()
	require("plugin_config.lsp.diagnostics").configure()
	require("plugin_config.lsp.keybindings").configure()
	require("plugin_config.lsp.server_configs").configure()
end

return M
