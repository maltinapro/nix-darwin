{ pkgs, ... }:

{
  home.stateVersion = "25.05";

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

    matchBlocks = {
      # 💼 Work GitHub account
      "github-work" = {
        hostname = "github.com";
        user     = "git";
        identityFile = "~/.ssh/id_ed25519_work";
      };

      # 🏠 Private GitHub account
      "github-private" = {
        hostname = "github.com";
        user     = "git";
        identityFile = "~/.ssh/id_ed25519_private";
      };
    };
  };

  # ── Global .gitignore ────────────────────────────────────────────────
  home.file.".gitignore".text = ''
   tmp
  .idea
  '';
}