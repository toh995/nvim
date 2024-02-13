-- @module plugins.telescope
local M = {}

local set_autocmds
local set_usercmds

function M.config()
	local pkgs = {
		actions = require("telescope.actions"),
		builtin = require("telescope.builtin"),
		nvim_tree_api = require("nvim-tree.api"),
		telescope = require("telescope"),
	}

	-- Set up telescope
	pkgs.telescope.setup({
		defaults = {
			cache_picker = { num_pickers = 20 },
			mappings = {
				i = {
					["<C-u>"] = false,
					["<C-j>"] = pkgs.actions.move_selection_next,
					["<C-k>"] = pkgs.actions.move_selection_previous,
				},
			},
		},
		extensions = {
			-- Reference: https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-setup-and-configuration
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})

	pkgs.telescope.load_extension("fzf")

	set_autocmds()
	set_usercmds(pkgs)
end

function set_autocmds()
	local augroup = vim.api.nvim_create_augroup("telescope_custom", { clear = true })

	-- Show line numbers in the preview window!
	-- Reference: https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#previewers
	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = "TelescopePreviewerLoaded",
		callback = function() vim.wo.number = true end,
	})
end

function set_usercmds(pkgs)
	-- Reopen previous telescope windows
	-- Single
	vim.api.nvim_create_user_command("R", pkgs.builtin.resume, {})
	-- Multiple
	vim.api.nvim_create_user_command("RS", pkgs.builtin.pickers, {})

	-- Aerial
	pkgs.telescope.load_extension("aerial")
	vim.api.nvim_create_user_command("S", pkgs.telescope.extensions.aerial.aerial, {})

	-- LSP diagnostics
	-- Current buffer only
	vim.api.nvim_create_user_command("D", function() pkgs.builtin.diagnostics({ bufnr = 0 }) end, {})

	-- ALL buffers
	vim.api.nvim_create_user_command("DA", function() pkgs.builtin.diagnostics({ bufnr = nil }) end, {})

	-- File picker
	vim.api.nvim_create_user_command("F", function()
		pkgs.builtin.find_files({
			hidden = true,
			attach_mappings = function()
				pkgs.actions.select_default:enhance({
					post = function() pkgs.nvim_tree_api.tree.find_file({}) end,
				})
				return true
			end,
		})
	end, {})

	-- Grep
	vim.api.nvim_create_user_command("G", function(tbl)
		local filepath = tbl.fargs[1] or "."
		local glob_pattern = tbl.fargs[2] or ""

		pkgs.builtin.live_grep({
			search_dirs = { filepath },
			glob_pattern = glob_pattern,
			prompt_title = "Grep in " .. filepath .. " " .. glob_pattern,
			attach_mappings = function()
				pkgs.actions.select_default:enhance({
					post = function() pkgs.nvim_tree_api.tree.find_file({}) end,
				})
				return true
			end,
		})
	end, {
		nargs = "*",
		complete = "file",
	})
end

return M
