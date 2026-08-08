# /etc/nixos/nvidia.nix
{ config, pkgs, ... }:

{

  # Enable graphics drivers (OpenGL, Vulkan, etc.)
  hardware.graphics = {
    enable = true;
    #driSupport = true; #not needed anymore
    #driSupport32Bit = true; #not needed anymore
  };

  # Configure NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {       
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # in fixdell.nix
    #powerManagement.enable = true;
  
    # PRIME Offload - Intel for built-in display, NVIDIA on demand?
    #prime = {
      #offload = {
        #enable = true;
        #enableOffloadCmd = true;
      #};
      
      #intelBusId = "PCI:0:2:0";
      #nvidiaBusId = "PCI:1:0:0";
    #};
  };
  
# nvidia-persistenced service - in fixdell.nix
  #systemd.services.nvidia-persistenced = {
    #enable = true;
  #};  
}
