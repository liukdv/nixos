{ config, pkgs, lib, ... }:

let
  # GPU mode: "prime-sync" (recommended), "hybrid-offload", or "dgpu-only"
  gpuMode = "prime-sync";
in
{
  # ============================================================================
  # KERNEL PARAMETERS & BOOT - SUSPEND/RESUME FIXES
  # ============================================================================
  
  # 0. 
  #boot.extraModprobeConfig = ''
  #options nvidia_modeset vblank_sem_control=0
  #'';

  # 1. Early KMS: Load Nvidia drivers immediately during boot.
  # Essential for Wayland stability, early display, and (hopefully) correct resume from suspend.
  boot.initrd.kernelModules = [ 
    "nvidia" 
    "nvidia_modeset" 
    "nvidia_uvm" 
    "nvidia_drm" 
    ]; 

  # 2. Kernel Parameters: ACPI fixes and Nvidia Power Management.
  # Necessary for stable sleep/resume cycles and preventing PCIe freezes.
  boot.kernelParams = [
    "acpi_osi=Linux"      # Tell firmware we're Linux for better ACPI compatibility
    "pcie_aspm=off"       # Disable PCIe power management (helps with stability)
    "mem_sleep_default=s2idle" # deep not supported
    
    "nvidia-drm.modeset=1"   # Nvidia specific parameter for correct resume
    #"nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Saves VRAM to RAM during suspend
  ];

  # Blacklist problematic modules
  boot.blacklistedKernelModules = [ 
    "spd5118"      # RAM temperature
    "thunderbolt"  # Prevents Thunderbolt issues
    "ucsi_acpi"    # Prevents USB-C/charging issues
  ];

  # ============================================================================
  # NVIDIA GRAPHICS CONFIGURATION
  # ============================================================================
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
   # Extra packages nvidia/intel for hardware video decoding
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
    #modesetting.enable = true; # Default on true
    open = true;  # Use open-source kernel modules - never use false, they're old
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    
    dynamicBoost.enable = true;
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
      # Action when closing the lid
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
  # SYSTEMD DISABLE SLEEP
  # ============================================================================

  # 1. no option for sleep KDE/GNOME
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # 2. block logic
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # ============================================================================
  # UPOWER
  # ============================================================================
  services.upower = {
    enable = true;
    percentageLow = 17;
    percentageCritical = 7;
    percentageAction = 4;
    criticalPowerAction = "PowerOff";
  };

}
