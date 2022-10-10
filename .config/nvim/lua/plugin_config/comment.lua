-- @module plugin_config.comment
local comment = {}

local c = require("Comment")
local ft = require('Comment.ft')

function comment.configure()
	c.setup()

	-- set a custom comment string for handlebars
	ft.set("handlebars", { "{{!--%s--}}", "{{!--%s--}}" })
end

return comment
