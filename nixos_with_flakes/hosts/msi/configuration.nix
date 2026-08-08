{ ... }:

{
  # @todo: Verify the shared and workstation modules against the MSI's actual requirements.
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/profiles/heavy.nix
  ];

  networking.hostName = "liukdv-msi-nixos";

  # @todo: Add the MSI's real bootloader configuration before enabling this host.

  # @todo: Add MSI-specific graphics configuration only after detecting its GPUs and PCI bus IDs.
  # DellG's NVIDIA module contains Dell-specific workarounds and must not be reused unchanged.

  # @todo: Verify this against the MSI's existing installation before switching.
  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. Recommended to leave this value at the first install of this system.
  system.stateVersion = "25.05";
}
