{
  description = "Flake-based NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: 
    let
      mkHost = hostname: systemType:
        nixpkgs.lib.nixosSystem {
          system = systemType;
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.mircea = import ./shared/home.nix;
            }
          ];
        };
    in {
      nixosConfigurations = {
        vm-1 = mkHost "vm-1" "aarch64-linux";
        desktop-pc = mkHost "desktop-pc" "x86_64-linux";
      };
    };
}
