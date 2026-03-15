# macOS Setup with Lix + nix-darwin + Home Manager

## 🧩 Architecture: What manages what?

| Tool | Responsible for |
|---|---|
| **Homebrew** | macOS-native GUI apps (Casks) that are missing or outdated in Nixpkgs |
| **Lix + Home Manager** | Shell configuration, dev tools, dotfiles, user settings, Rust, Neovim, etc. |
| **nix-darwin** | macOS system configuration (system defaults, Homebrew integration) |

---

## 🗂️ Folder Structure

```
~/.config/nix-darwin/
├── flake.nix                   # Entry point
├── flake.lock                  # Auto-generated, commit this!
├── modules/
│   ├── common-darwin.nix       # System settings shared across all machines
│   └── common-home.nix         # Packages & tools shared across all users
└── hosts/
    ├── work/
    │   ├── darwin.nix          # Work-specific system config
    │   └── home.nix            # Work-specific user config
    └── private/
        ├── darwin.nix          # Private-specific system config
        └── home.nix            # Private-specific user config
```

---

## 📄 `flake.nix` – Entry Point

```nix
{
  description = "My macOS config with Lix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }: {
    darwinConfigurations = {

      # 💼 Work MacBook
      asset-01142 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/common-darwin.nix
          ./hosts/work/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.basse = { imports = [
              ./modules/common-home.nix
              ./hosts/work/home.nix
            ]; };
          }
        ];
      };

      # 🏠 Private MacBook
      my-macbook = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/common-darwin.nix
          ./hosts/private/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.maltina = { imports = [
              ./modules/common-home.nix
              ./hosts/private/home.nix
            ]; };
          }
        ];
      };

    };
  };
}
```

---

## 📄 `modules/common-darwin.nix` – Shared System Settings

```nix
{ pkgs, ... }:

{
  # Use Lix as the Nix implementation
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # macOS system defaults applied to all machines
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv"; # Column View
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  services.nix-daemon.enable = true;
  system.stateVersion = 5;
}
```

---

## 📄 `modules/common-home.nix` – Shared User Settings

```nix
{ pkgs, ... }:

{
  home.stateVersion = "24.11";

  # ── Packages on all machines ─────────────────────────────────────────
  home.packages = with pkgs; [
    rustup
    neovim
    git-lfs
  ];

  # ── Neovim ──────────────────────────────────────────────────────────
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # NvChad installed separately:
  # git clone https://github.com/NvChad/starter ~/.config/nvim

  # ── Zsh ─────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "rust" "docker" ];
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # ── Starship Prompt ──────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      rust.symbol = "🦀 ";
    };
  };

  # ── SSH ─────────────────────────────────────────────────────────────
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  # ── Global .gitignore ────────────────────────────────────────────────
  home.file.".gitignore".text = ''
    .DS_Store
    .idea/
    *.iml
    .direnv/
    .envrc
  '';
}
```

---

## 📄 `hosts/work/darwin.nix` – Work System Config

```nix
{ pkgs, ... }:

{
  networking.hostName      = "asset-01142";
  networking.localHostName = "asset-01142";

  users.users.basse.home = "/Users/basse";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = false;
      cleanup    = "zap";
    };
    casks = [
      "signal"        # already installed – Homebrew will adopt it
      "postman"
      "intellij-idea" # already installed – Homebrew will adopt it
    ];
  };
}
```

---

## 📄 `hosts/work/home.nix` – Work User Config

```nix
{ pkgs, ... }:

{
  # ── Git (work identity) ──────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName  = "Maltina Basse";
    userEmail = "basse@riege.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      filter.lfs = {
        smudge   = "git-lfs smudge -- %f";
        process  = "git-lfs filter-process";
        required = true;
        clean    = "git-lfs clean -- %f";
      };
    };
  };

  # ── Work-specific shell aliases ──────────────────────────────────────
  programs.zsh.shellAliases = {
    gs      = "git status";
    vim     = "nvim";
    rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin#asset-01142";
  };

  # ── Work-specific packages ───────────────────────────────────────────
  home.packages = with pkgs; [
    # add work-only CLI tools here
  ];
}
```

