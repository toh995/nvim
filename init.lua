local user_icons = require("const.user_icons")

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
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- ensure that status-line and other things are aligned
-- see https://www.reddit.com/r/neovim/comments/ra7cbn/why_barbar_and_lualine_doesnt_align_with_nvimtree/
vim.opt.fillchars:append({ vert = user_icons.ui.VertSeparator })

-- ensure colors are displayed properly
vim.opt.termguicolors = true

------------------
-- AUTOCOMMANDS --
------------------
-- automatically detect file changes
vim.opt.updatetime = 250
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	pattern = { "*" },
	command = "checktime",
})

-- disable the auto-insertion of comments
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*" },
	callback = function() vim.opt_local.formatoptions:remove({ "c", "r", "o" }) end,
})

------------------------
-- KEYBOARD SHORTCUTS --
------------------------
-- use semicolon to ender cmdline mode
vim.keymap.set("", ";", ":", { noremap = true })

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
require("plugins").configure()
