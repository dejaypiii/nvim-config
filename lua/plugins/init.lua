return {
    "neovim/nvim-lspconfig",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "SirVer/ultisnips",
    "quangnguyen30192/cmp-nvim-ultisnips",
    { "williamboman/mason.nvim", build = ":MasonUpdate" },
    "williamboman/mason-lspconfig.nvim",
    "mfussenegger/nvim-dap",
    { "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "RishabhRD/nvim-lsputils",
        dependencies = {
            "RishabhRD/popfix"
        }
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "lewis6991/gitsigns.nvim" },
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        }
    },
    "jghauser/mkdir.nvim",
    {
        "sudormrfbin/cheatsheet.nvim",
        dependencies = {
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        }
    },
    {
        "saecki/crates.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufRead Cargo.toml" },
        lazy = true,
    },
    {
        "vuki656/package-info.nvim",
        dependencies =  { "MunifTanjim/nui.nvim" },
        event = { "BufRead package.json" },
        lazy = true,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    }
}
