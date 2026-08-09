-- @module plugins.lsp.server_configs
local M = {}

function M.configure()
	local blink = require("blink.cmp")
	local coq_lsp = require("coq-lsp")
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
					formattingProvider = "fourmolu",
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

	-- Coq / Rocq (also uses its own setup method)
	coq_lsp.setup({
		-- coq-lsp.nvim's own knobs (client-side, not sent to the server).
		coq_lsp_nvim = {
			-- Every cursor move (CursorMoved AND CursorMovedI) fires a
			-- proof/goals request + full panel re-render, debounced by
			-- this many ms. Lower = the goal panel keeps up; higher
			-- makes it lag behind. 100 stays snappy so goals
			-- refresh quickly once the cursor settles.
			goals_debounce = 100,
		},
		lsp = {
			capabilities = capabilities,
			-- Forwarded to the coq-lsp *server* as initializationOptions.
			init_options = {
				-- 0 = plain-string goals. The default (1 = jsCoq's rich Pp)
				-- sends structured objects, but this plugin's render.lua only
				-- handles strings. Strings are also cheaper to produce + send.
				-- (Correctness + speed.)
				pp_type = 0,
				-- This only feeds VS Code's perf panel; the nvim client has
				-- nothing to render it. Pure waste on every response.
				send_perf_data = false,
				-- Stream diagnostics as the lazy check advances, so errors
				-- show up to your checked frontier — like stepping through
				-- Proof General. With this OFF and check_only_on_request
				-- ON, a full check never runs, so you get NO diagnostics
				-- at all. Leave it on.
				eager_diagnostics = true,
				-- Lazy checking: only check up to where goals are
				-- requested, not the whole file continuously. Stops the
				-- noisy per-tick $/coq/fileProgress highlight repaint
				-- that was lagging the progress window while typing.
				check_only_on_request = true,
			},
		},
	})
end

return M
