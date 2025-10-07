-- @module plugins.lsp.server_configs
local M = {}

function M.configure()
	local blink = require("blink.cmp")
	local typescript_tools = require("typescript-tools")

	-- set rounded borders for :LspInfo
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local capabilities = blink.get_lsp_capabilities()

	-- Modern LSP configuration using vim.lsp.config()
	local servers = {
		-- Bash
		bashls = { capabilities = capabilities },

		-- Docker
		dockerls = { capabilities = capabilities },

		-- Ember
		ember = { capabilities = capabilities },
		glint = { capabilities = capabilities },

		-- Go
		gopls = { capabilities = capabilities },
		golangci_lint_ls = { capabilities = capabilities },

		-- Haskell
		hls = {
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
		},

		-- HTML/CSS
		cssls = { capabilities = capabilities },
		html = {
			capabilities = capabilities,
			filetypes = { "html", "handlebars" },
		},

		-- JS/TS
		eslint = {
			capabilities = capabilities,
			cmd_env = { NODE_OPTIONS = "--max-old-space-size=16384" },
		},

		-- Lua (modern configuration - lazydev handles workspace setup)
		lua_ls = {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					telemetry = {
						enable = false,
					},
					-- workspace settings removed - handled by lazydev
				},
			},
		},

		-- Nix
		nil_ls = { capabilities = capabilities },

		-- Protobuf
		buf_ls = { capabilities = capabilities },

		-- Python
		basedpyright = { capabilities = capabilities },
		ruff = { capabilities = capabilities },
	}

	-- Configure servers using modern vim.lsp.config
	for server_name, config in pairs(servers) do
		vim.lsp.config(server_name, config)
		vim.lsp.enable(server_name)
	end

	-- TypeScript Tools (still uses its own setup method)
	typescript_tools.setup({
		capabilities = capabilities,
		settings = {
			tsserver_max_memory = 16384,
			publish_diagnostic_on = "change",
		},
	})
end

return M
