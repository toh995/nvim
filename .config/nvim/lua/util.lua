-- @module util
local M = {}

-- Return a list of keys for the table.
-- Similar to JavaScript's Object.keys().
function M.tbl_keys(tbl)
	local ret = {}
	local i = 0

	for key, _ in pairs(tbl) do
		i = i + 1
		ret[i] = key
	end

	return ret
end

function M.clone_deep(val)
	-- Adapted from https://gist.github.com/tylerneylon/81333721109155b2d244
	if type(val) ~= "table" then
		return val
	end

	local ret = {}
	for k, v in pairs(val) do
		ret[M.clone_deep(k)] = M.clone_deep(v)
	end

	return ret
end

-- @tparam string s
-- @treturn string
function M.capitalize_first_letter(s)
	if s == "" then
		return s
	end

	-- lua is 1-indexed!
	local first = string.sub(s, 1, 1)
	local second = string.sub(s, 2, -1)
	return string.upper(first) .. second
end

return M
