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

	local disabled_fts = {
		const_ft.Aerial,
		const_ft.DapRepl,
		const_ft.DapuiBreakpoints,
		const_ft.DapuiConsole,
		const_ft.DapuiScopes,
		const_ft.DapuiStacks,
		const_ft.DapuiWatches,
		const_ft.Help,
		const_ft.NvimTree,
	}

	-- Set up lualine
	lualine.setup({
		options = {
			disabled_filetypes = {
				statusline = disabled_fts,
				winbar = disabled_fts,
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
end

return M
