-- @module plugins.comment
local M = {}

function M.config()
	local comment = require("Comment")
	local ft = require("Comment.ft")

	comment.setup()

	-- override the default gitconfig comment string
	-- (the default is also correct, this is just personal preference)
	ft.gitconfig = { "# %s" }
end

return M
