# nvim-config

A small, single-file Neovim config for C, C++, Rust, Odin, TypeScript/JavaScript, C# and Lua.
It uses the plugin manager built into Neovim 0.12 (`vim.pack`), so there's no lazy.nvim/packer
bootstrap code: everything lives in [`init.lua`](init.lua) and the plugin lockfile
[`nvim-pack-lock.json`](nvim-pack-lock.json).

## Requirements

| Tool | Why |
| --- | --- |
| Neovim **0.12+** | `vim.pack`, `vim.lsp.config` / `vim.lsp.enable`, `winborder` |
| `git` | `vim.pack` clones plugins with it |
| `rg` (ripgrep), `fd` | Fast grep / file search in the picker |
| `node` + `npm` | Mason installs `ts_ls` (typescript-language-server) through npm |
| .NET SDK | Runs the Roslyn C# server |
| `odin` on PATH | Odin compiler; `ols` uses it to find the core/base/vendor libraries |
| `clangd` on PATH | C/C++ (e.g. from an LLVM install); not installed through Mason |
| `clang-format`, `rustfmt` on PATH | C/C++ and Rust formatting (LLVM and rustup provide them) |
| `tree-sitter` CLI + C compiler | Builds the extra Treesitter parsers: `cargo install tree-sitter-cli --locked`, plus clang or MSVC (see note) |
| A Nerd Font | Icons in the picker, explorer, statusline and which-key |
| *optional:* `lazygit` | Enables `<leader>gg` |

## Install

```bash
git clone https://github.com/dejaypiii/nvim-config.git ~/.config/nvim        # Linux/macOS
git clone https://github.com/dejaypiii/nvim-config.git $env:LOCALAPPDATA\nvim # Windows (PowerShell)
```

1. Start `nvim` and confirm the plugin install prompt. Plugins are installed at the revisions in
   `nvim-pack-lock.json`.
2. Mason then installs, in the background (watch with `:Mason`):
   * the language servers `rust_analyzer`, `ts_ls`, `lua_ls` and `ols` (Odin, includes `odinfmt`);
   * the formatters `stylua`, `prettierd` and `csharpier`;
   * the debug adapters `codelldb` and `netcoredbg`.

   nvim-treesitter builds its parsers too.
3. For C#, run `:MasonInstall roslyn` once.
4. `:restart`, then `:checkhealth vim.lsp vim.pack mason` to confirm everything is green.

## Features

