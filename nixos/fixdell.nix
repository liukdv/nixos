# /etc/nixos/fixdell.nix
{ config, pkgs, ... }:

{
  boot.kernelParams = [ 
   "acpi_osi=Linux" # enable deep - works?
   "mem_sleep_default=deep" # enable sleep - works?
   "pcie_aspm=off" # prevents PCI express bus entering d3cold
  ];   

  # Enable NVIDIA power management services for suspend/resume
  hardware.nvidia = {
    powerManagement.enable = true;
  };

  # systemd services are enabled
  systemd.services.nvidia-persistenced = {
    enable = true;
  };
  
  # Blacklist Thunderbolt - breaks hibernation
  boot.blacklistedKernelModules = [ "thunderbolt" ];
  
  # lock screen instead of suspend
  # 1) Make logind lock on lid close in all cases (battery, AC, docked)
  services.logind = {
    lidSwitch = "lock";
    lidSwitchDocked = "lock"; # does not work gnome - lock manually
    lidSwitchExternalPower = "lock"; 
   
    # Ensure logind handles lid even if GNOME takes an inhibitor - not sure if works on Gnome
    extraConfig = ''
      LidSwitchIgnoreInhibited=yes
    '';
  };

  # More aggressive hibernate
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
  '';
}
