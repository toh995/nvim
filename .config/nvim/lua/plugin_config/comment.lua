-- @module plugin_config.comment
local comment = {}

local c = require("Comment")

function comment.configure()
	c.setup()
end

return comment
