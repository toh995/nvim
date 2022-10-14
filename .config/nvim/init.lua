local plugin_config = require("plugin_config")

-------------
-- OPTIONS --
-------------
-- map the leader key
vim.g.mapleader = " "

-- make all copy/paste operations use the system clipboard
vim.opt.clipboard = "unnamedplus"

-- ignore case when searching
vim.opt.ignorecase = true

-- mouse support
vim.opt.mouse = "a"

-- show line numbers
vim.opt.number = true

-- always open vertical splits on the right side
vim.opt.splitright = true

-- set the display width for tab characters
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

------------------
-- AUTOCOMMANDS --
------------------
-- automatically detect file changes
vim.opt.updatetime = 500
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	pattern = { "*" },
	command = "checktime",
})

-- disable the auto-insertion of comments
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*" },
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

------------------------
-- KEYBOARD SHORTCUTS --
------------------------
-- set the keyboard shortcut ctrl+a to select all
vim.keymap.set("", "<C-a>", "<esc>ggVG<CR>", { noremap = true })

-- re-map keys to navigate through splits
vim.keymap.set("", "<C-J>", "<C-W><C-J>", { noremap = true })
vim.keymap.set("", "<C-K>", "<C-W><C-K>", { noremap = true })
vim.keymap.set("", "<C-L>", "<C-W><C-L>", { noremap = true })
vim.keymap.set("", "<C-H>", "<C-W><C-H>", { noremap = true })

-------------
-- PLUGINS --
-------------
plugin_config.configure()

-- TODO:
-- "highlight the currently active window
-- highlight StatusLineNC cterm=bold ctermfg=white ctermbg=darkgray

-- "go-to file (for AB specifically)
-- set path+=$PWD
-- set suffixesadd+=.js,.ts
