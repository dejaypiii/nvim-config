-- *******************************************************************************
-- *  Key bindings
-- *******************************************************************************

vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("n", "<leader>ce", ":e ~/.config/nvim<cr>")
vim.keymap.set({ "n", "v" }, "<leader>ww", "<C-w>w")
vim.keymap.set({ "n", "v" }, "<leader>bn", ":bn<cr>")
vim.keymap.set({ "n", "v" }, "<leader>bp", ":bp<cr>")
vim.keymap.set({ "n", "v" }, "<leader>h", "<C-w>h")
vim.keymap.set({ "n", "v" }, "<leader>j", "<C-w>j")
vim.keymap.set({ "n", "v" }, "<leader>k", "<C-w>k")
vim.keymap.set({ "n", "v" }, "<leader>l", "<C-w>l")

-- * Terminal *************************************************************************
vim.keymap.set({ "n", "v" }, "<leader>ot", ":split<cr>:term<cr>:resize 10<cr>")
vim.keymap.set({ "n", "v" }, "<leader>ovt", ":vsplit<cr>:term<cr>:vertical resize 70<cr>")
vim.keymap.set({ "t" }, "jk", "<C-\\><C-n>")

-- * LSP *************************************************************************
vim.keymap.set("n", "<leader>gh", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>af", function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

-- * Tree ************************************************************************
local nvimtree = require("nvim-tree.api")
vim.keymap.set({ "n", "v" }, "<leader>tt", nvimtree.tree.toggle, {})
vim.keymap.set({ "n", "v" }, "<leader>tf", nvimtree.tree.focus, {})

-- *******************************************************************************
-- * Telescope *******************************************************************
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})
