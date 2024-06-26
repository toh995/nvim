-- @module plugins.nvim_tree
local M = {}

local setup_tree

function M.config()
	local pkgs = {
		nvim_tree = require("nvim-tree"),
		api = require("nvim-tree.api"),
	}

	-- Disable netrw
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- Setup
	setup_tree(pkgs)

	-- Keymappings
	vim.keymap.set("", "<leader>nt", function() pkgs.api.tree.toggle({ find_file = true }) end, { noremap = true })
	vim.keymap.set(
		"",
		"<leader>nf",
		function() pkgs.api.tree.find_file({ focus = true, open = true }) end,
		{ noremap = true }
	)
end

function setup_tree(pkgs)
	pkgs.nvim_tree.setup({
		-- When switching tabpage, or opening a new tabpage:
		--    - If the tree was open, then keep it open
		--    - If the tree was closed, then keep it closed
		tab = { sync = {
			open = true,
			close = true,
		} },

		-- Hide the root folder path displayed at the top
		renderer = { root_folder_label = false },

		-- Show git-ignored files in the tree
		filters = { git_ignored = false },

		-- Auto-expand the size of the tree window
		view = { width = {} },

		-- Disable window-picker, when opening a new file
		actions = { open_file = { window_picker = { enable = false } } },

		-- Set the minimum threshold for notify messages
		notify = { threshold = vim.log.levels.WARN },

		-- Set the trash command
		trash = { cmd = "trash" },

		-- Set keymappings
		on_attach = function(bufnr)
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- Set default keymappings
			pkgs.api.config.mappings.default_on_attach(bufnr)

			-- Remove some keymappings
			-- They're reserved for navigation
			vim.keymap.del("n", "J", { buffer = bufnr })
			vim.keymap.del("n", "K", { buffer = bufnr })
			vim.keymap.del("n", "<C-k>", { buffer = bufnr })

			-- Show file details
			vim.keymap.set("n", "<leader>k", pkgs.api.node.show_info_popup, opts("Info"))

			-- Add tree navigation keymaps
			vim.keymap.set("n", "h", pkgs.api.node.navigate.parent_close, opts("Collapse current folder"))
			vim.keymap.set("n", "H", pkgs.api.tree.collapse_all, opts("Collapse All"))
			vim.keymap.set("n", "l", pkgs.api.node.open.edit, opts("Open"))

			-- Set up trash
			vim.keymap.del("n", "d", { buffer = bufnr })
			vim.keymap.set("n", "d", pkgs.api.fs.trash, opts("Trash"))

			-- Open file in new tab
			vim.keymap.del("n", "<C-t>", { buffer = bufnr })
			vim.keymap.set("n", "<C-t>", function()
				-- move the vim cursor to the right first,
				-- then open the tab
				vim.cmd("wincmd l")
				pkgs.api.node.open.tab()
			end, opts("Trash"))
		end,
	})
end

return M
