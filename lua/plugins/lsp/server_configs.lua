-- @module plugins.lsp.server_configs
local M = {}

function M.configure()
	local blink = require("blink.cmp")
	local lspconfig = require("lspconfig")
	local neodev = require("neodev") -- lua extras
	local typescript_tools = require("typescript-tools")

	-- set rounded borders for :LspInfo
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local capabilities = blink.get_lsp_capabilities()

	-- Bash
	lspconfig.bashls.setup({ capabilities = capabilities })

	-- Docker
	lspconfig.dockerls.setup({ capabilities = capabilities })

	-- Ember
	lspconfig.ember.setup({ capabilities = capabilities })
	lspconfig.glint.setup({ capabilities = capabilities })

	-- Go
	lspconfig.gopls.setup({ capabilities = capabilities })
	lspconfig.golangci_lint_ls.setup({ capabilities = capabilities })

	-- Haskell
	lspconfig.hls.setup({
		capabilities = capabilities,
		filetypes = { "haskell", "lhaskell", "cabal" },
		settings = {
			haskell = {
				plugin = {
					-- Configure renames
					rename = {
						globalOn = true,
						renameOn = true,
						config = {
							-- Experimental cross-module renaming
							crossModule = true,
						},
					},
				},
			},
		},
	})

	-- HTML/CSS
	lspconfig.cssls.setup({ capabilities = capabilities })
	lspconfig.html.setup({
		capabilities = capabilities,
		filetypes = { "html", "handlebars" },
	})

	-- JS/TS
	lspconfig.eslint.setup({
		capabilities = capabilities,
		cmd_env = { NODE_OPTIONS = "--max-old-space-size=16384" },
	})
	typescript_tools.setup({
		capabilities = capabilities,
		settings = {
			tsserver_max_memory = 16384,
			publish_diagnostic_on = "change",
		},
	})

	-- Lua
	neodev.setup({
		library = {
			types = true,
			plugins = { "nvim-dap-ui" },
		},
	})
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = {
					-- Do not send telemetry data containing a randomized but unique identifier
					enable = false,
				},
			},
		},
	})

	-- Nix
	lspconfig.nil_ls.setup({ capabilities = capabilities })

	-- Protobuf
	lspconfig.buf_ls.setup({ capabilities = capabilities })

	-- Python
	lspconfig.pylsp.setup({ capabilities = capabilities })
	-- lspconfig.pyright.setup({ capabilities = capabilities })
	lspconfig.ruff.setup({ capabilities = capabilities })
end

return M
