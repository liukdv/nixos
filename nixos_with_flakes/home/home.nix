{ ... }:

{
  home.username = "liukdv";
  home.homeDirectory = "/home/liukdv";
  # @todo: Keep a host's older Home Manager state version if Home Manager was activated there before 26.05.
  home.stateVersion = "26.05";

  home.packages = [ ];

  # @todo: Add user-level Home Manager configuration here when needed.
  programs.home-manager.enable = true;
}
