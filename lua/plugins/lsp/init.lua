-- @module plugins.lsp
local M = {}

function M.config()
	-- Set up mason FIRST
	require("mason").setup()
	require("mason-lspconfig").setup({ automatic_installation = false })

	-- Set up other stuff
	require("plugins.lsp.auto_complete").configure()
	require("plugins.lsp.auto_format").configure()
	require("plugins.lsp.diagnostics").configure()
	require("plugins.lsp.keybindings").configure()
	require("plugins.lsp.server_configs").configure()

	-- Rounded borders
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M
