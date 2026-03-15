{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # These are the new renamed paths
    settings = {
      user = {
        name = "Maltina Basse";
        email = "maltinabasse@gmail.com";
      };
      
      # extraConfig becomes just 'settings'
      init.defaultBranch = "main";
      pull.rebase = true;
      
      # use private SSH key by default for github.com
      url."git@github-private:".insteadOf = "git@github.com:";
    };
  };

  programs.zsh.shellAliases = {
    gs      = "git status";
    vim     = "nvim";
    rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin#mac-mini";
  };
  
  home.packages = with pkgs; [
    # add private-only CLI tools here
  ];
}