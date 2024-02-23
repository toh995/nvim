-- @module util.vim.win_opt_manager
local util_vim = require("util.vim.init")

---@class WinOptManager
---@field private ft_to_winnrs table<string, integer[]> a map from filetype to window numbers
local WinOptManager = {}

function WinOptManager:new()
	self.ft_to_winnrs = util_vim.build_ft_to_winnrs()
	return self
end

---@param ft string the filetype
---@param opt_name string
---@param val any
function WinOptManager:set(ft, opt_name, val)
	local winnrs = self.ft_to_winnrs[ft]
	for _, winnr in ipairs(winnrs) do
		vim.wo[winnr][opt_name] = val
		-- vim.api.nvim_set_option_value(opt_name, val, { win = winnr, scope = "local" })
	end
end

---@param ft string the filetype
---@param opt_name string
---@param append_val string
function WinOptManager:append(ft, opt_name, append_val)
	if append_val == "" then
		error("passed in an empty `append_val`")
		return
	end
	local winnrs = self.ft_to_winnrs[ft]
	for _, winnr in ipairs(winnrs) do
		local cur_val = vim.wo[winnr][opt_name]
		local new_val = (cur_val == "" and append_val) or cur_val .. "," .. append_val
		vim.wo[winnr][opt_name] = new_val
		-- vim.api.nvim_set_option_value(opt_name, new_val, { win = winnr, scope = "local" })
	end
end

return WinOptManager
