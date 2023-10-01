-- @module plugin_config.lsp.auto_format
local auto_format = {}

function auto_format.configure()
	local mason_null_ls = require("mason-null-ls")
	local null_ls = require("null-ls")

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup({
		sources = {
			-- Lua
			null_ls.builtins.formatting.stylua,

			-- Python
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.ruff,

			-- JS, TS, HTML
			-- List eslint LAST, to ensure it takes precedence over prettier
			null_ls.builtins.formatting.prettierd.with({
				disabled_filetypes = { "markdown", "yaml" },
			}),
			null_ls.builtins.formatting.eslint_d.with({
				extra_args = { "--report-unused-disable-directives", "--fix" },
			}),
		},
		on_attach = function(client, bufnr)
			-- auto-format on save
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

	mason_null_ls.setup({
		ensure_installed = {},
		automatic_installation = false,
	})
end

return auto_format
