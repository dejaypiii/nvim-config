return {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    config = true
}
