# /etc/nixos/gnome.nix
{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Install GNOME Tweaks and system-wide extensions here
    environment.systemPackages = with pkgs; [
     gnome-tweaks
     gnomeExtensions.vertical-workspaces
     gnomeExtensions.custom-hot-corners-extended
     gnomeExtensions.clipboard-indicator
     gnomeExtensions.gtile
     gnomeExtensions.hibernate-status-button
     gnomeExtensions.dash2dock-lite
     sticky-notes
     dconf-editor
  ];
  
  # remove useless gnome packages
    environment.gnome.excludePackages = [
     pkgs.decibels # audio player
     pkgs.geary # mail client
     pkgs.totem # video player
     pkgs.gnome-music # music player
    ];

}

