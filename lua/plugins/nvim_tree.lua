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
	vim.keymap.set("", "<leader>nt", function()
		pkgs.api.tree.toggle({ find_file = true })
	end, { noremap = true })

	vim.keymap.set("", "<leader>nf", function()
		pkgs.api.tree.find_file({ focus = true, open = true })
	end, { noremap = true })
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

		-- Auto-expand the size of the tree window
		view = { width = {} },

		-- Disable window-picker, when opening a new file
		actions = { open_file = { window_picker = { enable = false } } },

		-- Set keymappings
		on_attach = function(bufnr)
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- Set default keymappings
			pkgs.api.config.mappings.default_on_attach(bufnr)

			-- Remove J and K
			-- They're reserved for tab navigation
			vim.keymap.del("n", "J", { buffer = bufnr })
			vim.keymap.del("n", "K", { buffer = bufnr })

			-- Add some more keymaps
			vim.keymap.set("n", "h", pkgs.api.node.navigate.parent_close, opts("Collapse current folder"))
			vim.keymap.set("n", "H", pkgs.api.tree.collapse_all, opts("Collapse All"))
			vim.keymap.set("n", "l", pkgs.api.node.open.edit, opts("Open"))
		end,
	})
end

return M
