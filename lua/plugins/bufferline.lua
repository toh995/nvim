-- @module plugins.bufferline
local M = {}

function M.config()
	local bufferline = require("bufferline")

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
	vim.api.nvim_create_user_command("TVS", "tab vs", {})

	bufferline.setup({
		options = {
			mode = "tabs",
			separator_style = "padded_slant",
			buffer_close_icon = "x",
			offsets = {
				{
					filetype = "NvimTree",
					text = "",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	})
end

return M