| Area | Plugin / built-in | Notes |
| --- | --- | --- |
| Plugin manager | `vim.pack` (built in) | Lockfile-pinned, update review buffer |
| Fuzzy search | [snacks.nvim](https://github.com/folke/snacks.nvim) picker | Files, grep, buffers, recent, help, keymaps, LSP results |
| File explorer | snacks.nvim explorer | `<leader>e` |
| Key hints | [which-key.nvim](https://github.com/folke/which-key.nvim) | Press `<leader>` and wait |
| Completion | [blink.cmp](https://github.com/saghen/blink.cmp) 1.x | LSP, path, snippets ([friendly-snippets](https://github.com/rafamadriz/friendly-snippets)), buffer; docs popup; auto signature help |
| LSP configs | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Provides `lsp/*.lua` defaults; customised with `vim.lsp.config()` |
| Server installs | [mason.nvim](https://github.com/mason-org/mason.nvim) + [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) | Extra registry `Crashdummyy/mason-registry` for Roslyn |
| C# | [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) | Same Roslyn server as VS Code's C# extension |
| Syntax | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch) | Highlighting + indent when a parser exists |
| Git | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) + snacks git pickers | Gutter signs, stage/reset/preview hunks, blame, status/log/branches pickers, lazygit if installed |
| Formatting | [conform.nvim](https://github.com/stevearc/conform.nvim) | Format on save (toggle `<leader>uf`), falls back to the LSP formatter |
| Debugging | [nvim-dap](https://github.com/mfussenegger/nvim-dap) + [nvim-dap-view](https://github.com/igorlfs/nvim-dap-view) | codelldb (C/C++/Rust/Odin), netcoredbg (C#); the view opens/closes with the session |
| Statusline | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Mode, branch, diff, diagnostics, active LSP, filetype |
| UI | tokyonight (`night`), [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons), snacks indent guides + notifier, rounded borders on all floats | |

### Formatters

| Filetypes | Formatter | Comes from |
| --- | --- | --- |
| C / C++ | `clang-format` (reads your `.clang-format`) | System PATH (LLVM) |
| Rust | `rustfmt` | rustup |
| Odin | `odinfmt` (reads your `odinfmt.json`) | Mason (bundled with `ols`) |
| Lua | `stylua` | Mason |
| JS / TS / JSX / TSX, JSON, CSS, HTML, YAML, Markdown | `prettierd` (or `prettier` if present) | Mason |
| C# | `csharpier` | Mason |
| anything else | the LSP's own formatter, if any | |

`:ConformInfo` shows which formatter applies to the current buffer.

### Debugging

| Language | Adapter | What it asks for on `<F5>` |
| --- | --- | --- |
| C / C++ | codelldb | Path to the executable (build with debug info first, e.g. `-g`) |
| Rust | codelldb | Executable under `target/debug/` (`cargo build` first) |
| Odin | codelldb | Path to the executable (`odin build . -debug` first) |
| C# | netcoredbg | The `.dll` under `bin/Debug/...` (`dotnet build` first) |

> On Windows, codelldb reads MSVC `.pdb` debug info, but its support is more limited than with
> DWARF. If breakpoints don't bind, build with clang and `-g -gdwarf`, or use the GNU Rust toolchain.

### Language servers

| Language | Server | Comes from |
| --- | --- | --- |
| C / C++ | `clangd` (`--background-index --clang-tidy --header-insertion=iwyu`) | System PATH (LLVM) |
| Rust | `rust_analyzer` | Mason |
| Odin | `ols` (reads your `ols.json`) | Mason |
| TypeScript / JavaScript | `ts_ls` | Mason (npm) |
| Lua | `lua_ls` (knows the `vim` and `Snacks` globals) | Mason |
| C# | `roslyn` | Mason, from the Crashdummyy registry (`:MasonInstall roslyn`). Open a folder that contains a `.sln`/`.csproj`. |

`init.lua` enables all of these with `vim.lsp.enable()`, so a server found on PATH works even if
Mason didn't install it.

> **Rust note:** if you'd rather use rustup's `rust-analyzer` (it always matches your toolchain), run
> `rustup component add rust-analyzer` and remove `rust_analyzer` from `ensure_installed`.
> Mason's bin directory comes first on PATH, so as long as Mason has its copy, that copy wins.

### Treesitter

Neovim ships parsers for C, Lua, Markdown, Vim script and Vimdoc. If the `tree-sitter` CLI is on PATH,
`init.lua` also installs cpp, rust, odin, typescript, tsx, javascript, c_sharp, json, yaml and toml.
Without the CLI those filetypes fall back to regex highlighting; nothing breaks.

> **Windows:** don't install the CLI with `npm i -g tree-sitter-cli`. npm puts an extensionless `tree-sitter`
> shell shim on PATH, Neovim resolves to that shim, and every parser build fails with `ENOENT`.
> Use `cargo install tree-sitter-cli --locked` (or a release `.exe` on PATH) instead.

## Key bindings

`<leader>` is **Space**. Press it and wait to see everything in which-key.

### Search & explorer

| Key | Action |
| --- | --- |
| `<leader><space>` | Find files (smart: buffers, recent and project files) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep word under cursor / visual selection |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help pages |
| `<leader>fk` | Keymaps |
| `<leader>e` | File explorer |

### LSP

| Key | Action |
| --- | --- |
| `K` | Hover documentation (built in) |
| `gd` / `gD` | Go to definition / declaration |
| `grr` | References |
| `gri` | Implementations |
| `grt` | Type definition |
| `<leader>ss` / `<leader>sS` | Document / workspace symbols |
| `<leader>sd` | Diagnostics picker |
| `<leader>ca` or `gra` | Code action |
| `<leader>rn`, `<F2>` or `grn` | Rename |
| `<leader>cf` | Format buffer / selection (conform) |
| `<leader>uf` | Toggle format on save |
| `<leader>th` | Toggle inlay hints |
| `[d` / `]d` | Previous / next diagnostic (built in) |
| `<C-w>d` | Diagnostic float under cursor (built in) |
| `gO` | Document symbols in the location list (built in) |
| `<C-o>` / `<C-i>` | Jump back / forward |

### Completion (insert mode, blink.cmp `default` preset)

| Key | Action |
| --- | --- |
| `<C-space>` | Open menu / toggle docs |
| `<C-n>` / `<C-p>` (or `<Up>` / `<Down>`) | Next / previous item |
| `<C-y>` | Accept |
| `<C-e>` | Close menu |
| `<C-b>` / `<C-f>` | Scroll documentation |
| `<C-k>` | Toggle signature help |
| `<Tab>` / `<S-Tab>` | Jump between snippet placeholders |
| `<C-s>` | Signature help (Neovim built in) |

Prefer `<CR>` or `<Tab>` to accept? Change `keymap = { preset = 'default' }` to `'enter'` or `'super-tab'`.

### Git

| Key | Action |
| --- | --- |
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` / `<leader>hr` | Stage (toggle) / reset hunk (or visual selection) |
| `<leader>hS` / `<leader>hR` | Stage / reset whole buffer |
| `<leader>hp` | Preview hunk inline |
| `<leader>hb` / `<leader>hB` | Blame line (full commit) / blame buffer |
| `<leader>hd` | Diff file against the index |
| `<leader>ub` | Toggle inline blame on the current line |
| `ih` | Text object: inner hunk (e.g. `dih`, `vih`) |
| `<leader>gs` | Git status picker |
| `<leader>gl` / `<leader>gf` | Git log (repo / current file) |
| `<leader>gb` | Branches |
| `<leader>gd` | Diff hunks picker |
| `<leader>go` | Open file/line on GitHub (gitbrowse) |
| `<leader>gg` | Lazygit (only when `lazygit` is installed) |

### Debugging

| Key | Action |
| --- | --- |
| `<F5>` / `<leader>dc` | Start / continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dC` | Run to cursor |
| `<leader>dr` / `<leader>dt` | Restart / terminate |
| `<leader>dv` | Toggle debug view (it also opens/closes automatically) |
| `<leader>dw` | Add expression under cursor / selection to watches |

### Misc

| Key | Action |
| --- | --- |
| `<Esc>` | Clear search highlight |
| `jk` (insert mode) | Leave insert mode |

## Maintaining & updating

### Updating plugins

1. Run `:lua vim.pack.update()`. Neovim fetches every plugin and opens a review buffer listing the
   pending changes per plugin (navigate with `]]` / `[[`, outline with `gO`).
2. Read the changelog. `:write` applies the updates; `:quit` discards them.
3. `:restart`, then test.
4. Commit the changed `nvim-pack-lock.json` so other machines get the same revisions:
   ```bash
   git add nvim-pack-lock.json
   git commit -m "Update plugins"
   ```

Update a single plugin with `:lua vim.pack.update({ 'snacks.nvim' })`.
nvim-treesitter re-runs `:TSUpdate` automatically after it is updated (`PackChanged` autocmd in `init.lua`).

### Rolling back a bad update

```bash
git checkout HEAD -- nvim-pack-lock.json
```

Then `:restart` and run `:lua vim.pack.update(nil, { offline = true, target = 'lockfile' })`.
Confirm with `:write`.

### Pinning / unpinning a plugin

Set `version` in its spec. Use a commit hash to freeze (copy `rev` from `nvim-pack-lock.json`),
a branch name to follow a branch, or `vim.version.range('1.*')` for semver tags (as for blink.cmp).
`:restart` afterwards. To unpin, remove `version` and `:restart`.

### Adding a plugin

Add its URL (or a `{ src = ..., version = ... }` table) to `vim.pack.add({...})`, add its `setup()` below,
then `:restart` and confirm the install. Commit `init.lua` together with `nvim-pack-lock.json`.

### Removing a plugin

1. Delete it from `vim.pack.add({...})` and remove its `setup()` / keymaps.
2. `:restart`.
3. `:lua vim.pack.del({ 'plugin-name' })` to delete it from disk.
   List leftover inactive plugins with:
   ```lua
   :lua =vim.iter(vim.pack.get()):filter(function(p) return not p.active end):map(function(p) return p.spec.name end):totable()
   ```

### Language servers (Mason)

* `:Mason` opens the UI. Press `U` to update all servers, `i` to install, `X` to uninstall.
* Add a server: put its **lspconfig name** (e.g. `pyright`, `gopls`) in `ensure_installed` *and*
  in the `vim.lsp.enable({...})` list. Server-specific settings go in a `vim.lsp.config('<name>', {...})` call.
  Run `:help lspconfig-all` to see the available names.
* Roslyn updates the same way (`U` in `:Mason`). It comes from the Crashdummyy registry.
* Formatters and debug adapters are listed in `mason_tools` in `init.lua`. Add a Mason package name
  there and it gets installed on the next start. To wire a new formatter in, add it to
  `formatters_by_ft` in the conform setup.
* Add a debugger: install its adapter via `mason_tools`, then add `dap.adapters.<name>` and
  `dap.configurations.<filetype>` next to the existing ones (see `:help dap-adapter` and the
  [nvim-dap wiki](https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)).
* Debugging: `:checkhealth vim.lsp` (lists active clients and their configs), `:lsp restart` to
  restart servers, and the log via `:lua vim.cmd.edit(vim.lsp.log.get_filename())`.

### Treesitter parsers

`:TSUpdate` updates installed parsers. Add languages to the list passed to
`require('nvim-treesitter').install({...})` (requires the `tree-sitter` CLI).

### Syncing to another machine

```bash
git pull
```

Then `:restart`, which installs any new plugins at their locked revisions, and run
`:lua vim.pack.update(nil, { target = 'lockfile' })` to move existing plugins to the locked revisions.
Remove plugins that were dropped with `vim.pack.del()` (see `git diff -- nvim-pack-lock.json`).

### Health check after any change

```vim
:checkhealth vim.lsp vim.pack mason blink.cmp snacks conform gitsigns dap-view
```

## License

MIT, see [LICENSE](LICENSE).
