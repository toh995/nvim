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
				{ "saghen/blink.cmp" },
				-- Telescope (for LSP go-tos)
				{ "nvim-telescope/telescope.nvim" },
				-- custom tsserver
				{
					"pmizio/typescript-tools.nvim",
					dependencies = { "nvim-lua/plenary.nvim" },
				},
				{
					-- Coq / Rocq LSP client (goal panel, info panel, proof navigation, etc.)
					"tomtomjhj/coq-lsp.nvim",
					-- Coq syntax highlighting + ftdetect.
					dependencies = { "jlapolla/vim-coq-plugin" },
				},
			},
		},
		-- Custom Lua LSP config
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		-- Lean
		{
			"Julian/lean.nvim",
			event = { "BufReadPre *.lean", "BufNewFile *.lean" },
			dependencies = { "nvim-telescope/telescope.nvim" },
			-- init = function()
			-- 	vim.g.lean_config = { mappings = true }
			-- end,
		},

		-- Auto-complete
		{
			"saghen/blink.cmp",
			dependencies = {
				"rafamadriz/friendly-snippets",
				"nvim-tree/nvim-web-devicons",
				"folke/lazydev.nvim", -- for lazydev completions
			},
			version = "1.*",
			config = require("plugins.blink").config,
			-- opts_extend = { "sources.default" },
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
				"mfussenegger/nvim-dap-python",
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
		{
			"stevearc/oil.nvim",
			---@type oil.SetupOpts
			opts = {
				default_file_explorer = false,
			},
			dependencies = { "nvim-tree/nvim-web-devicons" },
			-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
			lazy = false,
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
		-- {
		-- 	"MeanderingProgrammer/render-markdown.nvim",
		-- 	dependencies = {
		-- 		"nvim-treesitter/nvim-treesitter",
		-- 		"nvim-tree/nvim-web-devicons",
		-- 	},
		-- 	config = function()
		-- 		render_markdown = require("render-markdown")
		-- 		render_markdown.setup({
		-- 			enabled = false,
		-- 			completions = { blink = { enabled = true } },
		-- 		})
		-- 		vim.keymap.set("", "<leader>mp", ":RenderMarkdown buf_toggle<CR>", { noremap = true })
		-- 	end,
		-- },
		{
			"OXY2DEV/markview.nvim",
			lazy = false,
			-- For `nvim-treesitter`
			priority = 49,
			-- For blink.cmp's completion source
			dependencies = {
				"saghen/blink.cmp",
			},
			config = function()
				local markview = require("markview")
				markview.setup({
					preview = {
						enable = false,
					},
					markdown = {
						headings = {
							shift_width = 0,
						},
					},
				})
				vim.keymap.set("", "<leader>mp", ":Markview splitToggle<CR>", { noremap = true })
			end,
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
