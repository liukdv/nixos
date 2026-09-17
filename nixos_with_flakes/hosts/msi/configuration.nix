{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../dellg/nvidia.nix
    ../../modules/common.nix
    ../../modules/profiles/heavy.nix
  ];

  networking.hostName = "liukdv-msi-nixos";

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  services.xserver.enable = true;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. Recommended to leave this value at the first install of this system.
  system.stateVersion = "25.11";
}
