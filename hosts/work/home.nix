{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "Maltina Basse";
        email = "basse@riege.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;

      # Use work SSH key by default for github.com
      url."git@github-work:".insteadOf = "git@github.com:";

      # Git LFS settings
      filter.lfs = {
        smudge   = "git-lfs smudge -- %f";
        process  = "git-lfs filter-process";
        required = true;
        clean    = "git-lfs clean -- %f";
      };
    };
  };

  programs.zsh.shellAliases = {
    gs      = "git status";
    vim     = "nvim";
    rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin#asset-01142";
  };

  home.packages = with pkgs; [
    # add work-only CLI tools here
  ];
}