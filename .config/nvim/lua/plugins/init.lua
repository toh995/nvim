-- @module plugins
local M = {}

function M.configure()
	-- bootstrap lazy.nvim
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	-- set up packages
	require("lazy").setup({
		-- LSP
		{
			"neovim/nvim-lspconfig",
			config = require("plugins.lsp").config,
			dependencies = {
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },
				{
					"creativenull/efmls-configs-nvim",
					version = "v1.x.x",
				},
				-- Telescope (for LSP go-tos)
				{ "nvim-telescope/telescope.nvim" },
				-- autocomplete
				{ "hrsh7th/nvim-cmp" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-nvim-lsp-signature-help" },
				{ "hrsh7th/cmp-path" },
				-- icons for autocomplete
				{ "onsails/lspkind.nvim" },
				-- snippets
				{ "L3MON4D3/LuaSnip" },
				{ "saadparwaiz1/cmp_luasnip" },
				-- custom lua stuff
				{ "folke/neodev.nvim" },
				-- custom tsserver
				{
					"pmizio/typescript-tools.nvim",
					dependencies = { "nvim-lua/plenary.nvim" },
				},
			},
		},

		-- Improved UI for `vim.input` and `vim.select`
		{ "stevearc/dressing.nvim" },

		-- tabs
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require("plugins.bufferline").config,
		},

		-- Status line
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require("plugins.lualine").config,
		},

		-- syntax highlighting
		{
			"nvim-treesitter/nvim-treesitter",
			build = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
			config = require("plugins.nvim_treesitter").config,
		},
		{ "nvim-treesitter/nvim-treesitter-context" },

		-- file explorer
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require("plugins.nvim_tree").config,
		},

		-- fuzzy finder
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			branch = "0.1.x",
			config = require("plugins.telescope").config,
		},

		-- test runner
		{
			"vim-test/vim-test",
			dependencies = { "preservim/vimux" },
			config = require("plugins.vim_test").config,
		},

		-- Markdown preview
		{
			"iamcco/markdown-preview.nvim",
			build = "cd app && yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			ft = { "markdown" },
			config = require("plugins.markdown_preview").config,
		},

		-- Better escape
		{
			"max397574/better-escape.nvim",
			config = require("plugins.better_escape").config,
		},

		-- comment
		{
			"numToStr/Comment.nvim",
			config = require("plugins.comment").config,
		},

		-- vim surround
		{ "tpope/vim-surround" },

		-- cutlass
		{
			"gbprod/cutlass.nvim",
			config = require("plugins.cutlass").config,
		},

		-- autopairs
		{
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup({})
			end,
		},

		-- auto-close HTML tags
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		},

		-- vim-tmux
		{ "christoomey/vim-tmux-navigator" },

		-- show git blame inline
		{
			"f-person/git-blame.nvim",
			config = require("plugins.git_blame").config,
		},

		-- colorized git status in the signs column
		{
			"lewis6991/gitsigns.nvim",
			-- TODO: Move these back into separate files??
			config = function()
				require("gitsigns").setup()
			end,
		},

		-- Color schemes
		-- { "lunarvim/Onedarker.nvim" },
		{
			"Mofiqul/vscode.nvim",
			config = function()
				local vscode = require("vscode")
				vscode.setup({})
				vscode.load()
			end,
		},

		-- editor config
		{ "editorconfig/editorconfig-vim" },
	})
end

return M
