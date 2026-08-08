{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    #git
    #gcc
    #python3
    #pkg-config
  ];

  shellHook = ''
    export PROJECT_ENV=development
    echo "Development shell attiva"
  '';
}