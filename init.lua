-- *******************************************************************************
-- *  dejaypiii custom nvim config
-- *  11.05.2023
-- *******************************************************************************

-- *******************************************************************************
-- *  Basic Settings
-- *******************************************************************************
vim.g.mapleader = " "
vim.g.localleader = " "
vim.g.loaded_netrw = 1 -- tree recommendation
vim.g.loaded_netrwPlugin = 1 -- tree recommendation
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
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- *******************************************************************************
-- *  Plugins
-- *******************************************************************************
require("lazy").setup("plugins")

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
        { name = "buffer" },
        { name = "crates" },
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

require("lualine").setup()

require("nvim-tree").setup()

require("gitsigns").setup()

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
})

require('crates').setup {
    null_ls = {
        enabled = true,
        name = "crates.nvim",
    },
}

require('package-info').setup()

-- *******************************************************************************
-- *  Set up lspconfig.
-- *******************************************************************************
local lspconfig = require('lspconfig')
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
-- *  Key bindings
-- *******************************************************************************
vim.keymap.set("i", "jk", "<esc>")
-- TODO(djp): keymaps - reg with which-key
-- TODO(djp): keymaps for telescope
-- TODO(djp): keymaps for tree
-- TODO(djp): keymaps for gitsigns
-- TODO(djp): keymaps for lint
-- TODO(djp): keymaps for format
-- TODO(djp): keymaps for lsp/cmp
-- TODO(djp): keymaps for which-key?!


-- TODO(djp): refactor config into separate files (plugin folder?)
-- TODO(djp): reevaluate which plugins should be lazy loadaed
