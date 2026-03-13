{ pkgs, ... }:

{
  networking.hostName      = "my-macbook";
  networking.localHostName = "my-macbook";

  users.users.maltina.home = "/Users/maltina";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = false;
      cleanup    = "zap";
    };
    casks = [
      "signal"
      "firefox"
      # add private apps here
    ];
  };
}