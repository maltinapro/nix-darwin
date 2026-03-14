{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  # ── Packages on all machines ─────────────────────────────────────────
  home.packages = with pkgs; [
    rustup
    git-lfs
  ];


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