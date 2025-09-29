# /etc/nixos/fixdell.nix
{ config, pkgs, ... }:

{
  boot.kernelParams = [ 
   "acpi_osi=Linux" # enable deep - works?
   "mem_sleep_default=deep" # enable sleep - works?
   "pcie_aspm=off" # prevents PCI express bus entering d3cold
  ];   

  hardware.nvidia = {
    # Enable NVIDIA power management services for suspend/resume
    powerManagement.enable = true;
  };

  # systemd services are enabled
  systemd.services.nvidia-persistenced = {
    enable = true;
  };
  
  # lock screen instead of suspend
  #services.logind = {
   # Action when no external monitors are connected.
  # lidSwitch = "lock";
   # Action when external monitors ARE connected.
  # lidSwitchDocked = "lock";
  
  # Force logind to ignore GNOME's inhibition.
  # extraConfig = ''
  #  LidSwitchIgnoreInhibited=true
  # '';
  #};

#  systemd.services."display-resume" = {
#  description = "Resume script for external monitors";
#  serviceConfig = {
#    Type = "oneshot";
#    ExecStart = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --off --output HDMI-1 --off && sleep 1 && ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --auto --output HDMI-1 --auto";
#  };
#  wantedBy = [ "suspend.target" "hibernate.target" ];
#  after = [ "suspend.target" "hibernate.target" ];
#}; 
 
}
