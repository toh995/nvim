-- @module plugins.lsp.auto_complete
local M = {}

function M.configure()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local luasnip = require("luasnip")

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
		formatting = {
			-- icons in the auto-complete menu
			format = lspkind.cmp_format({
				mode = "symbol",
				maxwidth = 50,
				ellipsis_char = "...",
				menu = {
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					luasnip = "[LuaSnip]",
					nvim_lua = "[Lua]",
					latex_symbols = "[Latex]",
				},
			}),
		},
	})
end

return M
