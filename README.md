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

Copilot Chat shortcuts (`<leader>` is `Space` in NvChad):

- `<leader>ao` open chat (approval prompt)
- `<leader>ae` explain selection/code (approval prompt)
- `<leader>ar` review code (approval prompt)
- `<leader>af` fix code (approval prompt)
- `<leader>at` generate tests (approval prompt)
- `<leader>aw` send workspace context (`git status` + `fd` listing, approval prompt)
- `<leader>ax` execute last `bash` block from chat (approval prompt)

Useful Copilot Chat commands:

```vim
:CopilotChatOpen
:CopilotChatRun list all files recursively in current folder
:CopilotChatExec find . -type f
:CopilotChatExecLast
:CopilotChatStrictMode status
:CopilotChatStrictMode on
```

Notes:

- `:CopilotChatRun` asks Copilot to generate exactly one `bash` command; it does not execute automatically.
- Execute generated commands with `:CopilotChatExecLast`, then approve the action.
- Strict mode is enabled by default and blocks risky command patterns.
