-- =============================================================================
--  Minimal "IDE-ish" Neovim config  —  requires Neovim 0.12+
--  Location:  Linux/macOS  ~/.config/nvim/init.lua
--             Windows      %LOCALAPPDATA%\nvim\init.lua
--
--  External tools you want on PATH:
--    git, ripgrep (rg), fd, a Nerd Font in your terminal,
--    node/npm (Mason installs ts_ls through npm), .NET SDK (C#), odin (Odin),
--    optional: tree-sitter CLI + a C compiler (for extra Treesitter parsers)
--
--  First start: Neovim asks to install the plugins -> confirm.
--  Then run  :MasonInstall roslyn   once for C#.
--  Update plugins later with  :lua vim.pack.update()  (review, then :write)
-- =============================================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- -----------------------------------------------------------------------------
-- Options
-- -----------------------------------------------------------------------------
local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = 'a'
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.cursorline = true
o.scrolloff = 8
o.updatetime = 250
o.splitright = true
o.splitbelow = true
o.undofile = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.termguicolors = true
o.winborder = 'rounded' -- border for every floating window (hover, signature, ...)
vim.schedule(function() o.clipboard = 'unnamedplus' end) -- system clipboard

-- -----------------------------------------------------------------------------
-- Plugins (built-in vim.pack)
-- -----------------------------------------------------------------------------
-- Re-run :TSUpdate whenever nvim-treesitter gets updated
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      pcall(vim.cmd, 'TSUpdate')
    end
  end,
})

vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons', -- file icons (lualine, snacks, ...)
  'https://github.com/folke/snacks.nvim',          -- picker (fuzzy search) + explorer
  'https://github.com/folke/which-key.nvim',       -- shows available keys as you type
  'https://github.com/nvim-lualine/lualine.nvim',  -- statusline
  'https://github.com/lewis6991/gitsigns.nvim',    -- git signs, hunks, blame
  'https://github.com/stevearc/conform.nvim',      -- formatting (format on save)
  'https://github.com/mfussenegger/nvim-dap',      -- debugger client
  'https://github.com/igorlfs/nvim-dap-view',      -- debugger UI
  'https://github.com/neovim/nvim-lspconfig',      -- ready-made server configs (lsp/*.lua)
  'https://github.com/mason-org/mason.nvim',       -- installs language servers
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/seblyng/roslyn.nvim',        -- C# (Roslyn, same server as VS Code)
  'https://github.com/rafamadriz/friendly-snippets',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') }, -- completion
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

vim.cmd.colorscheme('tokyonight-night')

-- -----------------------------------------------------------------------------
-- UI helpers: snacks + which-key
-- -----------------------------------------------------------------------------
require('snacks').setup({
  picker   = { enabled = true },
  explorer = { enabled = true },
  indent   = { enabled = true },
  notifier = { enabled = true },
})
require('which-key').setup({
  spec = {
    { '<leader>f', group = 'find' },
    { '<leader>s', group = 'symbols/diagnostics' },
    { '<leader>c', group = 'code' },
    { '<leader>g', group = 'git' },
    { '<leader>h', group = 'hunks' },
    { '<leader>d', group = 'debug' },
    { '<leader>u', group = 'toggle' },
  },
})

require('lualine').setup({
  options = { theme = 'tokyonight', globalstatus = true },
  sections = {
    lualine_x = { 'lsp_status', 'filetype' },
  },
})

-- -----------------------------------------------------------------------------
-- Git: gitsigns (gutter, hunks, blame) + snacks git pickers
-- -----------------------------------------------------------------------------
require('gitsigns').setup({
  on_attach = function(buf)
    local gs = require('gitsigns')
    local bmap = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end
    bmap('n', ']h', function() gs.nav_hunk('next') end, 'Next hunk')
    bmap('n', '[h', function() gs.nav_hunk('prev') end, 'Previous hunk')
    bmap('n', '<leader>hs', gs.stage_hunk, 'Stage/unstage hunk')
    bmap('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
    bmap('x', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage/unstage selection')
    bmap('x', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset selection')
    bmap('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
    bmap('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
    bmap('n', '<leader>hp', gs.preview_hunk_inline, 'Preview hunk')
    bmap('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
    bmap('n', '<leader>hB', gs.blame, 'Blame buffer')
    bmap('n', '<leader>hd', gs.diffthis, 'Diff against index')
    bmap('n', '<leader>ub', gs.toggle_current_line_blame, 'Toggle inline blame')
    bmap({ 'o', 'x' }, 'ih', gs.select_hunk, 'Inner hunk')
  end,
})

-- -----------------------------------------------------------------------------
-- Formatting (conform.nvim) — format on save, falls back to the LSP formatter
-- -----------------------------------------------------------------------------
local web = { 'prettierd', 'prettier', stop_after_first = true }
require('conform').setup({
  formatters_by_ft = {
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    rust = { 'rustfmt' },
    odin = { 'odinfmt' }, -- ships with the Mason 'ols' package
    lua = { 'stylua' },
    cs = { 'csharpier' },
    javascript = web, javascriptreact = web, typescript = web, typescriptreact = web,
    json = web, jsonc = web, css = web, html = web, yaml = web, markdown = web,
  },
  default_format_opts = { lsp_format = 'fallback' },
  -- toggle with <leader>uf (vim.g.autoformat)
  format_on_save = function()
    if vim.g.autoformat == false then return end
    return { timeout_ms = 1000 }
  end,
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- gq uses conform too

-- -----------------------------------------------------------------------------
-- Completion (blink.cmp) — also gives auto signature help while typing
-- -----------------------------------------------------------------------------
require('blink.cmp').setup({
  -- 'default' : <C-y> accept, <C-n>/<C-p> next/prev, <C-space> open, <C-e> close,
  --             <C-k> toggle signature, <C-b>/<C-f> scroll docs
  -- 'enter'   : <CR> accepts      'super-tab' : <Tab> accepts (VS Code feel)
  keymap = { preset = 'default' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 300 },
  },
  signature = { enabled = true },
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})

-- -----------------------------------------------------------------------------
-- LSP
-- -----------------------------------------------------------------------------
-- Settings that apply to every server
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Per-server tweaks (merged on top of nvim-lspconfig's defaults)
vim.lsp.config('lua_ls', {
  settings = { Lua = { diagnostics = { globals = { 'vim', 'Snacks' } } } },
})
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
})

-- Mason: the extra registry provides 'roslyn' for C#
require('mason').setup({
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
})

-- Installs these and calls vim.lsp.enable() for every Mason-installed server.
-- clangd comes from the LLVM install on PATH, so Mason doesn't need its own copy.
-- (rust_analyzer stays here: the rustup proxy fails unless you run
--  'rustup component add rust-analyzer'.)
require('mason-lspconfig').setup({
  ensure_installed = { 'rust_analyzer', 'ts_ls', 'lua_ls', 'ols' },
})

-- Enable explicitly too, so servers found on PATH (not via Mason) start as well
vim.lsp.enable({ 'clangd', 'rust_analyzer', 'ts_ls', 'lua_ls', 'ols' })

-- Formatters and debug adapters (mason-lspconfig only handles language servers)
local mason_tools = { 'stylua', 'prettierd', 'csharpier', 'codelldb', 'netcoredbg' }
local mason_registry = require('mason-registry')
mason_registry.refresh(function()
  for _, name in ipairs(mason_tools) do
    local ok, pkg = pcall(mason_registry.get_package, name)
    if ok and not pkg:is_installed() and not pkg:is_installing() then pkg:install() end
  end
end)

-- C#: needs ':MasonInstall roslyn' once. Open a folder containing a .sln/.csproj.
require('roslyn').setup({})

vim.diagnostic.config({
  virtual_text = true,   -- inline messages (off by default since 0.11)
  severity_sort = true,
  float = { source = true },
})

-- -----------------------------------------------------------------------------
-- Treesitter (better highlighting/indent). Neovim ships C, Lua, Markdown, Vim
-- parsers already; the rest needs the tree-sitter CLI + a C compiler.
-- -----------------------------------------------------------------------------
if vim.fn.executable('tree-sitter') == 1 then
  require('nvim-treesitter').install({
    'cpp', 'rust', 'odin', 'typescript', 'tsx', 'javascript', 'c_sharp', 'json', 'yaml', 'toml',
  })
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Odin uses tabs (odinfmt default and the core library style)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'odin',
  callback = function(ev) vim.bo[ev.buf].expandtab = false end,
})

-- -----------------------------------------------------------------------------
-- Debugging (nvim-dap + nvim-dap-view)
--   codelldb  : C, C++, Rust, Odin   netcoredbg : C#   (both installed by Mason)
-- -----------------------------------------------------------------------------
local dap = require('dap')
require('dap-view').setup({ auto_toggle = true }) -- opens/closes with the session

-- Point at the real executables: uv.spawn can't run Mason's .cmd shims on Windows
local mason_pkg = function(path) return vim.fs.joinpath(vim.env.MASON, 'packages', path) end
dap.adapters.codelldb = {
  type = 'executable',
  command = mason_pkg('codelldb/extension/adapter/codelldb'),
}
dap.adapters.coreclr = {
  type = 'executable',
  command = mason_pkg('netcoredbg/netcoredbg/netcoredbg'),
  args = { '--interpreter=vscode' },
}

local ask_path = function(prompt, default)
  return function()
    return vim.fn.input(prompt, vim.fs.joinpath(vim.fn.getcwd(), default), 'file')
  end
end
dap.configurations.c = {
  {
    name = 'Launch executable',
    type = 'codelldb',
    request = 'launch',
    program = ask_path('Executable: ', ''),
    cwd = '${workspaceFolder}',
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = {
  vim.tbl_extend('force', dap.configurations.c[1], { program = ask_path('Executable: ', 'target/debug/') }),
}
-- Build with 'odin build . -debug' first so the executable has debug info
dap.configurations.odin = dap.configurations.c
dap.configurations.cs = {
  {
    name = 'Launch .NET dll',
    type = 'coreclr',
    request = 'launch',
    program = ask_path('Path to dll: ', 'bin/Debug/'),
    cwd = '${workspaceFolder}',
  },
}

-- -----------------------------------------------------------------------------
-- Keymaps
-- -----------------------------------------------------------------------------
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- Fuzzy search / explorer
map('n', '<leader><space>', function() Snacks.picker.smart() end,   'Find files (smart)')
map('n', '<leader>ff',      function() Snacks.picker.files() end,   'Find files')
map('n', '<leader>fg',      function() Snacks.picker.grep() end,    'Live grep')
map({ 'n', 'x' }, '<leader>fw', function() Snacks.picker.grep_word() end, 'Grep word/selection')
map('n', '<leader>fb',      function() Snacks.picker.buffers() end, 'Buffers')
map('n', '<leader>fr',      function() Snacks.picker.recent() end,  'Recent files')
map('n', '<leader>fh',      function() Snacks.picker.help() end,    'Help pages')
map('n', '<leader>fk',      function() Snacks.picker.keymaps() end, 'Keymaps')
map('n', '<leader>e',       function() Snacks.explorer() end,       'File explorer')

-- LSP navigation through the picker (overrides the built-in list versions)
map('n', 'gd',  function() Snacks.picker.lsp_definitions() end,      'Go to definition')
map('n', 'gD',  function() Snacks.picker.lsp_declarations() end,     'Go to declaration')
map('n', 'grr', function() Snacks.picker.lsp_references() end,       'References')
map('n', 'gri', function() Snacks.picker.lsp_implementations() end,  'Implementations')
map('n', 'grt', function() Snacks.picker.lsp_type_definitions() end, 'Type definition')
map('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end,           'Document symbols')
map('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace symbols')
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end,           'Diagnostics')

-- Familiar aliases (built-in defaults gra / grn still work too)
map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
map('n', '<F2>',       vim.lsp.buf.rename, 'Rename')
map({ 'n', 'x' }, '<leader>cf', function() require('conform').format({ async = true }) end, 'Format')
map('n', '<leader>uf', function()
  vim.g.autoformat = vim.g.autoformat == false
  vim.notify('Format on save: ' .. (vim.g.autoformat and 'on' or 'off'))
end, 'Toggle format on save')
map('n', '<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, 'Toggle inlay hints')

-- Git (hunk keys live in the gitsigns on_attach above)
map('n', '<leader>gs', function() Snacks.picker.git_status() end,   'Git status')
map('n', '<leader>gl', function() Snacks.picker.git_log() end,      'Git log')
map('n', '<leader>gf', function() Snacks.picker.git_log_file() end, 'Git log (file)')
map('n', '<leader>gb', function() Snacks.picker.git_branches() end, 'Git branches')
map('n', '<leader>gd', function() Snacks.picker.git_diff() end,     'Git diff (hunks)')
map('n', '<leader>go', function() Snacks.gitbrowse() end,           'Open in browser')
if vim.fn.executable('lazygit') == 1 then
  map('n', '<leader>gg', function() Snacks.lazygit() end, 'Lazygit')
end

-- Debugging
map('n', '<F5>',  dap.continue,  'Debug: start/continue')
map('n', '<F10>', dap.step_over, 'Debug: step over')
map('n', '<F11>', dap.step_into, 'Debug: step into')
map('n', '<F12>', dap.step_out,  'Debug: step out')
map('n', '<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
map('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Condition: '))
end, 'Conditional breakpoint')
map('n', '<leader>dc', dap.continue,       'Start/continue')
map('n', '<leader>dC', dap.run_to_cursor,  'Run to cursor')
map('n', '<leader>dr', dap.restart,        'Restart')
map('n', '<leader>dt', dap.terminate,      'Terminate')
map('n', '<leader>dv', function() require('dap-view').toggle() end, 'Toggle debug view')
map({ 'n', 'x' }, '<leader>dw', function() require('dap-view').add_expr() end, 'Watch expression')

-- Already built in, no mapping needed:
--   K            hover docs           <C-s> (insert)  signature help
--   gra / grn    code action / rename  gO             document symbols
--   [d / ]d      prev/next diagnostic <C-w>d          diagnostic float
--   <C-o>/<C-i>  jump back/forward

map('n', '<Esc>', '<cmd>nohlsearch<cr>', 'Clear search highlight')
