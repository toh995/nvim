-- @module plugin_config.lsp.keybindings
local keybindings = {}

local set_keybindings

function keybindings.configure()
	local pkgs = {
		telescope_builtin = require("telescope.builtin"),
	}

	local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup,
		callback = set_keybindings(pkgs),
	})
end

function set_keybindings(pkgs)
	return function(args)
		vim.keymap.set("", "<leader>gd", pkgs.telescope_builtin.lsp_definitions, { noremap = true, buffer = args.buf })
		vim.keymap.set("", "<leader>gr", pkgs.telescope_builtin.lsp_references, { noremap = true, buffer = args.buf })
		-- vim.keymap.set("", "<leader>gd", vim.lsp.buf.definition, { noremap = true, buffer = args.buf })
		-- vim.keymap.set("", "<leader>gr", vim.lsp.buf.references, { noremap = true, buffer = args.buf })
		vim.keymap.set("", "<leader>rn", vim.lsp.buf.rename, { noremap = true, buffer = args.buf })
		vim.keymap.set("", "<leader>k", vim.lsp.buf.hover, { noremap = true, buffer = args.buf })
		vim.keymap.set("", "<leader>d", vim.diagnostic.open_float, { noremap = true })
	end
end

return keybindings
