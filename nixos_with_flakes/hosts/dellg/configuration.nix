{ config, pkgs, lib, ... }:

{
  # @todo: These imports are changed from configuration.nix because shared settings use modules and profiles.
  imports =
    [ 
      ./hardware-configuration.nix
      ./nvidia.nix
      ../../modules/common.nix
      ../../modules/profiles/workstation.nix
      ../../modules/programs/keyd.nix
    ];

  # Bootloader - Systemd
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true; 
  
  # Grub 
  boot.loader = {
    grub = { 
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true; # to see Windows in grub 
      efiInstallAsRemovable = true; # Dell needed setting (?)
    };
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
  }; 
  boot.loader.grub.configurationLimit = 5;

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/4A8B-84AD";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
 
  # Swap and hibernation
  swapDevices = [{ device = "/dev/disk/by-uuid/baad3773-1ae7-48f0-9cda-099ebe80d246"; }];
  #boot.kernelParams = [ "resume=UUID=baad3773-1ae7-48f0-9cda-099ebe80d246" ];
  #boot.resumeDevice = "/dev/disk/by-uuid/baad3773-1ae7-48f0-9cda-099ebe80d246";
  #systemd.services."systemd-hibernate-resume".enable = true;  # not sure

  # Hostname & networking
  networking.hostName = "liukdv-dellG-nixos";

  # Logitech mouse
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
  # Enable ratbagd service for Piper
  services.ratbagd.enable = true;  

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. Recommended to leave this value at the first install of this system.
  system.stateVersion = "25.05"; 
}
