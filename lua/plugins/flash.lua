-- @module plugins.flash
local M = {}

function M.config()
	local flash = require("flash")

	vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })

	flash.setup({
		modes = {
			char = { enabled = false },
			search = { enabled = false },
		},
	})
end

return M
