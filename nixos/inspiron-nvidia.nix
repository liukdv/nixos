{ config, pkgs, lib, ... }:

let
  # GPU mode: "prime-sync" (), "hybrid-offload", or "dgpu-only"
  gpuMode = "hybrid-offload";
in
{
  # ============================================================================
  # JOURNAL LOGS CLEANUP - TEMPORARY
  # ============================================================================

  # GL_INVALID_ENUM error generated. Invalid <face>. Invalid framebuffer status:  "GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT"
  environment.sessionVariables = {
    # Forces SW rendering for cursor - due to nvidia error
    KWIN_FORCE_SW_CURSOR = "1";
    # remove flood - JUST SILENCE, NOT FIX! 
    #QT_LOGGING_RULES = "kwin_scene_opengl=false";
  };
  
  # Fix systemd modprobe early call at boot - spam message, may be solved
  # The unit calls "modprobe" directly; on NixOS modprobe is provided by pkgs.kmod.
  systemd.services."modprobe@" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecSearchPath = "${pkgs.kmod}/bin";
  };
  
  # also QT and other nvidia should be removed (or fixed) one day
 
  # ============================================================================
  # KERNEL PARAMETERS & BOOT - SUSPEND/RESUME FIXES
  # ============================================================================
  
  # 0. 
  #boot.extraModprobeConfig = ''
  #options nvidia_modeset vblank_sem_control=0
  #'';

  # 0. Kernel Parameters: Command-line parameters passed directly to the kernel at boot.
  boot.kernelParams = [
    #"acpi_osi=Linux"     # ACPI (Advanced Configuration & Power Interface): firmware logic (BIOS/UEFI) for HW paths to the OS
    "pcie_aspm=off"       # Disable PCIe power management (helps with stability)
    "mem_sleep_default=s2idle" # Deep sleep not supported
    #"nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Saves VRAM to RAM during suspend
  ];

  # 1. Early KMS (Kernel Mode Setting): Modules loaded in the initial RAM disk (initrd)
  boot.initrd.kernelModules = [ 
    "i915"
    ]; 
  
  # 2. Modules loaded after initrd, but before userspace
  #boot.kernelModules = [
    #"nvidia"
    #"nvidia_modeset"
    #"nvidia_uvm"
    #"nvidia_drm"
  #];

  # 2. Blacklist problematic modules
  boot.blacklistedKernelModules = [ 
    "spd5118"      # RAM temperature
    "thunderbolt"  # Prevents Thunderbolt issues
    "ucsi_acpi"    # Prevents USB-C/charging issues
  ];

  # ============================================================================
  # GRAPHICS CONFIGURATION
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

  services.xserver.videoDrivers =
    if gpuMode == "hybrid-offload" then ["modesetting" "nvidia"]
    else ["nvidia"];

  # Make sure hardware acceleration works
  #environment.sessionVariables = {
  # LIBVA_DRIVER_NAME = "nvidia";  # NVIDIA for video decode
  # NVD_BACKEND = "direct";
  #};


  hardware.nvidia = {
    modesetting.enable = true; # Required for NVIDIA DRM/KMS
    open = true;  # Use Nvidia open/closed kernel modules (open should be better)
    package = config.boot.kernelPackages.nvidiaPackages.stable; # stable, beta, production
    powerManagement.enable = false; # Nvidia power-management, relevant for suspend/resume and GPU state.
    powerManagement.finegrained = false; # Nvidia power down when unused
    dynamicBoost.enable = false; # shift power dynamically between CPU and GPU (appereantly not well supported on dell/linux)

    # PRIME configuration for hybrid graphics (Intel iGPU + NVIDIA dGPU)
    prime = lib.mkIf (gpuMode != "dgpu-only") (
      if gpuMode == "hybrid-offload" then {  
	offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      } 
      else { # prime-sync mode
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
    percentageCritical = 10;
    percentageAction = 4;
    usePercentageForPolicy = true;
    criticalPowerAction = "PowerOff";
    # Dell Battery Firmware could enable thresholds, change with $: busctl call
  };

}
