{
  description = "macOS Configurations for MacBook Pro (Work) and Mac Mini (Private) with Lix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
  let

    createMacConfig = username: darwinModules: hmModules:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./modules
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.${username} = {
              imports = [ ./home/modules ] ++ hmModules;
            };
          }
        ] ++ darwinModules;
      };

  in {
    darwinConfigurations = {

      # 💼 Work MacBook Pro
      asset-01142 = createMacConfig
        "basse"
        [ ./hosts/work/darwin.nix ]
        [ ./hosts/work/home.nix   ];

      # 🏠 Private Mac Mini
      mac-mini = createMacConfig
        "maltina"
        [ ./hosts/private/darwin.nix ]
        [ ./hosts/private/home.nix   ];

    };
  };
}