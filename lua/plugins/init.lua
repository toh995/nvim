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
				"rcarriga/cmp-dap",
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

		-- Format on save
		{
			"stevearc/conform.nvim",
			opts = {},
			config = require("plugins.conform").config,
		},

		-- DAP
		{
			"mfussenegger/nvim-dap",
			config = require("plugins.dap").config,
			dependencies = {
				"rcarriga/nvim-dap-ui",
				"nvim-neotest/nvim-nio",
				"leoluz/nvim-dap-go",
				-- adapter for nvim lua plugins
				"jbyuki/one-small-step-for-vimkind",
				-- render ANSI Escape Sequences
				{
					"m00qek/baleia.nvim",
					version = "v1.4.0",
				},
			},
		},

		-- Treesitter
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
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {},
		},

		-- Indent blankline
		{
			"lukas-reineke/indent-blankline.nvim",
			config = require("plugins.indent_blankline").config,
		},

		-- Illuminate current word
		{
			"RRethy/vim-illuminate",
			config = require("plugins.illuminate").config,
		},

		-- Code outline
		{
			"stevearc/aerial.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			config = require("plugins.aerial").config,
		},

		-- Tabs
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require("plugins.bufferline").config,
		},

		-- File explorer
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = require("plugins.nvim_tree").config,
		},
		-- Auto-notify LSP server, when a rename happens
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

		-- Fuzzy finder
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				-- auto-open files in nvim-tree
				"nvim-tree/nvim-tree.lua",
				-- aerial extension
				"stevearc/aerial.nvim",
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

		-- Colorized git status in the signs column
		{
			"lewis6991/gitsigns.nvim",
			config = true,
		},

		-- Improved UI for folds
		{
			"kevinhwang91/nvim-ufo",
			dependencies = { "kevinhwang91/promise-async" },
			config = require("plugins.ufo").config,
		},

		-- Improved UI for `vim.input` and `vim.select`
		{ "stevearc/dressing.nvim" },

		-- Test runner
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
			init = function() vim.g.mkdp_filetypes = { "markdown" } end,
			ft = { "markdown" },
			config = require("plugins.markdown_preview").config,
		},

		-- Jump
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			config = require("plugins.flash").config,
		},

		-- Smooth scroll
		{
			"karb94/neoscroll.nvim",
			config = function()
				local neoscroll = require("neoscroll")
				neoscroll.setup({
					easing = "quintic",
					hide_cursor = false,
				})
				local duration = 1
				-- vim.keymap.set("", "<C-d>", function() neoscroll.ctrl_d({ duration = duration }) end)
				-- vim.keymap.set("", "<C-u>", function() neoscroll.ctrl_u({ duration = duration }) end)
				vim.keymap.set("", "D", function() neoscroll.scroll(0.2, { duration = duration }) end)
				vim.keymap.set("", "U", function() neoscroll.scroll(-0.2, { duration = duration }) end)
				vim.keymap.set("", "<PageDown>", function() neoscroll.ctrl_f({ duration = duration }) end)
				vim.keymap.set("", "<PageUp>", function() neoscroll.ctrl_b({ duration = duration }) end)
			end,
		},
		-- Better escape
		{
			"max397574/better-escape.nvim",
			config = require("plugins.better_escape").config,
		},

		-- Better word navigation
		{
			"chrisgrieser/nvim-spider",
			lazy = true,
			keys = {
				{
					"w",
					function() require("spider").motion("w") end,
					mode = { "n", "o", "x" },
				},
				{
					"e",
					function() require("spider").motion("e") end,
					mode = { "n", "o", "x" },
				},
				{
					"b",
					function() require("spider").motion("b") end,
					mode = { "n", "o", "x" },
				},
			},
		},

		-- Comment
		{
			"numToStr/Comment.nvim",
			config = require("plugins.comment").config,
		},

		-- Auto-pairs
		{
			"windwp/nvim-autopairs",
			config = true,
		},

		-- Vim surround
		{ "tpope/vim-surround" },

		-- Cutlass
		{
			"gbprod/cutlass.nvim",
			config = require("plugins.cutlass").config,
		},

		-- Vim-tmux
		{ "christoomey/vim-tmux-navigator" },

		-- Show git blame inline
		{
			"f-person/git-blame.nvim",
			config = require("plugins.gitblame").config,
		},

		-- Color scheme
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = require("plugins.catppuccin").config,
		},

		-- DB client
		{
			"kndndrj/nvim-dbee",
			dependencies = { "MunifTanjim/nui.nvim" },
			build = function() require("dbee").install() end,
			config = require("plugins.dbee").config,
		},
	}, {
		ui = { border = "rounded" },
	})
end

return M
