-- *******************************************************************************
-- *  dejaypiii custom nvim config
-- *  11.05.2023
-- *******************************************************************************

-- *******************************************************************************
-- *  Basic Settings
-- *******************************************************************************
vim.g.mapleader = " "
vim.g.localleader = " "
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
vim.keymap.set("n", "<leader>ce", ":e ~/.config/nvim<cr>")
-- TODO(djp): keymaps - reg with which-ke<cr>y
-- TODO(djp): keymaps for telescope
-- TODO(djp): keymaps for tree
-- TODO(djp): keymaps for gitsigns
-- TODO(djp): keymaps for lint
-- TODO(djp): keymaps for format
-- TODO(djp): keymaps for lsp/cmp
-- TODO(djp): keymaps for which-key?!

