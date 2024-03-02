-- @module plugins.bufferline
local M = {}

local build_offsets

function M.config()
	local bufferline = require("bufferline")

	local const_ft = require("const.filetypes")
	local user_icons = require("const.user_icons")

	-- set up some keyboard shortcuts for tabs
	vim.keymap.set("", "t", ":tabnew<CR>", { noremap = true })
	-- move current window to a new tab
	vim.keymap.set("", "T", "<C-W>T", { noremap = true })
	vim.keymap.set("", "Q", ":tabclose<CR>", { noremap = true })
	vim.keymap.set("", "J", ":BufferLineCyclePrev<CR>", { noremap = true })
	vim.keymap.set("", "K", ":BufferLineCycleNext<CR>", { noremap = true })
	-- BufferLineMovePrev and BufferLineMoveNext aren't working
	-- as of 2022-11-13
	-- but tabmove is working fine
	vim.keymap.set("", "<leader>J", ":tabmove-<CR>", { noremap = true })
	vim.keymap.set("", "<leader>K", ":tabmove+<CR>", { noremap = true })

	-- user commands
	-- open a new tab, which has a copy of the current window
	vim.api.nvim_create_user_command("TS", "tab vs", {})

	local excluded_fts = {
		[const_ft.Aerial] = true,
		[const_ft.DapRepl] = true,
		[const_ft.DapuiBreakpoints] = true,
		[const_ft.DapuiConsole] = true,
		[const_ft.DapuiScopes] = true,
		[const_ft.DapuiStacks] = true,
		[const_ft.DapuiWatches] = true,
		[const_ft.NvimTree] = true,
		[const_ft.TelescopePrompt] = true,
	}

	bufferline.setup({
		options = {
			mode = "tabs",
			separator_style = "slant",
			buffer_close_icon = user_icons.ui.Close,
			offsets = build_offsets(const_ft, user_icons),
			custom_filter = function(bufnr)
				local ft = vim.bo[bufnr].filetype
				return not excluded_fts[ft]
			end,
		},
	})
end

function build_offsets(const_ft, user_icons)
	local fts = {
		const_ft.Aerial,
		const_ft.DapuiScopes,
		const_ft.DapuiWatches,
		const_ft.DapuiStacks,
		const_ft.DapuiBreakpoints,
		const_ft.NvimTree,
	}

	local ret = {}
	for _, ft in ipairs(fts) do
		table.insert(ret, {
			filetype = ft,
			highlight = "BufferlineGroupSeparator",
			separator = user_icons.ui.VertSeparator,
		})
	end
	return ret
end

return M
