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
  };
  
}
