-- @module plugin_config.comment
local comment = {}

function comment.config()
	local c = require("Comment")
	local ft = require("Comment.ft")

	c.setup()

	-- override the default gitconfig comment string
	-- (the default is also correct, this is just personal preference)
	ft.gitconfig = { "# %s" }
end

return comment
