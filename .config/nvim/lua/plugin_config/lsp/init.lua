-- @module plugin_config.lsp
local lsp = {}

local configure_autocomplete
local configure_null_ls

function lsp.config()
	local pkgs = {
		cmp = require("cmp"),
		lspkind = require("lspkind"),
		luasnip = require("luasnip"),
		mason = require("mason"),
		mason_lspconfig = require("mason-lspconfig"),
		mason_null_ls = require("mason-null-ls"),
		null_ls = require("null-ls"),
	}

	local server_configs = require("plugin_config.lsp.server_configs")

	-- Set up mason FIRST
	--
	-- NOTE: if BOTH:
	--   - You use NixOS
	--   - You use mason to install stuff
	-- then, the below code will break.
	--
	-- To avoid this, use nix to install stuff.
	pkgs.mason.setup()
	pkgs.mason_lspconfig.setup({ automatic_installation = false }) -- NOTE: would love to set this to true someday! Not working as of 2022-11-13

	configure_autocomplete(pkgs)
	configure_null_ls(pkgs)
	server_configs.configure()
end

function configure_autocomplete(pkgs)
	if pkgs.cmp == nil then
		return
	else
		pkgs.cmp.setup({
			sources = {
				{ name = "buffer" },
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "path" },
			},
			snippet = {
				expand = function(args)
					pkgs.luasnip.lsp_expand(args.body)
				end,
			},
			mapping = pkgs.cmp.mapping.preset.insert({
				["<CR>"] = pkgs.cmp.mapping.confirm({ select = true }),
				["<Tab>"] = pkgs.cmp.mapping(function(fallback)
					if pkgs.cmp.visible() then
						pkgs.cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = pkgs.cmp.mapping(function(fallback)
					if pkgs.cmp.visible() then
						pkgs.cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			formatting = {
				format = pkgs.lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
					menu = {
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
						latex_symbols = "[Latex]",
					},
				}),
			},
		})
	end
end

function configure_null_ls(pkgs)
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	pkgs.null_ls.setup({
		sources = {
			-- Lua
			pkgs.null_ls.builtins.formatting.stylua,

			-- Python
			pkgs.null_ls.builtins.formatting.black,
			pkgs.null_ls.builtins.formatting.ruff,

			-- JS, TS, HTML
			-- List eslint LAST, to ensure it takes precedence over prettier
			pkgs.null_ls.builtins.formatting.prettierd.with({
				disabled_filetypes = { "markdown", "yaml" },
			}),
			pkgs.null_ls.builtins.formatting.eslint_d.with({
				extra_args = { "--report-unused-disable-directives", "--fix" },
			}),
		},
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							bufnr = bufnr,
							filter = function(c)
								return c.name == "null-ls"
							end,
						})
					end,
				})
			end
		end,
	})

	pkgs.mason_null_ls.setup({ automatic_installation = false }) -- NOTE: would love to set this to true someday! Not working as of 2022-11-13
end

return lsp
