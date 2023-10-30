-- @module plugins.lsp.auto_complete
local M = {}

function M.configure()
	local cmp = require("cmp")
	local devicons = require("nvim-web-devicons")
	local luasnip = require("luasnip")

	local user_icons = require("const.user_icons")

	local MENU = {
		buffer = "(Buffer)",
		latex_symbols = "(Latex)",
		luasnip = "(LuaSnip)",
		nvim_lsp = "(LSP)",
		nvim_lua = "(Lua)",
	}

	---@diagnostic disable-next-line: missing-fields
	cmp.setup({
		sources = {
			{ name = "buffer" },
			{ name = "luasnip" },
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "path" },
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, { "i", "s" }),
		}),

		-- Add rounded borders to the auto-complete menu
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},

		-- Format each line-item in the auto-complete menu
		---@diagnostic disable-next-line: missing-fields
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				-- Add menu item
				vim_item.menu = MENU[entry.source.name]

				-- Truncate abbreviation, if needed
				local label = vim_item.abbr
				if label then
					local truncated_label = string.sub(label, 1, 50)
					if truncated_label ~= label then
						vim_item.abbr = truncated_label .. "..."
					end
				end

				-- Convert kind text to custom icon
				if vim_item.kind then
					vim_item.kind = user_icons.kinds[vim_item.kind]
				end

				-- Add devicons, as needed
				if entry.source.name == "path" then
					local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
					if icon then
						vim_item.kind = icon
						vim_item.kind_hl_group = hl_group
					end
				end

				return vim_item
			end,
		},
	})
end

return M
