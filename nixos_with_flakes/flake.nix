{
  description = "liukdv NixOS configurations for DellG, Latitude, and MSI";

  inputs = {
    # @todo: Add per-host Nixpkgs inputs only if a host must remain on a different release.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      mkHost = configuration: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.liukdv = import ./home/home.nix;
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        liukdv-dellG-nixos = mkHost ./hosts/dellg/configuration.nix;

        # @todo: Verify each host's desired Nixpkgs release before enabling it.
        # @todo: Enable these after replacing their placeholder hardware configurations:
        #
        # liukdv-latitude-nixos = mkHost ./hosts/latitude/configuration.nix;
        # liukdv-msi-nixos = mkHost ./hosts/msi/configuration.nix;
      };
    };
}
