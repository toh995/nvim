-- @module plugins.cmp
local M = {}

local cfg

function M.config()
	require("catppuccin").setup(cfg)
	vim.cmd("colorscheme catppuccin-mocha")
end

cfg = {
	flavour = "mocha",

	styles = {
		keywords = { "italic" },
		operators = { "italic" },
		types = { "italic" },
	},

	custom_highlights = function(colors)
		return {
			-- Add a background highlight for `` in markdown
			["@markup.raw.markdown_inline"] = { bg = colors.surface1, fg = colors.teal },
			-- Ensure builtin types behave similarly to other types
			["@type.builtin"] = { link = "Type" },
		}
	end,

	integrations = {
		treesitter_context = true,
	},
}

return M
