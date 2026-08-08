# /etc/nixos/plasma.nix
{ config, pkgs, ... }:

{
  # enables SDDM (login manager KDE)
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # enables KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # enables kde and gtk with priority
  xdg.portal = {
    enable = true;
    
    # already imported through services.desktopManager.plasma6.enable
    #extraPortals = with pkgs; [
    #  kdePackages.xdg-desktop-portal-kde
    #  xdg-desktop-portal-gtk
    #];

    config.common.default = [ "kde" "gtk" ];
   };

  # enable gnome keyring for old pwds and kwallet for kde stuff
  #security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.sddm.kwallet.enable = true;
  
  # additional KDE packages
  environment.systemPackages = with pkgs; [
    kdePackages.filelight
    kdePackages.kamoso
    kdePackages.kompare
    kdePackages.kolourpaint
    kdePackages.krohnkite
    krita
    seahorse 
    kde-rounded-corners
    #touchegg
  ];
  
  # enable touchegg, for gestures
  #services.touchegg.enable = true; 

  # removes preinstalled KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];
}
