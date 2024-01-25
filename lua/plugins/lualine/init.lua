-- @module plugins.lualine
local M = {}

local set_autocmds

function M.config()
	local lualine = require("lualine")
	local highlight = require("lualine.highlight")

	local const_ft = require("const.filetypes")
	local diagnostics = require("plugins.lualine.components.diagnostics")
	local filetype = require("plugins.lualine.components.filetype")
	local filename = require("plugins.lualine.components.filename")
	local location = require("plugins.lualine.components.location")
	local lsp_clients = require("plugins.lualine.components.lsp_clients")
	local lsp_status = require("plugins.lualine.components.lsp_status")

	local pkgs = {
		const_ft = const_ft,
		highlight = highlight,
		lualine = lualine,
	}
	set_autocmds(pkgs)

	-- Set up lualine
	lualine.setup({
		options = {
			disabled_filetypes = {
				statusline = { const_ft.Aerial, const_ft.Help, const_ft.NvimTree },
				winbar = { const_ft.Aerial, const_ft.Help, const_ft.NvimTree },
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { diagnostics },
			lualine_c = { filetype, filename, lsp_status },
			lualine_x = { lsp_clients },
			lualine_y = { "progress" },
			lualine_z = { location },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { filetype, filename },
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
	})
end

function set_autocmds(pkgs)
	local augroup = vim.api.nvim_create_augroup("lualine_custom", { clear = true })

	-- Auto-refresh lualine, for LSP progress events
	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = "LspProgressStatusUpdated",
		callback = pkgs.lualine.refresh,
	})

	-- Ensure the WinSeparator is correct in the statusline
	vim.api.nvim_create_autocmd({ "ModeChanged" }, {
		group = augroup,
		callback = function()
			local hl_group = "lualine_a" .. pkgs.highlight.get_mode_suffix()
			vim.api.nvim_set_hl(0, "StatusLine", { link = hl_group })
		end,
	})

	-- HACK: For some reason, the lualine option `disabled_filetypes` doesn't
	-- work for the `help` filetype ¯\_(ツ)_/¯
	-- Let's force-disable it here via autocommand
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = augroup,
		callback = function(opts)
			if opts.match == pkgs.const_ft.Help then
				vim.opt_local.statusline = ""
			end
		end,
	})
end

return M
