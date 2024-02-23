-- @module util.vim
local M = {}

---@return table<string, integer[]>
function M.build_ft_to_bufnrs()
	local ret = {}
	local buffers = vim.fn.getbufinfo()
	for _, buf in ipairs(buffers) do
		local ft = vim.bo[buf.bufnr].filetype
		ret[ft] = ret[ft] or {}
		table.insert(ret[ft], buf.bufnr)
	end
	return ret
end

---@return table<string, integer[]>
function M.build_ft_to_winnrs()
	local ret = {}
	for ft, bufnrs in pairs(M.build_ft_to_bufnrs()) do
		ret[ft] = ret[ft] or {}
		for _, bufnr in ipairs(bufnrs) do
			local winnrs = vim.fn.win_findbuf(bufnr)
			for _, winnr in ipairs(winnrs) do
				table.insert(ret[ft], winnr)
			end
		end
	end
	return ret
end

return M
