-- *******************************************************************************
-- *  dejaypiii custom nvim config
-- *  11.05.2023
-- *******************************************************************************

-- *******************************************************************************
-- *  Basic Settings
-- *******************************************************************************
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.wildmode = { 'longest', 'list' }
vim.opt.mouse = "a"
vim.opt.ttyfast = true

-- *******************************************************************************
-- *  Package Manager
-- *******************************************************************************
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- *******************************************************************************
-- *  Plugins
-- *******************************************************************************
require("lazy").setup({
    { "catppuccin/nvim", name = "catppuccin" },
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "SirVer/ultisnips",
    "quangnguyen30192/cmp-nvim-ultisnips",
    -- "folke/which-key.nvim",
    { "williamboman/mason.nvim", build = ":MasonUpdate" },
-- TODO(djp): recommended mason plugins
-- LSP: lspconfig & mason-lspconfig.nvim
-- DAP: nvim-dap
-- Linters: null-ls.nvim or nvim-lint
-- Formatters: null-ls.nvim or formatter.nvim
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
-- TODO(djp) checkout following plugins
-- nvim-lsputils
-- nvim-surround
-- telescope
-- nvim-tree
-- neoproj?
-- nvim-lualine
-- barbar ?
-- nvim-web-devicons ?
-- abbreinder.nvim ?!?!
-- mkdnflow.nvim ?!?!
-- neoorg ?
-- orgmode ?
-- mkdir
-- cheatsheet
-- package-info-nvim
-- crates.nvim
-- gitsigns
-- sort ?
})

-- *  Set up nvim-cmp
local cmp = require("cmp")

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "ultisnips" },
    }, {
        { name = "buffer" },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = "buffer" },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})

require("mason").setup()

-- It's important that you set up neoconf.nvim BEFORE nvim-lspconfig.
require("neoconf").setup({
    -- override any of the default settings here
})

require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})

-- *******************************************************************************
-- *  Set up lspconfig.
-- *******************************************************************************
local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
})

-- *******************************************************************************
-- *  Theme
-- *******************************************************************************
vim.cmd.colorscheme("catppuccin")

-- *******************************************************************************
-- *  Key bindings
-- *******************************************************************************
vim.keymap.set("i", "jk", "<esc>")
