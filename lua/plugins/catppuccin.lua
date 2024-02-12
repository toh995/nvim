-- @module plugins.cmp
local M = {}

function M.config()
	local catppuccin = require("catppuccin")
	local const_ft = require("const.filetypes")

	-- Catppuccin setup
	catppuccin.setup({
		flavour = "mocha",
		styles = {
			keywords = { "italic" },
			operators = { "italic" },
			types = { "italic" },
		},
		integrations = {
			treesitter_context = true,
		},
		custom_highlights = function(colors)
			return {
				-- Add a background highlight for `` in markdown
				["@markup.raw.markdown_inline"] = { bg = colors.surface1, fg = colors.teal },
				-- Ensure builtin types behave similarly to other types
				["@type.builtin"] = { link = "Type" },
				-- Utility
				["NormalBg"] = { bg = colors.base },
				-- Define "dark" windows
				["DarkNormal"] = { bg = colors.mantle, fg = colors.text },
				["DarkStatusLine"] = { bg = colors.mantle, fg = colors.text },
				["DarkWinSeparator"] = { bg = colors.mantle, fg = colors.crust },
				-- Set NvimTree to "dark"
				["NvimTreeNormal"] = { link = "DarkNormal" },
				["NvimTreeStatusLine"] = { link = "DarkStatusLine" },
				["NvimTreeWinSeparator"] = { link = "DarkWinSeparator" },
			}
		end,
	})

	-- Set the color scheme
	vim.cmd("colorscheme catppuccin-mocha")

	-- Set dark highlights
	local dark_fts = {
		[const_ft.Aerial] = true,
		[const_ft.Help] = true,
	}
	local augroup = vim.api.nvim_create_augroup("catppuccin_custom", { clear = true })
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = augroup,
		callback = function(opts)
			local ft = opts.match
			if dark_fts[ft] then
				vim.opt_local.winhighlight:append({
					["Normal"] = "DarkNormal",
					["StatusLine"] = "DarkStatusLine",
					["WinSeparator"] = "DarkWinSeparator",
				})
			end
		end,
	})
end

return M
