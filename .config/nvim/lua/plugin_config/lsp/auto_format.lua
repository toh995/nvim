-- @module plugin_config.lsp.auto_format
local auto_format = {}

function auto_format.configure()
	local lspconfig = require("lspconfig")

	local black = require("efmls-configs.formatters.black")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local ruff = require("efmls-configs.formatters.ruff")
	local stylua = require("efmls-configs.formatters.stylua")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	local util = require("../../util")

	-----------------------------------
	-- Build languages and filetypes --
	-----------------------------------
	local languages = {
		lua = { stylua },
		python = { black, ruff },
	}

	-- Web-dev
	for _, lang in ipairs({ "javascript", "typescript" }) do
		-- List eslint LAST, to ensure it takes precedence over prettier
		--extra_args = { "--report-unused-disable-directives", "--fix" },
		languages[lang] = { prettier_d, eslint_d }
	end
	for _, lang in ipairs({ "css", "html", "json", "jsonc", "handlebars" }) do
		languages[lang] = { prettier_d }
	end

	local filetypes = util.tbl_keys(languages)

	----------------
	-- Set up efm --
	----------------
	lspconfig.efm.setup({
		filetypes = filetypes,
		settings = {
			rootMarkers = { ".git/" },
			languages = languages,
		},
		init_options = {
			documentFormatting = true,
			-- Format a subset of a document
			-- documentRangeFormatting = true,
		},
	})

	---------------------------
	-- Set up format on save --
	---------------------------
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		callback = function(args)
			local efm = vim.lsp.get_active_clients({ name = "efm", bufnr = args.buf })
			if vim.tbl_isempty(efm) then
				return
			end
			vim.lsp.buf.format({ name = "efm", bufnr = args.buf })
		end,
	})
end

return auto_format