---

## 📄 `hosts/private/darwin.nix` – Private System Config

```nix
{ pkgs, ... }:

{
  networking.hostName      = "my-macbook";
  networking.localHostName = "my-macbook";

  users.users.maltina.home = "/Users/maltina";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = false;
      cleanup    = "zap";
    };
    casks = [
      "signal"
      "firefox"
      # add private apps here
    ];
  };
}
```

---

## 📄 `hosts/private/home.nix` – Private User Config

```nix
{ pkgs, ... }:

{
  # ── Git (private identity) ───────────────────────────────────────────
  programs.git = {
    enable = true;
    userName  = "Maltina Basse";
    userEmail = "your-private@email.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ── Private-specific shell aliases ───────────────────────────────────
  programs.zsh.shellAliases = {
    gs      = "git status";
    vim     = "nvim";
    rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin#my-macbook";
  };

  # ── Private-specific packages ────────────────────────────────────────
  home.packages = with pkgs; [
    # add private-only CLI tools here
  ];
}
```

---

## 🚀 First Time Setup

```bash
# Create and enter the config directory
mkdir -p ~/.config/nix-darwin
cd ~/.config/nix-darwin
git init

# Create all files from above, then bootstrap nix-darwin:

# On work machine:
nix run nix-darwin -- switch --flake ~/.config/nix-darwin#asset-01142

# On private machine:
nix run nix-darwin -- switch --flake ~/.config/nix-darwin#my-macbook
```

---

## 🔄 Everyday Commands

```bash
# Apply changes (hostname is auto-detected):
darwin-rebuild switch --flake ~/.config/nix-darwin

# Or explicitly:
darwin-rebuild switch --flake ~/.config/nix-darwin#asset-01142

# Update all inputs to latest versions:
nix flake update ~/.config/nix-darwin
darwin-rebuild switch --flake ~/.config/nix-darwin
```

---

## ⚖️ Decision Guide: Nix vs. Homebrew Cask

| App | Recommendation | Reason |
|---|---|---|
| **Signal** | 🍺 Homebrew Cask | Better macOS integration |
| **Postman** | 🍺 Homebrew Cask | Always up to date |
| **IntelliJ IDEA** | 🍺 Homebrew Cask | Easiest updates |
| **Git** | ❄️ Home Manager | `programs.git` with full configuration |
| **Neovim** | ❄️ Home Manager | `programs.neovim` |
| **Rust** | ❄️ Home Manager | `rustup` via Nix |
| **Shell config** | ❄️ Home Manager | `programs.zsh` / `programs.fish` |
| **Dotfiles** | ❄️ Home Manager | `home.file` |

---

## 🗂️ Directory Structure (Overview)

```
/etc/nix/nix.conf              ← Managed by Lix (do not touch)
/nix/                          ← Nix store (do not touch)

~/.config/nix-darwin/          ← YOUR configuration (Git repo)
├── flake.nix
├── flake.lock
├── modules/
│   ├── common-darwin.nix
│   └── common-home.nix
└── hosts/
    ├── work/
    │   ├── darwin.nix
    │   └── home.nix
    └── private/
        ├── darwin.nix
        └── home.nix
```

---

## 🗺️ Summary

> **Lix** is the installer recommended by nix-darwin itself: community-driven, ships with Flakes
> out-of-the-box, includes an uninstaller, and is fully compatible with Home Manager and nix-darwin.
>
> The combination **Lix + nix-darwin + Home Manager + Homebrew (Casks)** is the most modern
> and robust stack for macOS.
>
> With **multiple host configurations** in one flake, you share common settings across all machines
> while keeping machine-specific settings cleanly separated.
