-- *******************************************************************************
-- *  Set up lspconfig.
-- *******************************************************************************

local lspconfig = require("lspconfig")
local on_attach = function(client)
    require("completion").on_attach(client)
end
lspconfig.clangd.setup({ })
lspconfig.cmake.setup({})
lspconfig.lua_ls.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.ts_ls.setup({})