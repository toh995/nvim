-- @module plugin_config.bufferline
local bufferline = {}

local b = require("bufferline")

function bufferline.configure()
	-- set up some keyboard shortcuts for tabs
	vim.api.nvim_create_user_command("T", "tabnew", {})
	vim.api.nvim_create_user_command("Q", "tabclose", {})

	vim.keymap.set("", "t", ":tabnew<CR>", { noremap = true })
	vim.keymap.set("", "Q", ":tabclose<CR>", { noremap = true })
	vim.keymap.set("", "J", ":tabprevious<CR>", { noremap = true })
	vim.keymap.set("", "K", ":tabnext<CR>", { noremap = true })

	b.setup({
		options = {
			mode = "tabs",
			separator_style = "padded_slant",
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

return bufferline
