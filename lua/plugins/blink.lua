-- @module plugins.blink
local M = {}

function M.config()
	local blink = require("blink.cmp")
	local const_ft = require("const.filetypes")

	blink.setup({
		keymap = {
			preset = "super-tab",
		},
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = require("const.user_icons").kinds,
		},
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
		fuzzy = { implementation = "prefer_rust_with_warning" },
		sources = {
			default = {
				"buffer",
				"lsp",
				"path",
				"snippets",
				-- custom sources
				"lazydev",
			},
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
		},
	})
end

return M
