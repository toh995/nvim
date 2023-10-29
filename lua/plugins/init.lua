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
				{ "nvim-tree/nvim-web-devicons" },
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

		-- treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			dependencies = {
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
			"stevearc/aerial.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
				"onsails/lspkind.nvim",
			},
			config = function()
				require("aerial").setup({
					backends = {
						["_"] = { "lsp", "treesitter" },
						python = { "treesitter" },
					},
					autojump = true,
					layout = {
						default_direction = "left",
						-- placement = "edge",
						max_width = 0.99,
						width = nil,
						min_width = nil,
					},
					filter_kind = false, -- display all symbols

					highlight_on_hover = true,
					highlight_on_jump = false,

					-- show_guides = true,

					treesitter = { update_delay = 200 },
					markdown = { update_delay = 200 },
					man = { update_delay = 200 },

					lsp = {
						diagnostics_trigger_update = false,
						update_delay = 200,
						priority = {
							efm = -1,
							ember = -1,
							eslint = -1,
							glint = -1,
							neodev = -1,
							ruff_lsp = -1,
						},
					},

					keymaps = {
						["H"] = "actions.tree_close_all",
						["L"] = "actions.tree_open_all",
						["h"] = "actions.tree_close",
						-- ["l"] = "actions.tree_open",
						["l"] = {
							callback = function()
								local aerial = require("aerial")
								local data = require("aerial.data")
								local index = vim.api.nvim_win_get_cursor(0)[1]
								local bufdata = data.get_or_create(0)
								local item = bufdata:item(index)

								if not item then
									return
								end

								if bufdata:is_collapsed(item) then
									aerial.tree_open()
								else
									aerial.select()
								end
							end,
						},
						["<C-v>"] = "actions.jump_vsplit",
						["<C-t>"] = {
							callback = function()
								local aerial = require("aerial")
								aerial.select({ split = "tab vs" })
							end,
						},
					},

					post_parse_symbol = function(bufnr, item, ctx)
						-- vim.notify(vim.inspect(item))
						--
						if
							item.kind == "Array"
							or item.kind == "Constructor"
							or item.kind == "Function"
							or item.kind == "Method"
						then
							if item.children and #item.children > 0 then
								item.kind = item.kind .. "Branch"
							end
						end
						return true
					end,

					get_highlight = function(symbol, is_icon, is_collapsed)
						symbol = vim.deepcopy(symbol)
						symbol.kind = symbol.kind:gsub("Branch", "")

						-- If the symbol has a non-public scope, use that as the highlight group (e.g. AerialPrivate)
						if symbol.scope and not is_icon and symbol.scope ~= "public" then
							return string.format("Aerial%s", symbol.scope:gsub("^%l", string.upper))
						end

						return string.format("Aerial%s%s", symbol.kind, is_icon and "Icon" or "")

						-- return require("aerial.highlight").get_highlight(symbol, is_icon, is_collapsed)
					end,

					-- post_add_all_symbols = function(bufnr, items, ctx)
					-- 	vim.notify(vim.inspect(items))
					-- 	return items
					-- end,

					icons = {
						Array = "  ",
						ArrayBranch = " ",
						ArrayBranchCollapsed = " ",
						ArrayCollapsed = " ",
						Constructor = "  ",
						ConstructorBranch = " ",
						ConstructorBranchCollapsed = " ",
						ConstructorCollapsed = " ",
						Function = "  ",
						FunctionBranch = " ",
						FunctionBranchCollapsed = " ",
						FunctionCollapsed = " ",
						Method = "  ",
						MethodBranch = " ",
						MethodBranchCollapsed = " ",
						MethodCollapsed = " ",
					},
				})

				-- Keymappings
				vim.keymap.set("", "<leader>a", function()
					vim.cmd("AerialToggle")
				end, { noremap = true })
			end,
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

		-- Status line
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
				"linrongbin16/lsp-progress.nvim",
			},
			config = require("plugins.lualine").config,
		},

		-- Improved UI for `vim.input` and `vim.select`
		{ "stevearc/dressing.nvim" },

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
