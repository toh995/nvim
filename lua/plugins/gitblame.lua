-- @module plugins.gitblame
local M = {}

function M.config()
	local gitblame = require("gitblame")

	-- disable gitblame on startup
	-- vim.g.gitblame_enabled = 0

	-- configure date format
	-- reference: https://github.com/f-person/git-blame.nvim#date-format
	vim.g.gitblame_date_format = "%a %Y-%m-%d %I:%M %p"

	-- keybindings
	-- vim.keymap.set("", "<leader>gb", function() vim.api.nvim_command("GitBlameToggle") end, { noremap = true })
	vim.keymap.set("", "<leader>gbu", ":GitBlameOpenCommitURL<CR>", { noremap = true })
	vim.keymap.set("", "<leader>gu", ":GitBlameOpenFileURL<CR>", { noremap = true })
end

return M
