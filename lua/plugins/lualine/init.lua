-- @module plugins.lualine
local M = {}

function M.config()
	local lualine = require("lualine")

	local diagnostics = require("plugins.lualine.components.diagnostics")
	local filetype = require("plugins.lualine.components.filetype")
	local filename = require("plugins.lualine.components.filename")
	local location = require("plugins.lualine.components.location")
	local lsp_clients = require("plugins.lualine.components.lsp_clients")
	local lsp_status = require("plugins.lualine.components.lsp_status")

	-- Auto-refresh lualine, for LSP progress events
	vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = "lualine_augroup",
		pattern = "LspProgressStatusUpdated",
		callback = lualine.refresh,
	})

	-- Set up lualine
	lualine.setup({
		options = {
			disabled_filetypes = {
				statusline = { "aerial", "help", "NvimTree" },
				winbar = { "aerial", "help", "NvimTree" },
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

		winbar = {
			lualine_c = {
				-- {
				-- 	"navic",
				-- 	color_correction = nil,
				-- 	navic_opts = nil,
				-- },
				-- {
				-- 	"aerial",
				-- },
			},
		},
	})
end

return M
