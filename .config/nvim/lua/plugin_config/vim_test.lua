-- @module plugin_config.vim_test
local M = {}

function M.config()
	-- setup
	vim.g["test#strategy"] = "vimux"
	vim.g["test#javascript#mocha#executable"] = "mocha"

	-- keybindings
	vim.keymap.set("", "<leader>t", ":TestNearest<CR>", { noremap = true })
	vim.keymap.set("", "<leader>T", ":TestFile<CR>", { noremap = true })
end

return M
