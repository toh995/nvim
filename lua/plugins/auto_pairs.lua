-- @module plugins.auto_pairs
local M = {}

function M.config()
	-- Enabling deleting pairs with `Backspace`
	vim.g.AutoPairsMapBS = 1
end

return M
