{ config, pkgs, lib, ... }:

let
  # GPU mode: "prime-sync" (recommended), "hybrid-offload", or "dgpu-only"
  gpuMode = "pryme-sync";
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
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;  # Use open-source kernel modules
    package = config.boot.kernelPackages.nvidiaPackages.beta;
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
    # Lid close behavior (just lock the screen, no sleep/suspend/hibernate)
    lidSwitch = "lock";
    lidSwitchDocked = "lock";
    lidSwitchExternalPower = "lock";
    
    extraConfig = ''
      LidSwitchIgnoreInhibited=yes
      HoldoffTimeoutSec=30s
      
      # Idle behavior (managed by GNOME)
      IdleAction=ignore
      
      # Power button behavior
      HandlePowerKey=poweroff
      
      # Disable all suspend/hibernate triggers
      HandleSuspendKey=ignore
      HandleSuspendKeyLongPress=ignore
      HandleHibernateKey=ignore
      HandleHibernateKeyLongPress=ignore
    '';
  };

  # Disable suspend and hibernate completely at systemd level
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

# UPower configuration for battery management
  services.upower = {
    enable = true;
    percentageLow = 17;              # Low battery warning at x%
    percentageCritical = 7;          # Critical at x%
    percentageAction = 3;            # Emergency action at x%
    criticalPowerAction = "PowerOff"; # Shutdown instead of HybridSleep
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
