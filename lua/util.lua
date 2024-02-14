-- @module util
local M = {}

---@param s string
---@return string
function M.capitalize_first_letter(s)
	if s == "" then
		return s
	end
	-- lua is 1-indexed!
	local first = s:sub(1, 1)
	local second = s:sub(2, -1)
	return first:upper() .. second
end

---@generic T
---@param fn fun(x: T): boolean
---@param arr T[]
---@return boolean
function M.any(fn, arr)
	for _, x in ipairs(arr) do
		if fn(x) then
			return true
		end
	end
	return false
end

return M
