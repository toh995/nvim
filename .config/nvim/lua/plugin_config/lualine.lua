-- @module plugin_config.lualine
local M = {}

function M.config()
	local lualine = require("lualine")

	local DiagnosticIcons = require("plugin_config.lsp.diagnostics").Icons

	-- icon for the window's file
	local filetype = {
		"filetype",
		icon_only = true,
		separator = "",
	}

	local filename = {
		"filename",
		path = 1, -- show relative filepath
		separator = "",
		padding = 0,
		symbols = {
			modified = "[+]",
			readonly = "",
			unnamed = "[No Name]",
			newfile = "[New]",
		},
	}

	local diagnostics = {
		"diagnostics",
		symbols = {
			error = DiagnosticIcons.ERROR,
			warn = DiagnosticIcons.WARN,
			info = DiagnosticIcons.INFO,
			hint = DiagnosticIcons.HINT,
		},
	}

	-- show the current line number/column
	-- see `:h statusline`
	-- %l == current line number
	-- %L == total number of lines in buffer
	-- %c == current column number
	local location = function()
		return "ln %l/%L:%c"
	end

	lualine.setup({
		options = {
			disabled_filetypes = { statusline = { "help", "NvimTree" } },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { diagnostics },
			lualine_c = { filetype, filename },
			lualine_x = {},
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

return M
