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
    FreezerTimeout=3min
  '';

  # Pause GNOME Shell before hibernate
systemd.services.suspend-gnome-shell = {
  description = "Suspend gnome-shell before hibernate";
  before = [ "hibernate.target" "nvidia-hibernate.service" ];
  wantedBy = [ "hibernate.target" ];
  partOf  = [ "hibernate.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = [
      "-${pkgs.procps}/bin/pkill -STOP -x gnome-shell"
      "-${pkgs.procps}/bin/pkill -STOP -x .gnome-shell-wr"
    ];
  };
};

# Resume GNOME Shell after hibernate
systemd.services.resume-gnome-shell = {
  description = "Resume gnome-shell after hibernate";
  after    = [ "hibernate.target" "nvidia-resume.service" "graphical.target" ];
  wantedBy = [ "hibernate.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.coreutils}/bin/sleep 1";
    ExecStartPost = [
      "-${pkgs.procps}/bin/pkill -CONT -x gnome-shell"
      "-${pkgs.procps}/bin/pkill -CONT -x .gnome-shell-wr"
    ];
  };
};

}
