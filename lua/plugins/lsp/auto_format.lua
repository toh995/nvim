-- @module plugins.lsp.auto_format
local M = {}

local build_eslint_d
local build_fourmolu

function M.configure()
	local lspconfig = require("lspconfig")

	local fs = require("efmls-configs.fs")

	local black = require("efmls-configs.formatters.black")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local ruff = require("efmls-configs.formatters.ruff")
	local stylua = require("efmls-configs.formatters.stylua")

	local util = require("../../util")

	local eslint_d = build_eslint_d(fs)
	local fourmolu = build_fourmolu(fs)

	-----------------------------------
	-- Build languages and filetypes --
	-----------------------------------
	local languages = {
		haskell = { fourmolu },
		lua = { stylua },
		python = { black, ruff },
	}

	-- Web-dev
	for _, lang in ipairs({ "javascript", "typescript" }) do
		-- List eslint LAST, to ensure it takes precedence over prettier
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

function build_eslint_d(fs)
	-- Adapted from https://github.com/creativenull/efmls-configs-nvim/blob/b273ecd/lua/efmls-configs/formatters/eslint_d.lua
	-- The only thing I changed was, adding the argument `--report-unused-disable-directives`
	local formatter = "eslint_d"
	local args = "--report-unused-disable-directives --fix-to-stdout --stdin-filename '${INPUT}' --stdin"
	local command = string.format("%s %s", fs.executable(formatter, fs.Scope.NODE), args)

	return {
		formatCommand = command,
		formatStdin = true,
	}
end

function build_fourmolu(fs)
	-- Adapted from https://github.com/creativenull/efmls-configs-nvim/blob/b273ecd/lua/efmls-configs/formatters/fourmolu.lua
	-- The only thing I changed was, adding the argument `--indentation=2`
	local formatter = "fourmolu"
	local command = string.format("%s --indentation=2 --stdin-input-file '${INPUT}' -", fs.executable(formatter))

	return {
		prefix = formatter,
		formatCommand = command,
		formatStdin = true,
	}
end

return M
