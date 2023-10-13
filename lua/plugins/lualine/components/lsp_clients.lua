-- @module plugins.lualine.components.lsp_clients
return function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

	local ret = " LSP:" .. #clients

	if #clients == 1 or #clients == 2 then
		local client_names = {}
		for _, client in ipairs(clients) do
			table.insert(client_names, "[" .. client.name .. "]")
		end
		return ret .. " " .. table.concat(client_names, " ")
	end

	return ret
end
