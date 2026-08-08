{ ... }:

{
  # @todo: Verify the shared and lightweight modules against the Latitude's actual requirements.
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/profiles/lightweight.nix
  ];

  networking.hostName = "liukdv-latitude-nixos";

  # @todo: Add the Latitude's real bootloader configuration before enabling this host.

  # @todo: Verify this against the Latitude's existing installation before switching.
  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. Recommended to leave this value at the first install of this system.
  system.stateVersion = "25.05";
}
