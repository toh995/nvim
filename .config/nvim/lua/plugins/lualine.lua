-- @module plugins.lualine
local M = {}

function M.config()
	local lualine = require("lualine")
	local lsp_progress = require("lsp-progress")

	local DiagnosticIcons = require("plugins.lsp.diagnostics").Icons

	local filetype = {
		"filetype",
		icon_only = true,
		separator = "",
	}

	local filename = {
		"filename",
		path = 1, -- show relative filepath
		separator = "/",
		padding = { left = 0, right = 1 },
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

	local lsp_clients = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

		local ret = " LSP:" .. #clients

		if #clients == 1 or #clients == 2 then
			local client_names = {}
			for _, client in ipairs(clients) do
				table.insert(client_names, "[" .. client.name .. "]")
			end
			return ret .. " " .. table.concat(client_names, " ")
		end

		return ret
	end

	-- show loading animations
	local lsp_status = lsp_progress.progress
	-- additional setup for lsp status
	lsp_progress.setup({
		spin_update_time = 75,
		format = function(client_messages)
			return #client_messages > 0 and table.concat(client_messages, " ") or ""
		end,
	})
	-- auto-refresh lualine, for LSP progress events
	vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = "lualine_augroup",
		pattern = "LspProgressStatusUpdated",
		callback = require("lualine").refresh,
	})

	lualine.setup({
		options = {
			disabled_filetypes = { statusline = { "help", "NvimTree" } },
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

return M
