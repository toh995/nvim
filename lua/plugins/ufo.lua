-- @module plugins.ufo
local M = {}

function M.config()
	local ufo = require("ufo")

	local constFt = require("const.filetypes")
	local user_icons = require("const.user_icons")

	vim.o.foldcolumn = "1" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true
	vim.opt.fillchars:append({
		eob = " ",
		fold = " ",
		foldopen = user_icons.chevron.Down,
		foldsep = " ",
		foldclose = user_icons.chevron.Right,
	})

	-- Disable folds on certain filetypes
	local disabled_fts = {
		[constFt.Aerial] = true,
		[constFt.NvimTree] = true,
	}
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(opts)
			local ft = vim.bo[opts.buf].filetype
			local is_disabled = disabled_fts[ft]
			if is_disabled then
				vim.opt_local.foldenable = false
			end
		end,
	})

	-- Keymaps
	vim.keymap.set("n", "<leader>h", "zc") -- close fold
	vim.keymap.set("n", "<leader>l", "zo") -- open fold
	vim.keymap.set("n", "<leader>H", ufo.closeAllFolds)
	vim.keymap.set("n", "<leader>L", ufo.openAllFolds)

	-- Set up UFO
	-- See https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1512772530
	---@diagnostic disable-next-line: missing-fields
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
