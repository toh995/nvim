-- @module plugin_config.lsp
local lsp = {}

local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local on_attach
local get_capabilities
local configure_autocomplete

function lsp.configure()
	local SERVER_NAMES = { "sumneko_lua", "tsserver" }

	-- set up mason FIRST
	mason.setup()
	mason_lspconfig.setup({
		ensure_installed = SERVER_NAMES
	})

	-- now set up each of the language servers
	-- todo: display a loading progress bar for LSP
	-- https://github.com/arkav/lualine-lsp-progress
	-- https://github.com/nvim-lua/lsp-status.nvim
	local capabilities = get_capabilities()

	for _, server_name in ipairs(SERVER_NAMES) do
		lspconfig[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach
		})
	end

	-- autcomplete
	configure_autocomplete()

	-- custom config
	lspconfig.sumneko_lua.setup({
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim
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
	vim.keymap.set("", "<leader>gd", vim.lsp.buf.definition, { noremap=true, buffer=bufnr })
	vim.keymap.set("", "<leader>rn", vim.lsp.buf.rename, { noremap=true, buffer=bufnr })
	vim.keymap.set("", "<leader>gr", vim.lsp.buf.references, { noremap=true, buffer=bufnr })
	vim.keymap.set("", "<leader>k", vim.lsp.buf.hover, { noremap=true, buffer=bufnr })
end

function get_capabilities()
    local ret = vim.lsp.protocol.make_client_capabilities()
    ret = cmp_nvim_lsp.update_capabilities(ret)
    return ret
end

function configure_autocomplete()
	cmp.setup({
		sources = {
			{ name = "buffer" },
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "path" },
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

return lsp
