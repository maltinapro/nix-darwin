{ pkgs, ... }:

{
  # ── Git (private identity) ───────────────────────────────────────────
  programs.git = {
    enable = true;
    userName  = "Maltina Basse";
    userEmail = "maltinabasse@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
       # use private SSH key by default for github.com
      url."git@github-private:".insteadOf = "git@github.com:";
    };
  };

  # ── Private-specific shell aliases ───────────────────────────────────
  programs.zsh.shellAliases = {
    gs      = "git status";
    vim     = "nvim";
    rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin#mac-mini";
  };

  # ── Private-specific packages ────────────────────────────────────────
  home.packages = with pkgs; [
    # add private-only CLI tools here
  ];
}