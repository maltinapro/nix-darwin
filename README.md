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
