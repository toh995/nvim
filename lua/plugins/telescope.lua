-- @module plugins.telescope
local M = {}

function M.config()
	local actions = require("telescope.actions")
	local builtin = require("telescope.builtin")
	local telescope = require("telescope")
	local nvim_tree_api = require("nvim-tree.api")

	--[[ 
  https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions

  todo:
    - builtin.quickfix 
    - builtin.quickfixhistory
    - builtin.oldfiles
    - builtin.colorscheme
  --]]
	-- setup
	telescope.setup({
		defaults = {
			cache_picker = { num_pickers = 20 },
			mappings = {
				i = {
					["<C-u>"] = false,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
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
	telescope.load_extension("fzf")

	-- autocommands
	local augroup = vim.api.nvim_create_augroup("telescope_custom", { clear = true })

	-- Show line numbers in the preview window!
	-- Reference: https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#previewers
	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = "TelescopePreviewerLoaded",
		callback = function()
			vim.wo.number = true
		end,
	})

	-- Reopen previous telescope window
	vim.api.nvim_create_user_command("R", builtin.resume, {})
	vim.api.nvim_create_user_command("RS", builtin.pickers, {})

	-- Aerial
	telescope.load_extension("aerial")
	vim.api.nvim_create_user_command("S", telescope.extensions.aerial.aerial, {})

	-- LSP diagnostics
	vim.api.nvim_create_user_command("D", function()
		-- fetch for current buffer only
		builtin.diagnostics({ bufnr = 0 })
	end, {})
	vim.api.nvim_create_user_command("DA", function()
		-- fetch for ALL buffers
		builtin.diagnostics({ bufnr = nil })
	end, {})

	-- File picker
	vim.api.nvim_create_user_command("F", function()
		builtin.find_files({
			hidden = true,
			attach_mappings = function()
				actions.select_default:enhance({
					post = function()
						nvim_tree_api.tree.find_file({})
					end,
				})
				return true
			end,
		})
	end, {})

	-- Grep
	vim.api.nvim_create_user_command("G", function(tbl)
		local filepath = tbl.fargs[1] or "."
		local glob_pattern = tbl.fargs[2] or ""

		builtin.live_grep({
			search_dirs = { filepath },
			glob_pattern = glob_pattern,
			prompt_title = "Grep in " .. filepath .. " " .. glob_pattern,
			attach_mappings = function()
				actions.select_default:enhance({
					post = function()
						nvim_tree_api.tree.find_file({})
					end,
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
