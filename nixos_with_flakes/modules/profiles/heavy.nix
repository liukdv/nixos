 # ~/Documents/mine/configs/nix/nixos_with_flakes/modules/profiles/heavy.nix
{ config, pkgs, lib, ... }:

{
  # Podman is imported here so this profile can be shared.
  imports =
    [
      ../programs/podman.nix
    ];

  # List packages installed in system profile
  # To search: nix search nixpkgs wget || nix-locate bin/wget
  environment.systemPackages = with pkgs; [
  # System utilities
  appimage-run
  bind
  efibootmgr
  ffmpeg
  libcamera
  libva-utils
  mesa-demos
  pciutils
  piper
  traceroute
  unetbootin
  wev

  # Development tools
  azure-cli
  cargo
  dbeaver-bin
  distrobox
  #docker
  gcc-arm-embedded
  google-cloud-sdk-gce
  kubectl
  jdk
  minikube
  nodejs
  ollama
  rustc
  terraform

  # Hacker
  trufflehog
  sherlock
  angryipscanner

  # Media & productivity
  audacity
  handbrake
  obs-studio
  reco
  shotcut

  # Internet & communication
  amule
  brave
  chromium
  google-chrome
  proton-vpn
  yt-dlp

  # Virtualization
  #virtualbox
  qemu
  quickemu
  virt-manager

  # Work
  teams-for-linux
  ];

  # Java
  programs.java = {
    enable = true;
    # specific version if needed
     #package = pkgs.jdk;
  };

  # Disable ipv6 temporally for gaming
  #networking.enableIPv6 = false;
}
