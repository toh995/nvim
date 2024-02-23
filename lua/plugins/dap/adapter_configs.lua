-- @module plugins.dap.adapter_configs
local M = {}

function M.configure()
	local dap = require("dap")
	local dap_ext_vscode = require("dap.ext.vscode")

	-------------
	-- Node.js --
	-------------
	-- register adapter
	-- inspired by https://github.com/mxsdev/nvim-dap-vscode-js/issues/42#issuecomment-1519065750
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "js-debug-adapter",
			args = { "${port}", "localhost" },
		},
	}

	-- register configuration
	dap_ext_vscode.load_launchjs(nil, {
		["pwa-node"] = { "javascript", "typescript" },
	})

	--------------
	-- Nvim Lua --
	--------------
	-- register adapter
	dap.adapters.nlua = function(callback, config)
		---@diagnostic disable-next-line: undefined-field
		callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
	end

	-- register configuration
	dap.configurations["lua"] = {
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance",
		},
	}
end

return M
