{ pkgs, ... }:

{
  networking.hostName      = "mac-mini-maltina";
  networking.localHostName = "mac-mini-maltina";

  users.users.maltina.home = "/Users/maltinabasse";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = false;
      cleanup    = "zap";
    };
    casks = [
      "signal"
    ];
  };
}