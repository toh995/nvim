-- @module plugin_config
local plugin_config = {}

function plugin_config.configure()
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
			config = require("plugin_config.lsp").config,
			dependencies = {
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },
				{ "jayp0521/mason-null-ls.nvim" },
				{ "neovim/nvim-lspconfig" },
				{
					"jose-elias-alvarez/null-ls.nvim",
					dependencies = { "nvim-lua/plenary.nvim" },
				},
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
				-- Telescope (for LSP go-tos)
				{ "nvim-telescope/telescope.nvim" },
			},
		},

		-- file explorer
		{
			"kyazdani42/nvim-tree.lua",
			dependencies = { "kyazdani42/nvim-web-devicons" },
			version = "nightly", -- optional, updated every week. (see issue #1193)
			config = require("plugin_config.nvim_tree").config,
		},

		-- fuzzy finder
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			branch = "0.1.x",
			config = require("plugin_config.telescope").config,
		},

		-- tabs
		{
			"akinsho/bufferline.nvim",
			version = "v3.*",
			dependencies = { "kyazdani42/nvim-web-devicons" },
			config = require("plugin_config.bufferline").config,
		},

		-- syntax highlighting
		{
			"nvim-treesitter/nvim-treesitter",
			build = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
			config = require("plugin_config.nvim_treesitter").config,
		},
		{ "nvim-treesitter/nvim-treesitter-context" },

		-- test runner
		{
			"vim-test/vim-test",
			dependencies = { "preservim/vimux" },
			config = require("plugin_config.vim_test").config,
		},

		-- Markdown preview
		{
			"iamcco/markdown-preview.nvim",
			build = "cd app && yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			ft = { "markdown" },
			config = require("plugin_config.markdown_preview").config,
		},

		-- comment
		{
			"numToStr/Comment.nvim",
			config = require("plugin_config.comment").config,
		},

		-- vim surround
		{ "tpope/vim-surround" },

		-- cutlass
		{
			"gbprod/cutlass.nvim",
			config = require("plugin_config.cutlass").config,
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
			config = require("plugin_config.git_blame").config,
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

return plugin_config
