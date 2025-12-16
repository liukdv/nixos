# /etc/nixos/plasma.nix
{ config, pkgs, ... }:

{
  # enables SDDM (login manager KDE)
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # enables KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # enable gnome keyring for old pwds and kwallet for kde stuff
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.sddm.enableKwallet = true;
  
  # additional KDE packages
  environment.systemPackages = with pkgs; [
    seahorse 
  ];
  
  # removes preinstalled KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];
}
