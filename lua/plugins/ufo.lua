-- @module plugins.ufo
local M = {}

function M.config()
	local ufo = require("ufo")
	local icons = require("const.user_icons")

	vim.o.foldcolumn = "1" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true
	vim.opt.fillchars:append({
		eob = " ",
		fold = " ",
		foldopen = icons.chevron.Down,
		foldsep = " ",
		foldclose = icons.chevron.Right,
	})

	vim.keymap.set("n", "<leader>h", "zc") -- close fold
	vim.keymap.set("n", "<leader>l", "zo") -- open fold
	vim.keymap.set("n", "<leader>H", ufo.closeAllFolds)
	vim.keymap.set("n", "<leader>L", ufo.openAllFolds)

	-- See https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1512772530
	ufo.setup({
		-- Disable highlights, when opening a fold
		open_fold_hl_timeout = 0,

		-- Assign a main provider + fallback
		provider_selector = function(_, filetype)
			return filetype == "haskell" and { "lsp", "indent" } or { "treesitter", "indent" }
		end,
	})
end

return M
