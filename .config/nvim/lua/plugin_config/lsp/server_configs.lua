-- @module plugin_config.lsp.server_configs
local server_configs = {}

function server_configs.configure()
	local pkgs = {
		builtin = require("telescope.builtin"),
		cmp_nvim_lsp = require("cmp_nvim_lsp"),
		lspconfig = require("lspconfig"),
	}

	-- capabilities and set_lsp_keybindings
	-- will be passed to all servers
	local capabilities = pkgs.cmp_nvim_lsp.default_capabilities()

	local function set_lsp_keybindings(_, bufnr)
		vim.keymap.set("", "<leader>gd", pkgs.builtin.lsp_definitions, { noremap = true, buffer = bufnr })
		vim.keymap.set("", "<leader>gr", pkgs.builtin.lsp_references, { noremap = true, buffer = bufnr })
		-- vim.keymap.set("", "<leader>gd", vim.lsp.buf.definition, { noremap = true, buffer = bufnr })
		-- vim.keymap.set("", "<leader>gr", vim.lsp.buf.references, { noremap = true, buffer = bufnr })
		vim.keymap.set("", "<leader>rn", vim.lsp.buf.rename, { noremap = true, buffer = bufnr })
		vim.keymap.set("", "<leader>k", vim.lsp.buf.hover, { noremap = true, buffer = bufnr })
		vim.keymap.set("", "<leader>d", vim.diagnostic.open_float, { noremap = true })
	end

	---------
	-- CSS --
	---------
	pkgs.lspconfig.cssls.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-----------
	-- Ember --
	-----------
	pkgs.lspconfig.ember.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-------------
	-- ES Lint --
	-------------
	pkgs.lspconfig.eslint.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-----------
	-- GLint --
	-----------
	pkgs.lspconfig.glint.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-------------
	-- Haskell --
	-------------
	pkgs.lspconfig.hls.setup({})

	----------
	-- HTML --
	----------
	pkgs.lspconfig.html.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
		filetypes = { "html", "handlebars" },
	})

	---------
	-- Lua --
	---------
	pkgs.lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
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

	---------
	-- Nix --
	---------
	pkgs.lspconfig.nil_ls.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	------------
	-- Python --
	------------
	-- do we need "pyright" too...?
	local python_servers = { "pylsp", "ruff_lsp" }

	for _, server in ipairs(python_servers) do
		pkgs.lspconfig[server].setup({
			capabilities = capabilities,
			on_attach = set_lsp_keybindings,
		})
	end

	---------------------------
	-- TypeScript/JavaScript --
	---------------------------
	pkgs.lspconfig.tsserver.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})
end

return server_configs
