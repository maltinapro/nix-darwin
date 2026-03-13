{ pkgs, ... }:

{
  networking.hostName      = "asset-01142";
  networking.localHostName = "asset-01142";

  users.users.basse.home = "/Users/basse";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = false;
      cleanup    = "zap";
    };
    casks = [
      "signal"        # already installed – Homebrew will adopt it
      "postman"
      "intellij-ce" # already installed – Homebrew will adopt it
    ];
  };
}