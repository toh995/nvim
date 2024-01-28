-- @module plugins.aerial
local M = {}

function M.config()
	local aerial = require("aerial")
	local data = require("aerial.data")

	local user_icons = require("const.user_icons")

	-- Keymapping to toggle the aerial window
	vim.keymap.set("", "<leader>a", function()
		vim.cmd("AerialToggle")
	end, { noremap = true })

	-- config/setup
	aerial.setup({
		backends = {
			["_"] = { "lsp", "treesitter" },
			python = { "treesitter" },
		},
		autojump = true,
		layout = {
			default_direction = "left",
			-- placement = "edge",
			max_width = 0.99,
			width = nil,
			min_width = nil,
		},
		filter_kind = false, -- display all symbols

		icons = user_icons.kinds,

		manage_folds = false,
		link_folds_to_tree = false,
		link_tree_to_folds = false,

		highlight_on_hover = true,
		highlight_on_jump = false,

		treesitter = { update_delay = 200 },
		markdown = { update_delay = 200 },
		man = { update_delay = 200 },

		lsp = {
			diagnostics_trigger_update = false,
			update_delay = 200,
			priority = {
				efm = -1,
				ember = -1,
				eslint = -1,
				glint = -1,
				golangci_lint_ls = -1,
				neodev = -1,
				ruff_lsp = -1,
			},
		},

		keymaps = {
			["H"] = "actions.tree_close_all",
			["L"] = "actions.tree_open_all",
			["h"] = "actions.tree_close",
			["l"] = {
				callback = function()
					local index = vim.api.nvim_win_get_cursor(0)[1]
					local bufdata = data.get_or_create(0)
					local item = bufdata:item(index)

					if not item then
						return
					end

					if bufdata:is_collapsed(item) then
						aerial.tree_open()
					else
						aerial.select()
					end
				end,
			},
			["<C-v>"] = "actions.jump_vsplit",
			["<C-t>"] = {
				callback = function()
					aerial.select({ split = "tab vs" })
				end,
			},
		},
	})
end

return M
