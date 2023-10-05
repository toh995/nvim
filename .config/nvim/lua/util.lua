-- @module util
local util = {}

-- Return a list of keys for the table.
-- Similar to JavaScript's Object.keys().
function util.tbl_keys(tbl)
	local ret = {}
	local i = 0

	for key, _ in pairs(tbl) do
		i = i + 1
		ret[i] = key
	end

	return ret
end

return util
