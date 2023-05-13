return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.g.loaded_netrw = 1 -- tree recommendation
        vim.g.loaded_netrwPlugin = 1 -- tree recommendation
        require("nvim-tree").setup()
    end
}
