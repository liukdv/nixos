{ config, pkgs, ... }:
{
  # Enable Podman with Docker compatibility
  virtualisation.podman = {
    enable = true;
    
    # Create a `docker` alias for podman
    dockerCompat = true;
    
    # Required for containers under podman-compose to be able to talk to each other
    defaultNetwork.settings.dns_enabled = true;
  };

  # Configure container registries
  # This fixes the "short-name did not resolve to an alias" error
  virtualisation.containers = {
    enable = true;
    
    registries = {
      search = [
        "docker.io"    # Docker Hub - searches here first
        "quay.io"      # Red Hat's registry
        "ghcr.io"      # GitHub Container Registry
      ];
    };
  };
}
