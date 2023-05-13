return {
    -- simple plugins
    "jghauser/mkdir.nvim",
    -- TODO(djp): move to separate files ?!
    "neovim/nvim-lspconfig",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "SirVer/ultisnips",
    "quangnguyen30192/cmp-nvim-ultisnips",
    "mfussenegger/nvim-dap",
}
