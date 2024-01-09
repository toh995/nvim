-- @module plugins.aerial
local M = {}

function M.config()
	local aerial = require("aerial")
	local data = require("aerial.data")

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

		icons = require("const.user_icons").kinds,

		-- post_parse_symbol = function(bufnr, item, ctx)
		-- 	-- vim.notify(vim.inspect(item))
		-- 	--
		-- 	if
		-- 		item.kind == "Array"
		-- 		or item.kind == "Constructor"
		-- 		or item.kind == "Function"
		-- 		or item.kind == "Method"
		-- 	then
		-- 		if item.children and #item.children > 0 then
		-- 			item.kind = item.kind .. "Branch"
		-- 		end
		-- 	end
		-- 	return true
		-- end,
		--
		-- get_highlight = function(symbol, is_icon, is_collapsed)
		-- 	symbol = vim.deepcopy(symbol)
		-- 	symbol.kind = symbol.kind:gsub("Branch", "")
		--
		-- 	-- If the symbol has a non-public scope, use that as the highlight group (e.g. AerialPrivate)
		-- 	if symbol.scope and not is_icon and symbol.scope ~= "public" then
		-- 		return string.format("Aerial%s", symbol.scope:gsub("^%l", string.upper))
		-- 	end
		--
		-- 	return string.format("Aerial%s%s", symbol.kind, is_icon and "Icon" or "")
		--
		-- 	-- return require("aerial.highlight").get_highlight(symbol, is_icon, is_collapsed)
		-- end,
		--
		-- -- post_add_all_symbols = function(bufnr, items, ctx)
		-- -- 	vim.notify(vim.inspect(items))
		-- -- 	return items
		-- -- end,
		--
		-- icons = {
		-- 	Array = "  ",
		-- 	ArrayBranch = " ",
		-- 	ArrayBranchCollapsed = " ",
		-- 	ArrayCollapsed = " ",
		-- 	Constructor = "  ",
		-- 	ConstructorBranch = " ",
		-- 	ConstructorBranchCollapsed = " ",
		-- 	ConstructorCollapsed = " ",
		-- 	Function = "  ",
		-- 	FunctionBranch = " ",
		-- 	FunctionBranchCollapsed = " ",
		-- 	FunctionCollapsed = " ",
		-- 	Method = "  ",
		-- 	MethodBranch = " ",
		-- 	MethodBranchCollapsed = " ",
		-- 	MethodCollapsed = " ",
		-- },
	})
end

return M
