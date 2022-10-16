-- @module plugin_config.color_scheme
local color_schemes = {}

local vscode = require("vscode")

function color_schemes.configure()
	vscode.setup({})
end

return color_schemes
