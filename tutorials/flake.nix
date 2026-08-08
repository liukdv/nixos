{
  description = "Generic development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          gcc
          python3
          pkg-config
        ];

        shellHook = ''
          export PROJECT_ENV=development
          echo "Development shell attiva"
        '';
      };
    };
}