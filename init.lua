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
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.wildmode = { 'longest', 'list' }
vim.opt.mouse = "a"
vim.opt.ttyfast = true
vim.opt.splitright = true
vim.opt.splitbelow = true

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
-- *******************************************************************************

require("lazy").setup("plugins")
require("keybindings")
require("lspconfig-setup")
