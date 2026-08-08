{
  description = "FHS development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      fhs = pkgs.buildFHSEnv {
        name = "fhs-shell";

        targetPkgs = pkgs: with pkgs; [
          gcc
          glibc
          pkg-config
          python3
        ];

        runScript = "bash";
      };
    in {
      packages.${system}.default = fhs;
      devShells.${system}.default = fhs.env;
    };
}