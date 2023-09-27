-- *******************************************************************************
-- *  Set up lspconfig.
-- *******************************************************************************

local lspconfig = require("lspconfig")
local on_attach = function(client)
    require("completion").on_attach(client)
end
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.clangd.setup({})
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
        },
    },
})
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            check = {
                command = "clippy",
            },
            procMacro = {
                enable = true,
            },
        },
    },
})
lspconfig.tsserver.setup({})
lspconfig.zls.setup({
    on_attach = function(client)
        local opts = { buffer = client.buf }
        vim.keymap.set("n", "<leader>rb", ":!zig build<cr>", opts)
        vim.keymap.set("n", "<leader>rt", ":!zig build test<cr>", opts)
        vim.keymap.set("n", "<leader>rd", ":!zig build run<cr>", opts)
    end,
})
