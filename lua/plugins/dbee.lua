-- @module plugins.dbee
local M = {}

function M.config()
	local const_ft = require("const.filetypes")
	local dbee = require("dbee")
	local WinOptManager = require("util.vim.win_opt_manager")

	dbee.setup({
		drawer = {
			disable_help = true,
			mappings = {
				{ key = "l", mode = "n", action = "toggle" },
				{ key = "h", mode = "n", action = "collapse" },
				{ key = "<CR>", mode = "n", action = "action_1" },
				{ key = "e", mode = "n", action = "action_2" },
				{ key = "r", mode = "n", action = "action_2" },
				{ key = "d", mode = "n", action = "action_3" },
				{ key = "R", mode = "n", action = "refresh" },
				-- mappings for menu popups:
				{ key = "<CR>", mode = "n", action = "menu_confirm" },
				{ key = "y", mode = "n", action = "menu_yank" },
				{ key = "<Esc>", mode = "n", action = "menu_close" },
				{ key = "q", mode = "n", action = "menu_close" },
			},
		},
	})

	vim.api.nvim_create_user_command("DB", function()
		dbee.open()
		local win_opt_mgr = WinOptManager:new()
		win_opt_mgr:set(const_ft.Dbee, "foldenable", false)
		win_opt_mgr:append(const_ft.Dbee, "winhighlight", "StatusLine:NormalBg,StatusLineNC:Normal")
		win_opt_mgr:append(const_ft.Dbee, "fillchars", "stl:─,stlnc:─")
	end, {})
end

return M
