-- @module plugins.nvim_treesitter
local M = {}

function M.config()
	local autotags = require("nvim-ts-autotag")
	local textobjects = require("nvim-treesitter-textobjects")
	local textobjects_select = require("nvim-treesitter-textobjects.select")
	local treesitter = require("nvim-treesitter")

	-- Initial setup
	treesitter.setup({
		install_dir = vim.fn.stdpath("data") .. "/site",
	})

	-- Auto-complete HTML tags
	autotags.setup()

	-- Syntax Highlighting
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local lang = vim.treesitter.language.get_lang(args.match)
			if lang and vim.treesitter.language.add(lang) then
				vim.treesitter.start(args.buf)
			end
		end,
	})

	-- Incremental block selection
	vim.keymap.set("n", "gnn", function() vim.treesitter.select("parent") end, { desc = "Init selection" })
	vim.keymap.set("x", "K", function() vim.treesitter.select("parent") end, { desc = "Increment node" })
	vim.keymap.set("x", "J", function() vim.treesitter.select("child") end, { desc = "Decrement node" })

	-- Textobjects
	textobjects.setup({ select = { lookahead = true } })
	local textobject_keymap = {
		["ab"] = "@block.outer",
		["ib"] = "@block.inner",
		["af"] = "@function.outer",
		["if"] = "@function.inner",
	}
	for lhs, query in pairs(textobject_keymap) do
		vim.keymap.set(
			{ "x", "o" },
			lhs,
			function() textobjects_select.select_textobject(query, "textobjects") end,
			{ desc = "Select " .. query }
		)
	end

	-- Language parser install
	treesitter.install({
		"bash",
		"clojure",
		"csv",
		"dockerfile",
		"git_config",
		"gitcommit",
		"gitignore",
		"go",
		"haskell",
		"html",
		"json",
		"just",
		"latex",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"nix",
		"python",
		"toml",
		"vim",
		"vimdoc",
		"yaml",
	})
end

return M
