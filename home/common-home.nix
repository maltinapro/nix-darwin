{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    rustup
    libiconv
    git-lfs
    gh
  ];

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    ignores = [
      "tmp"
      ".idea"
      ".DS_Store"
    ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        extraOptions = {
          "UseKeychain" = "yes"; 
      };
      };

      "github-work" = {
        hostname = "github.com";
        user     = "git";
        identityFile = "~/.ssh/id_ed25519_work";
      };

      "github-private" = {
        hostname = "github.com";
        user     = "git";
        identityFile = "~/.ssh/id_ed25519_private";
      };
    };
  };
}
