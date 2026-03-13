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
       # use work SSH key by default for github.com
      url."git@github-work:".insteadOf = "git@github.com:";
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