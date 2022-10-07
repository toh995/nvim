-- @module plugin_config
local plugin_config = {}

local is_packer_installed
local get_packer_install_path
local bootstrap_packer
local init_packer

function plugin_config.configure()
    local should_bootstrap = is_packer_installed()
    if should_bootstrap then
        bootstrap_packer()
    end

    init_packer()

    if should_bootstrap then
        -- sync, then skip the rest of the setup
        local packer = require("packer")
        packer.sync()
        return
    end

    -- plugin-specific setup
    require("plugin_config.lsp").configure()
    require("plugin_config.nvim_tree").configure()
end

function is_packer_installed()
    local install_path = get_packer_install_path()
    install_path = vim.fn.glob(install_path)
    return vim.fn.empty(install_path) > 0
end

function get_packer_install_path()
    return vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
end

function bootstrap_packer()
    local install_path = get_packer_install_path()
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd [[packadd packer.nvim]]
end

function init_packer()
    local packer = require("packer")
    packer.startup(function(use)
        -- package manager
        use "wbthomason/packer.nvim"

        -- LSP
        use "neovim/nvim-lspconfig"
        use "williamboman/mason.nvim"
        use "williamboman/mason-lspconfig.nvim"

        -- autocomplete
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-nvim-lsp-signature-help"
        use "hrsh7th/cmp-path"

	-- file explorer
	use {
		"kyazdani42/nvim-tree.lua",
	  	requires = {
			"kyazdani42/nvim-web-devicons",
		},
		tag = "nightly" -- optional, updated every week. (see issue #1193)
	}
    end)
end

return plugin_config
