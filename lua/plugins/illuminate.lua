-- @module plugins.illuminate
local M = {}

function M.config()
	local illuminate = require("illuminate")

	local const_ft = require("const.filetypes")

	illuminate.configure({
		filetypes_denylist = {
			const_ft.Aerial,
			const_ft.Dbee,
			const_ft.Help,
			const_ft.NvimTree,
		},
	})
end

return M
