-- @module plugin_config.git_blame
local git_blame = {}

local gb = require("gitblame")

function git_blame.configure()
	-- disable gitblame on startup
	-- vim.g.gitblame_enabled = 0

	-- keybindings
	-- vim.keymap.set("", "<leader>gb", function() vim.api.nvim_command("GitBlameToggle") end, { noremap = true })
	vim.keymap.set("", "<leader>gbu", gb.open_commit_url, { noremap = true })
end

return git_blame
