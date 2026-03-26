{ pkgs, ... }:

{
  networking.hostName      = "asset-01142";
  networking.localHostName = "asset-01142";

  system.primaryUser = "basse";
  users.users.basse.home = "/Users/basse";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = false;
      cleanup    = "zap";
    };
    casks = [
      "signal"
      "postman"
      "dbeaver-community"
    ];
  };
}