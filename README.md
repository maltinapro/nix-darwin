# nix-darwin

This repository contains the Nix Darwin configuration of my work MacBook Pro and private Mac Mini.

It uses [Lix](https://lix.systems/) as the Nix implementation, as recommended by nix-darwin, in combination with Flakes, Home Manager and Homebrew.

## First Time Setup

```bash
# Clone the repository into the .config folder
git clone git@github.com:maltinapro/nix-darwin.git ~/.config/nix-darwin

# Run these commands only for the first time —
# they create all required files and then bootstrap nix-darwin:

# On work machine:
nix run nix-darwin -- switch --flake ~/.config/nix-darwin#asset-01142

# On private machine:
nix run nix-darwin -- switch --flake ~/.config/nix-darwin#my-macbook
```

## Everyday Commands

```bash
# Apply changes (hostname is auto-detected):
darwin-rebuild switch --flake ~/.config/nix-darwin

# Or explicitly:
darwin-rebuild switch --flake ~/.config/nix-darwin#asset-01142

# Or use the alias:
rebuild

# Update all inputs to their latest versions:
nix flake update ~/.config/nix-darwin
darwin-rebuild switch --flake ~/.config/nix-darwin
```

## GitHub Copilot in Neovim (NvChad)

After rebuilding, open Neovim and authenticate once with:

```vim
:Copilot auth
```

`copilot.lua` runs its language server with Node.js (`server.type = "nodejs"`).

Copilot Chat shortcuts (`<leader>` is `Space` in NvChad):

- `<leader>co` open chat (approval prompt)
- `<leader>ce` explain selection/code (approval prompt)
- `<leader>cr` review code (approval prompt)
- `<leader>cf` fix code (approval prompt)
- `<leader>ct` generate tests (approval prompt)
- `<leader>cw` send workspace context (`git status` + `fd` listing, approval prompt)
- `<leader>cx` execute last `bash` block from chat (approval prompt)

Useful Copilot Chat commands:

```vim
:CopilotChatOpen
:CopilotChatRun list all files recursively in current folder
:CopilotChatExec find . -type f
:CopilotChatExecLast
:CopilotChatStrictMode status
:CopilotChatStrictMode on
```

Avante (`avante.nvim`) runs alongside Copilot Chat with `provider = "copilot"`. It reuses the login from `:Copilot auth`: since copilot.lua 3.0 the language server keeps that login in `~/.config/github-copilot/auth.db` instead of `hosts.json`/`apps.json`, which is the only place Avante itself looks. `custom/configs/avante.lua` therefore reads the token from `auth.db` (with `sqlite3`, installed via `extraPackages`) and hands it to Avante. If that is not possible it falls back to the login Copilot Chat caches (`:CopilotChatModels` signs in) and finally to Avante's own lookup of a legacy `hosts.json`/`apps.json`. Restart Neovim after logging in; without any login Avante shows a warning instead of starting.

> **Note:** `custom/configs/avante.lua` is a workaround for the open Avante issues [#3170](https://github.com/avante-corp/avante.nvim/issues/3170) and [#3121](https://github.com/avante-corp/avante.nvim/issues/3121). Once Avante reads `auth.db` itself, the helper (and `sqlite` in `extraPackages`) can be removed.

Avante's native libraries are compiled with `make` (cargo) on the first start. This takes several minutes (lazy.nvim's process timeout is raised to 30 minutes for this build). If it was interrupted or failed, run `:Lazy build avante.nvim` again; cargo continues with what is already compiled. Its shortcuts use the `<leader>a` prefix (Copilot Chat uses `<leader>c`):

- `<leader>aa` ask Avante (normal/visual)
- `<leader>ae` edit selection (visual)
- `<leader>at` toggle sidebar
- `<leader>af` focus sidebar
- `<leader>aR` refresh sidebar
- `<leader>ac` add current buffer to context
- `<leader>aB` add all buffers to context
- `<leader>a?` select model, `<leader>aH` select history
- `<leader>as` toggle suggestions, `<leader>ad` toggle debug, `<leader>aM` toggle repo map

Notes:

- `:CopilotChatRun` asks Copilot to generate exactly one `bash` command; it does not execute automatically.
- Execute generated commands with `:CopilotChatExecLast`, then approve the action.
- Strict mode is enabled by default and blocks risky command patterns.
