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
  file
  gparted
  libcamera
  libnotify
  libva-utils
  jq
  keyd
  mesa-demos
  pciutils
  piper
  qmk
  ripgrep
  solaar
  traceroute
  tree
  unetbootin
  wev
  whois
  wget
  
  # Development tools
  azure-cli
  cargo
  dbeaver-bin
  distrobox
  #docker
  emacs
  gh
  git
  google-cloud-sdk-gce
  kiro
  kubectl
  jdk
  meld
  minikube
  nix-prefetch-git
  neovim
  nodejs
  ollama
  #podman
  #podman-compose
  postman
  python314 
  rustc
  terraform
  uv
  vim
  vscode.fhs
  wl-clipboard

  # Hacker
  trufflehog
  sherlock
  angryipscanner

  # Media & productivity
  audacity
  calibre
  handbrake
  libreoffice
  mpv
  obs-studio
  obsidian
  reco
  shotcut
  speedcrunch
  vlc
  xournalpp

  # Internet & communication
  amule
  brave
  chromium
  discord
  firefox
  google-chrome
  proton-vpn
  spotify
  telegram-desktop

  # Gaming - steam enabled with dedicated part
  #gfn-electron
  #steam
  #steam-run

  # Virtualization
  #virtualbox
  qemu
  quickemu
  virt-manager

  # Test 
  #sl

  # Work
  teams-for-linux
  ];
    
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Java
  programs.java = {
    enable = true;
    # specific version if needed
     #package = pkgs.jdk; 
  };

  # Disable ipv6 temporally for gaming
  #networking.enableIPv6 = false;
}
