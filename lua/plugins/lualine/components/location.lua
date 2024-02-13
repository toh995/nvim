-- @module plugins.lualine.components.location

-- show the current line number/column
-- see `:h statusline`
-- %l == current line number
-- %L == total number of lines in buffer
-- %c == current column number
return function() return "ln %l/%L:%c" end
