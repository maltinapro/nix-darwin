{ pkgs, ... }:

{
  # Use Lix as the Nix implementation
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # macOS system defaults applied to all machines
  system.defaults = {
    dock.autohide = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv"; # Column View
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  system.stateVersion = 5;

  # Common Homebrew packages for all machines
  homebrew = {
    taps = [ "xykong/tap" ];
    casks = [ "xykong/tap/flux-markdown" ];
  };
}