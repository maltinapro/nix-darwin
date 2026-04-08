{ pkgs, lib, ... }:

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
    k       = "kubectl";
  };

  home.packages = with pkgs; [
    kubectl
    azure-cli
    kubectx  # provides both kubectx and kubens
    kubelogin
    stern      # aggregated pod log tailing
    sqlfluff   # SQL linter and formatter
    docker-compose
    lazydocker
  ];

  # Install SDKMAN if not already present
  home.activation.installSdkman = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.sdkman" ]; then
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl -s "https://get.sdkman.io" -o /tmp/sdkman-install.sh
      $DRY_RUN_CMD ${pkgs.bash}/bin/bash /tmp/sdkman-install.sh
      $DRY_RUN_CMD rm -f /tmp/sdkman-install.sh
    fi
  '';

  # Initialize SDKMAN in every zsh session
  programs.zsh.initContent = ''
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
  '';
}