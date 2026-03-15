{
  networking.hostName      = "mac-mini-maltina";
  networking.localHostName = "mac-mini-maltina";

  system.primaryUser = "maltinabasse";
  users.users.maltinabasse.home = "/Users/maltinabasse";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = true;
      cleanup    = "zap";
    };
    casks = [
      "signal"
    ];
  };
}