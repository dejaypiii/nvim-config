-- *******************************************************************************
-- *  Set up lspconfig.
-- *******************************************************************************

-- TODO(djp): introduce proper lsp setup

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
lspconfig.rust_analyzer.setup({})