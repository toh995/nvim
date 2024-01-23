-- @module plugins.cmp
local M = {}

local cfg
local setup_focus_shading

function M.config()
	require("catppuccin").setup(cfg)
	vim.cmd("colorscheme catppuccin-mocha")
	setup_focus_shading()
end

cfg = {
	flavour = "mocha",

	styles = {
		keywords = { "italic" },
		operators = { "italic" },
		types = { "italic" },
	},

	custom_highlights = function(colors)
		return {
			-- Add a background highlight for `` in markdown
			["@markup.raw.markdown_inline"] = { bg = colors.surface1, fg = colors.teal },
			-- Ensure builtin types behave similarly to other types
			["@type.builtin"] = { link = "Type" },
		}
	end,

	integrations = {
		treesitter_context = true,
	},
}

--[[
BUGS TODO:
1. Open new nvim. Immediately open Telescope file finder, and open a file.
2. Any way to open a file in a new tab. i.e.
    - From nvim-tree
    - From telescope (file finder, grep)
    - :TVS
    - T (move current window to new tab)
]]
--
function setup_focus_shading()
	local mocha = require("catppuccin.palettes").get_palette("mocha")
	local color_utils = require("catppuccin.utils.colors")

	local constFt = require("const.filetypes")

	-- vim.api.nvim_set_hl(0, "AerialNormal", { bg = mocha.mantle })

	local dark_ns_id = vim.api.nvim_create_namespace("dark")
	vim.api.nvim_set_hl(dark_ns_id, "Normal", { bg = mocha.mantle })
	-- vim.tbl_extend("force", { bg = mocha_palette.mantle })
	vim.api.nvim_set_hl(dark_ns_id, "WinSeparator", {
		bg = mocha.mantle,
		fg = mocha.crust,
	})
	vim.api.nvim_set_hl(dark_ns_id, "StatusLine", { bg = mocha.mantle })

	-- vim.api.nvim_set_hl(
	-- 	dark_ns_id,
	-- 	"NormalNC",
	-- 	{ bg = mocha_palette.mantle }
	-- 	-- vim.tbl_extend("force", mocha_hl_groups.NormalNC, { bg = mocha_palette.mantle })
	-- )
	local focused_ns_id = vim.api.nvim_create_namespace("focused")
	vim.api.nvim_set_hl(
		focused_ns_id,
		"Normal",
		{ bg = mocha.base }

		-- { bg = mocha.mantle }
		-- vim.tbl_extend("force", { bg = mocha_palette.mantle })
	)
	vim.api.nvim_set_hl(focused_ns_id, "WinSeparator", {
		bg = mocha.base,
		fg = mocha.crust,
	})

	local unfocused_ns_id = vim.api.nvim_create_namespace("unfocused")
	vim.api.nvim_set_hl(
		unfocused_ns_id,
		"Normal",
		{ bg = color_utils.darken(mocha.base, 2.5, mocha.mantle) }

		-- { bg = mocha.mantle }
		-- vim.tbl_extend("force", { bg = mocha_palette.mantle })
	)
	vim.api.nvim_set_hl(unfocused_ns_id, "WinSeparator", {
		bg = color_utils.darken(mocha.base, 2.5, mocha.mantle),
		fg = mocha.crust,
	})

	local disabled_fts = {
		[constFt.Aerial] = true,
		[constFt.Help] = true,
		[constFt.NvimTree] = true,
	}

	local focused_winid = nil

	vim.api.nvim_create_autocmd({ "FileType", "WinEnter" }, {
		callback = function(opts)
			-- print(opts.event, opts.match)
			local winid = vim.api.nvim_get_current_win()
			local bufid = vim.api.nvim_win_get_buf(winid)
			local ft = vim.bo[bufid].filetype
			local is_disabled = disabled_fts[ft]

			-- Filetype hasn't been loaded yet
			-- Let's exit early, and fall back to the `FileType` event
			if opts.event == "WinEnter" and ft == "" then
				return
			end
			-- Don't shift focus for these
			if ft == "TelescopePrompt" or ft == "TelescopeResults" or ft == "cmp_menu" then
				return
			end

			if is_disabled then
				vim.api.nvim_win_set_hl_ns(winid, dark_ns_id)
				if focused_winid == winid then
					focused_winid = nil
				end
			else
				if focused_winid ~= nil and vim.api.nvim_win_is_valid(focused_winid) then
					vim.api.nvim_win_set_hl_ns(focused_winid, unfocused_ns_id)
				end
				focused_winid = winid
				vim.api.nvim_win_set_hl_ns(focused_winid, focused_ns_id)
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "WinClosed" }, {
		callback = function(opts)
			local winid = opts.match
			if winid == focused_winid then
				focused_winid = nil
			end
		end,
	})
end

return M
