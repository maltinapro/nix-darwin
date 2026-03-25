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

  homebrew.casks = [
    "qlmarkdown" # QuickLook plugin: preview markdown files (with images) by pressing Space in Finder
  ];

  system.stateVersion = 5;
}