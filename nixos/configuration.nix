{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      #./gnome.nix
      ./plasma.nix
      ./keyd.nix
      ./home/bash.nix
      ./home/git.nix
      ./docker.nix
      ./inspiron-nvidia.nix
      #./nvidia.nix
      ./geforcenow.nix
    ];

  # enable firmware updates 
  services.fwupd.enable = true; # sudo fwupdmgr refresh | sudo fwupdmgr get-updates | sudo fwupdmgr update
  
  # Bootloader
  # systemd
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true; 
  
  # grub 
  boot.loader = {
    grub = { 
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true; # to see Windows in grub 
      efiInstallAsRemovable = true; # Dell needed setting (?)
    };
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
  }; 
 
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/4A8B-84AD";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
 
  # Enable swap and hibernation
  swapDevices = [{ device = "/dev/disk/by-uuid/baad3773-1ae7-48f0-9cda-099ebe80d246"; }];
  boot.kernelParams = [ "resume=UUID=baad3773-1ae7-48f0-9cda-099ebe80d246" ];
  #boot.resumeDevice = "/dev/disk/by-uuid/baad3773-1ae7-48f0-9cda-099ebe80d246";
  #systemd.services."systemd-hibernate-resume".enable = true;  # not sure

  # Enable GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # Hostname & networking
  networking.hostName = "liukdv-dellG-nixos";
  networking.networkmanager.enable = true;
  
  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Bluetooth
  services.blueman.enable = true;        # optional, GUI manager
  hardware.bluetooth.enable = true;      # enables Bluetooth support

  # Logitech mouse
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
  # Enable ratbagd service for Piper
  services.ratbagd.enable = true;  

  # Set your time zone / Locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };
  
  # Enable GNOME/PLASMA DE -> done in imported file!

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.liukdv = {
    isNormalUser = true;
    description = "liukdv";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  # To search$: nix search wget
  environment.systemPackages = with pkgs; [
  # System utilities
  appimage-run
  bind
  efibootmgr
  gparted
  keyd
  libnotify
  libva-utils
  piper
  qmk
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
  #docker
  git
  google-cloud-sdk-gce
  kubectl
  jdk
  minikube
  nix-prefetch-git
  neovim
  ollama
  podman
  podman-compose
  postman
  python311
  rustc
  terraform
  uv
  vim
  vscode
  wl-clipboard

  # Hacker
  trufflehog
  sherlock

  # Media & productivity
  audacity
  audio-recorder
  calibre
  handbrake
  libreoffice
  mpv
  obs-studio
  obsidian
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
  protonvpn-gui
  spotify
  telegram-desktop

  # Gaming - steam enabled with dedicated part
  #gfn-electron
  #steam
  #steam-run

  # Virtualization
  virtualbox

  # Work
  teams-for-linux
  ];
  
     
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Disable ipv6 temporally for gaming
  #networking.enableIPv6 = false;


  # Java
  programs.java = {
    enable = true;
    # Puoi specificare la versione del pacchetto da usare per JAVA_HOME (opzionale)
    # package = pkgs.jdk; 
  };
  
  # Run unpatched dynamic binaries
  programs.nix-ld.libraries = with pkgs; [
    # Gemini/VS Code extensions)
    stdenv.cc.cc.lib  # libstdc++
    zlib
    openssl
    glib
    curl
    icu
    ];

  # Enable flakes and ld
  programs.nix-ld.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. Recommended to leave this value at the first install of this system.
  system.stateVersion = "25.05"; 
}

