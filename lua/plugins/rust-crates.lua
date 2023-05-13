return {
    "saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    lazy = true,
    config = function()
        require('crates').setup {
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            }
        }
    end
}
