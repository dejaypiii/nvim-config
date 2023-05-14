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
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}
lspconfig.tsserver.setup {}
