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
				-- custom lua stuff
				{ "folke/neodev.nvim" },
				-- custom tsserver
				{
					"pmizio/typescript-tools.nvim",
					dependencies = { "nvim-lua/plenary.nvim" },
				},
			},
		},

		-- Auto-complete
		{
			"hrsh7th/nvim-cmp",
			config = require("plugins.cmp").config,
			dependencies = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-path",
				-- snippets
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				-- icons for autocomplete
				"nvim-tree/nvim-web-devicons",
			},
		},

		-- treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
				"RRethy/nvim-treesitter-endwise",
				"windwp/nvim-ts-autotag",
			},
			config = require("plugins.nvim_treesitter").config,
		},
		{ "nvim-treesitter/nvim-treesitter-context" },

		-- {
		-- 	"SmiteshP/nvim-navic",
		-- 	dependencies = { "neovim/nvim-lspconfig" },
		-- },

		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			opts = {
				scope = {
					show_start = false,
					show_end = false,
				},
			},
		},

		{
			"stevearc/aerial.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				-- TODO: what are devicons used for...?
				"nvim-tree/nvim-web-devicons",
				-- "onsails/lspkind.nvim",
			},
			config = require("plugins.aerial").config,
		},

		-- tabs
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require("plugins.bufferline").config,
		},

		-- file explorer
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require("plugins.nvim_tree").config,
		},
		-- auto-notify LSP server, when a rename happens
		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-tree.lua",
			},
			opts = {
				timeout_ms = 60000,
			},
		},

		-- fuzzy finder
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-tree.lua",
			},
			branch = "0.1.x",
			config = require("plugins.telescope").config,
		},

		-- Status line
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
				"linrongbin16/lsp-progress.nvim",
			},
			config = require("plugins.lualine").config,
		},

		-- Status column
		{
			"luukvbaal/statuscol.nvim",
			config = require("plugins.statuscol").config,
		},

		-- Improved UI for folds
		{
			"kevinhwang91/nvim-ufo",
			dependencies = { "kevinhwang91/promise-async" },
			config = require("plugins.ufo").config,
		},

		-- Improved UI for `vim.input` and `vim.select`
		{ "stevearc/dressing.nvim" },

		-- test runner
		{
			"vim-test/vim-test",
			dependencies = { "preservim/vimux" },
			config = require("plugins.vim_test").config,
		},

		-- Markdown preview
		{
			"iamcco/markdown-preview.nvim",
			-- need to use yarn for nixOS
			build = "cd app && yarn install",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			ft = { "markdown" },
			config = require("plugins.markdown_preview").config,
		},

		-- Jump
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			config = require("plugins.flash").config,
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

		-- Auto-pairs
		{
			"LunarWatcher/auto-pairs",
			config = require("plugins.auto_pairs").config,
		},

		-- vim surround
		{ "tpope/vim-surround" },

		-- cutlass
		{
			"gbprod/cutlass.nvim",
			config = require("plugins.cutlass").config,
		},

		-- vim-tmux
		{ "christoomey/vim-tmux-navigator" },

		-- show git blame inline
		{
			"f-person/git-blame.nvim",
			config = require("plugins.gitblame").config,
		},

		-- colorized git status in the signs column
		{
			"lewis6991/gitsigns.nvim",
			config = true,
		},

		-- Color schemes
		-- { "lunarvim/Onedarker.nvim" },

		-- {
		-- 	"Mofiqul/vscode.nvim",
		-- 	config = function()
		-- 		local vscode = require("vscode")
		-- 		vscode.setup({})
		-- 		vscode.load()
		-- 	end,
		-- },

		-- Need to enable alacritty settings too
		-- {
		-- 	"letorbi/vim-colors-modern-borland",
		-- 	config = function()
		-- 		vim.cmd("color borland")
		-- 	end,
		-- },

		-- {
		-- 	"folke/tokyonight.nvim",
		-- 	lazy = false,
		-- 	priority = 1000,
		-- 	config = function()
		-- 		vim.cmd("colorscheme tokyonight-storm")
		-- 	end,
		-- },

		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				vim.cmd("colorscheme catppuccin-mocha")
			end,
		},

		-- {
		-- 	"Shatur/neovim-ayu",
		-- 	config = function()
		-- 		-- vim.cmd("colorscheme ayu-dark")
		-- 		vim.cmd("colorscheme ayu-mirage")
		-- 	end,
		-- },

		-- {
		-- 	"EdenEast/nightfox.nvim",
		-- 	config = function()
		-- 		-- vim.cmd("colorscheme nightfox")
		-- 		-- vim.cmd("colorscheme duskfox")
		-- 		vim.cmd("colorscheme nordfox")
		-- 		-- vim.cmd("colorscheme terafox")
		-- 		-- vim.cmd("colorscheme carbonfox")
		-- 		-- vim.cmd("colorscheme nightfox")
		-- 		-- vim.cmd("colorscheme nightfox")
		-- 	end,
		-- },

		-- {
		-- 	"maxmx03/FluoroMachine.nvim",
		-- 	config = function()
		-- 		require("fluoromachine").setup({
		-- 			glow = true,
		-- 			-- theme = "fluoromachine",
		-- 			theme = "retrowave",
		-- 			-- theme = "delta",
		-- 		})
		--
		-- 		vim.cmd("colorscheme fluoromachine")
		-- 	end,
		-- },

		-- {
		-- 	"ribru17/bamboo.nvim",
		-- 	config = function()
		-- 		require("bamboo").setup({
		-- 			-- style = "vlugaris",
		-- 			style = "multiplex",
		-- 		})
		-- 		vim.cmd("colorscheme bamboo")
		-- 	end,
		-- },

		-- {
		-- 	"cryptomilk/nightcity.nvim",
		-- 	config = function()
		-- 		require("nightcity").setup({
		-- 			style = "afterlife", -- The theme comes in two styles: kabuki or afterlife
		-- 		})
		-- 		vim.cmd("colorscheme nightcity")
		-- 	end,
		-- },

		-- {
		-- 	"oxfist/night-owl.nvim",
		-- 	config = function()
		-- 		-- vim.opt.background = "dark" -- default to dark or light style
		-- 		vim.cmd([[colorscheme night-owl]])
		-- 	end,
		-- },
	}, {
		ui = { border = "rounded" },
	})
end

return M
