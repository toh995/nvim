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
    - vim.api.nvim_create_user_command("RS", builtin.pickers, {})
    - builtin.quickfix 
    - builtin.quickfixhistory
    - builtin.oldfiles
    - builtin.colorscheme
    - builtin.diagnostics
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
	})

	-- Reopen previous telescope window
	vim.api.nvim_create_user_command("R", builtin.resume, {})

	-- LSP symbols
	vim.api.nvim_create_user_command("LS", builtin.lsp_document_symbols, {})

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
