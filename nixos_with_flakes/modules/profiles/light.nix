{ config, pkgs, lib, ... }:

{
  # List packages installed in system profile
  # To search: nix search nixpkgs wget || nix-locate bin/wget
  environment.systemPackages = with pkgs; [

  ];
}
