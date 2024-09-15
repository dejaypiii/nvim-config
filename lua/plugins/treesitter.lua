return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c",
                "c_sharp",
                "cpp",
                "css",
                "html",
                "javascript",
                "lua",
                "query",
                "rust",
                "typescript",
                "vim",
                "vimdoc",
                "vue",
                "odin",
            }
        })
    end
}
