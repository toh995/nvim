-- @module plugins.blink
local M = {}

function M.config()
	local blink = require("blink.cmp")
	local const_ft = require("const.filetypes")

	-- @fixme:
	--  - highlight groups for blink.cmp
	--  - cmp-nvim-lsp-signature-help
	--  - dap
	--  - luasnip
	blink.setup({
		keymap = {
			preset = "super-tab",
		},
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = require("const.user_icons").kinds,
		},
		-- @fixme: import "DressingInput" from FileType const file
		enabled = function() return not vim.tbl_contains({ const_ft.DressingInput }, vim.bo.filetype) end,
		signature = { enabled = true, window = { border = "rounded" } },
		completion = {
			documentation = { auto_show = true, window = { border = "rounded" } },
			menu = {
				border = "rounded",
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								end
								return icon .. ctx.icon_gap
							end,
						},
					},
				},
			},
			accept = { auto_brackets = { enabled = true } },
			ghost_text = { enabled = false },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	})
end

return M
