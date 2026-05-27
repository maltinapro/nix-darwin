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

    settings = {
      # global defaults (was "*")
      "Host *" = {
        AddKeysToAgent = "yes";
        UseKeychain = "yes";
      };

      "Host github-work" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_work";
      };

      "Host github-private" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_private";
      };
    };
  };
}
