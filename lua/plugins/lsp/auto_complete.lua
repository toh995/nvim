-- @module plugins.lsp.auto_complete
local M = {}

function M.configure()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local luasnip = require("luasnip")

	local foo = lspkind.cmp_format({
		-- preset = "codicons",
		mode = "symbol",
		maxwidth = 50,
		ellipsis_char = "...",
		menu = {
			buffer = "(Buffer)",
			nvim_lsp = "(LSP)",
			luasnip = "(LuaSnip)",
			nvim_lua = "(Lua)",
			latex_symbols = "(Latex)",
		},
		symbol_map = {
			Array = "",
			Boolean = "󰨙",
			-- Boolean = "",
			Class = "",
			Codeium = "󰘦 ",
			Color = "",
			Control = "",
			Collapsed = "",
			Constant = "",
			Constructor = "",
			Copilot = "",
			Enum = "",
			EnumMember = "",
			Event = "",
			Field = "",
			File = "",
			Folder = "󰉋",
			Function = "",
			-- Function = "󰊕",
			Interface = "",
			Key = "",
			Keyword = "",
			Method = "",
			Module = "",
			Namespace = "",
			Null = "󰟢",
			Number = "",
			Object = "",
			Operator = "",
			Package = "",
			Property = "",
			Reference = "",
			-- Snippet = "",
			Snippet = "",
			String = "",
			-- String = "",
			-- String = "",
			Struct = "",
			Text = "",
			TypeParameter = "",
			Unit = "",
			Value = "",
			Variable = "",
		},
	})

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
			fields = { "kind", "abbr", "menu" },
			-- icons in the auto-complete menu
			format = function(entry, vim_item)
				foo(entry, vim_item)
				if vim.tbl_contains({ "path" }, entry.source.name) then
					local icon, hl_group = require("nvim-web-djevicons").get_icon(entry:get_completion_item().label)
					if icon then
						vim_item.kind = icon
						vim_item.kind_hl_group = hl_group
					end
				end
				return vim_item
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
	})
end

return M
