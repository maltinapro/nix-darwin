{ pkgs, ... }:

{
  networking.hostName      = "asset-01142";
  networking.localHostName = "asset-01142";

  system.primaryUser = "basse";
  users.users.basse.home = "/Users/basse";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate  = true;
      upgrade     = false;
      cleanup     = "zap";
      extraFlags  = [ "--force" ];
    };
    taps = [
      {
        name = "hashicorp/tap";
        trusted = true;
      }
      {
        name = "quarkusio/tap";
        trusted = true;
      }
    ];
    brews = [
      "quarkus"
      "hashicorp/tap/terraform"
    ];
    casks = [
      "signal"
      "postman"
      "dbeaver-community"
      "docker-desktop"
    ];
  };
}
