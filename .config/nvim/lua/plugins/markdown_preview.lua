-- @module plugins.markdown_preview
local M = {}

function M.config()
	vim.api.nvim_create_user_command("MP", "MarkdownPreview", {})
	-- vim.keymap.set("", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true })
end

return M
