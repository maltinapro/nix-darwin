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

  services.nix-daemon.enable = true;
  system.stateVersion = "25.05";
}