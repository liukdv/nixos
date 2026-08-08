{ config, pkgs, lib, ... }:

{
  # @todo: Confirm the final lightweight package selection.

  # List packages installed in system profile
  # To search: nix search nixpkgs wget || nix-locate bin/wget
  environment.systemPackages = with pkgs; [
  # System utilities
  file
  gparted
  jq
  libnotify
  ripgrep
  tree
  wget

  # Development tools
  gh
  git
  neovim
  python314 
  vim
  wl-clipboard

  # Media & productivity
  mpv
  speedcrunch
  xournalpp

  # Internet & communication
  firefox
  ];
}
