-- @module plugin_config.lsp
local lsp = {}

local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_null_ls = require("mason-null-ls")
local null_ls = require("null-ls")

local on_attach
local get_capabilities
local configure_autocomplete

function lsp.configure()
	-- todo: add glint to mason
	local SERVER_NAMES = { "ember", "eslint", "glint", "html", "sumneko_lua", "tsserver" }

	-- set up mason FIRST
	mason.setup()
	mason_lspconfig.setup({
		ensure_installed = SERVER_NAMES,
		--automatic_installation = true,
	})

	-- now set up each of the language servers
	-- todo: display a loading progress bar for LSP
	-- https://github.com/arkav/lualine-lsp-progress
	-- https://github.com/nvim-lua/lsp-status.nvim
	local capabilities = get_capabilities()

	for _, server_name in ipairs(SERVER_NAMES) do
		lspconfig[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end

	-- autcomplete
	configure_autocomplete()

	-- custom config
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.eslint_d,
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.formatting.stylua,
		},
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						print("OH BOY")
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

	mason_null_ls.setup({ automatic_installation = true })

	-- autofix eslint on save
	-- todo: use ``
	--vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	--   pattern = { "*.tsx", "*.ts", "*.jsx", "*.js*" },
	--   command = "EslintFixAll",
	--})

	-- todo: refactor this...
	lspconfig.html.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "html", "handlebars" },
	})

	-- set up lua
	lspconfig.sumneko_lua.setup({
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
				},
				telemetry = {
					-- Do not send telemetry data containing a randomized but unique identifier
					enable = false,
				},
			},
		},
	})
end

function on_attach(_, bufnr)
	vim.keymap.set("", "<leader>gd", vim.lsp.buf.definition, { noremap = true, buffer = bufnr })
	vim.keymap.set("", "<leader>rn", vim.lsp.buf.rename, { noremap = true, buffer = bufnr })
	vim.keymap.set("", "<leader>gr", vim.lsp.buf.references, { noremap = true, buffer = bufnr })
	vim.keymap.set("", "<leader>k", vim.lsp.buf.hover, { noremap = true, buffer = bufnr })
end

function get_capabilities()
	local ret = vim.lsp.protocol.make_client_capabilities()
	ret = cmp_nvim_lsp.update_capabilities(ret)
	return ret
end

function configure_autocomplete()
	if cmp == nil then
		return
	else
		cmp.setup({
			sources = {
				{ name = "buffer" },
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "path" },
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
		})
	end
end

return lsp
