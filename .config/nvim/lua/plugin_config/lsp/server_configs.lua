-- @module plugin_config.lsp.server_configs
local server_configs = {}

function server_configs.configure()
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local lspconfig = require("lspconfig")

	local capabilities = cmp_nvim_lsp.default_capabilities()

	-- Ember
	lspconfig.ember.setup({ capabilities = capabilities })
	lspconfig.glint.setup({ capabilities = capabilities })

	-- Haskell
	lspconfig.hls.setup({ capabilities = capabilities })

	-- HTML/CSS
	lspconfig.cssls.setup({ capabilities = capabilities })
	lspconfig.html.setup({
		capabilities = capabilities,
		filetypes = { "html", "handlebars" },
	})

	-- JS/TS
	lspconfig.eslint.setup({ capabilities = capabilities })
	lspconfig.tsserver.setup({ capabilities = capabilities })

	-- Lua
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

	-- Python
	lspconfig.pylsp.setup({ capabilities = capabilities })
	-- lspconfig.pyright.setup({ capabilities = capabilities })
	lspconfig.ruff_lsp.setup({ capabilities = capabilities })
end

return server_configs
