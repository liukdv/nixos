{ config, pkgs, lib, ... }:

let
  # GPU mode: "prime-sync" (recommended), "hybrid-offload", or "dgpu-only"
  gpuMode = "prime-sync";
in
{
  # ============================================================================
  # KERNEL PARAMETERS
  # ============================================================================
  boot.kernelParams = [
    "acpi_osi=Linux"      # Tell firmware we're Linux for better ACPI compatibility
    "pcie_aspm=off"       # Disable PCIe power management (helps with stability)
  ];

  # Blacklist problematic modules
  boot.blacklistedKernelModules = [ 
    "thunderbolt"  # Prevents Thunderbolt issues
    "ucsi_acpi"    # Prevents USB-C/charging issues
  ];

  # ============================================================================
  # NVIDIA GRAPHICS CONFIGURATION
  # ============================================================================
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
   # Enable VA-API for hardware video decoding
   extraPackages = with pkgs; [
     nvidia-vaapi-driver  # For NVIDIA video decode
     intel-media-driver
     libvdpau-va-gl
     ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Make sure hardware acceleration works
  #environment.sessionVariables = {
  # LIBVA_DRIVER_NAME = "nvidia";  # NVIDIA for video decode
  # NVD_BACKEND = "direct";
  #};


  hardware.nvidia = {
    modesetting.enable = true;
    open = true;  # Use open-source kernel modules - never use false, they're old
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # PRIME configuration for hybrid graphics (Intel iGPU + NVIDIA dGPU)
    prime = lib.mkIf (gpuMode != "dgpu-only") (
      if gpuMode == "hybrid-offload" then {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      } else { # prime-sync mode
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      }
    );
  };


  # ============================================================================
  # POWER MANAGEMENT & LOGIND
  # ============================================================================
  services.logind = {
    settings.Login = {
      # lid 
      HandleLidSwitch = "lock";
      HandleLidSwitchDocked = "lock";
      HandleLidSwitchExternalPower = "lock";
      LidSwitchIgnoreInhibited = "yes";

      HoldoffTimeoutSec = "30s";
      IdleAction = "ignore";

      # disable hibernation and suspend 
      HandlePowerKey = "poweroff";
      HandleSuspendKey = "ignore";
      HandleSuspendKeyLongPress = "ignore";
      HandleHibernateKey = "ignore";
      HandleHibernateKeyLongPress = "ignore";
    };
  };

  # ============================================================================
  # SYSTEMD SLEEP
  # ============================================================================
  # 
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # ============================================================================
  # UPOWER
  # ============================================================================
  services.upower = {
    enable = true;
    percentageLow = 17;
    percentageCritical = 7;
    percentageAction = 3;
    criticalPowerAction = "PowerOff";
  };


  # ============================================================================
  # AUTOMATIC IDLE SHUTDOWN
  # ============================================================================
  # NOTE: Actual idle timeouts are configured via GNOME Settings (gsettings):
  #
  # Battery: Shutdown after x minutes idle
  #   gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout x
  #   gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
  #
  # AC: Shutdown after x hours idle
  #   gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout x
  #   gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
  #
  # Then logind's IdleAction will handle the actual poweroff when timeout is reached
}
