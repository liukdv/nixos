{ config, pkgs, lib, ... }:

let
  # "prime-sync" (recommended), "hybrid-offload", or "dgpu-only".
  gpuMode = "prime-sync";
in
{
  boot.kernelParams = [
    "acpi_osi=Linux"
    "mem_sleep_default=deep"
    "pcie_aspm=off"
  ];

  # Blacklist Thunderbolt (you chose this)
  boot.blacklistedKernelModules = [ "thunderbolt" ];

  # Graphics stack (GNOME Wayland enabled in gnome.nix)
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;  # nvidia......................
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    powerManagement.enable = true;  # hooks for hibernate/resume

    # PRIME routing with explicit bus IDs
    prime = lib.mkIf (gpuMode != "dgpu-only") (
      if gpuMode == "hybrid-offload" then {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      } else { # prime-sync
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      }
    );
  };

  # Logind: hibernate-only keys, lid = lock
  services.logind = {
    lidSwitch = "lock";
    lidSwitchDocked = "lock";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      LidSwitchIgnoreInhibited=yes
      HoldoffTimeoutSec=180s
      IdleAction=ignore
      HandleSuspendKey=hibernate
      HandleSuspendKeyLongPress=hibernate
      HandleHibernateKey=hibernate
      HandleHibernateKeyLongPress=hibernate
    '';
  };

  # Hibernate flavor (resume= stays in configuration.nix)
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
  '';

  # --- Sleep hooks (use absolute paths on NixOS!) --------------------------
  # Before hibernate: unload spd5118 to avoid its PM callback aborting hibernate
  powerManagement.powerDownCommands = ''
    ${pkgs.util-linux}/bin/logger -t sleep-hooks "pre-sleep: unload spd5118"
    ${pkgs.kmod}/bin/modprobe -r spd5118 || true
  '';

  # After resume: reload spd5118 and fix ELAN I2C HID quirk
  powerManagement.resumeCommands = ''
    ${pkgs.util-linux}/bin/logger -t sleep-hooks "post-resume: reload spd5118 + ELAN"
    ${pkgs.kmod}/bin/modprobe spd5118 || true
    ${pkgs.coreutils}/bin/sleep 0.5
    ${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi i2c_hid || true
    ${pkgs.kmod}/bin/modprobe i2c_hid_acpi i2c_hid || true
  '';
  # ------------------------------------------------------------------------

  # Optional: hard-block any suspend path (uncomment if you want this)
  # systemd.maskedServices = [
  #   "systemd-suspend.service"
  #   "systemd-hybrid-sleep.service"
  #   "systemd-suspend-then-hibernate.service"
  # ];
  # systemd.maskedTargets = [
  #   "sleep.target" "suspend.target" "hybrid-sleep.target"
  # ];

  # dGPU-only option (if you ever switch gpuMode)
  # boot.blacklistedKernelModules = lib.mkIf (gpuMode == "dgpu-only") [ "i915" ];
}

