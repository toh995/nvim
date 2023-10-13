-- @module plugins.lualine.components.filename
return {
	"filename",
	path = 1, -- show relative filepath
	separator = "/",
	padding = { left = 0, right = 1 },
	symbols = {
		modified = "[+]",
		readonly = "",
		unnamed = "[No Name]",
		newfile = "[New]",
	},
}
