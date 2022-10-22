-- @module plugin_config.bufferline
local bufferline = {}

local b = require("bufferline")

function bufferline.configure()
	-- set up some keyboard shortcuts for tabs
	vim.keymap.set("", "t", ":tabnew<CR>", { noremap = true })
	vim.keymap.set("", "T", "<C-W>T", { noremap = true })
	vim.keymap.set("", "Q", ":tabclose<CR>", { noremap = true })
	vim.keymap.set("", "J", ":BufferLineCyclePrev<CR>", { noremap = true })
	vim.keymap.set("", "K", ":BufferLineCycleNext<CR>", { noremap = true })
	vim.keymap.set("", "<leader>J", ":BufferLineMovePrev<CR>", { noremap = true })
	vim.keymap.set("", "<leader>K", ":BufferLineMoveNext<CR>", { noremap = true })

	-- user commands
	vim.api.nvim_create_user_command("TVS", "tab vs", {})

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
