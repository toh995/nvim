-- @module plugins.lsp.keybindings
local M = {}

local set_keybindings

function M.configure()
	local pkgs = {
		telescope_builtin = require("telescope.builtin"),
	}

	local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup,
		callback = set_keybindings(pkgs),
	})

	-- Select menu for server restarts
	vim.api.nvim_create_user_command("LSP", function(_)
		local clients = vim.lsp.get_active_clients()
		vim.ui.select(clients, {
			prompt = "Choose a client to restart",
			format_item = function(client)
				return client.name
			end,
		}, function(client)
			if client then
				vim.cmd("LspRestart " .. client.id)
			end
		end)
	end, {})
end

function set_keybindings(pkgs)
	return function(args)
		vim.keymap.set("", "<leader>gd", pkgs.telescope_builtin.lsp_definitions, { noremap = true, buffer = args.buf })
		vim.keymap.set(
			"",
			"<leader>gi",
			pkgs.telescope_builtin.lsp_implementations,
			{ noremap = true, buffer = args.buf }
		)
		vim.keymap.set("", "<leader>gr", pkgs.telescope_builtin.lsp_references, { noremap = true, buffer = args.buf })
		vim.keymap.set(
			"",
			"<leader>gt",
			pkgs.telescope_builtin.lsp_type_definitions,
			{ noremap = true, buffer = args.buf }
		)
		-- vim.keymap.set("", "<leader>gd", vim.lsp.buf.definition, { noremap = true, buffer = args.buf })
		-- vim.keymap.set("", "<leader>gr", vim.lsp.buf.references, { noremap = true, buffer = args.buf })
		vim.keymap.set("", "<leader>rn", vim.lsp.buf.rename, { noremap = true, buffer = args.buf })
		vim.keymap.set("", "<leader>k", vim.lsp.buf.hover, { noremap = true, buffer = args.buf })
		vim.keymap.set("", "<leader>d", vim.diagnostic.open_float, { noremap = true })
	end
end

return M
