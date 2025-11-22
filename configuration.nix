{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./gnome.nix
      ./keyd.nix
      ./home/bash.nix
      ./home/git.nix
      ./docker.nix
      ./inspiron-gnome-nvidia.nix
      #./fixdell.nix
      #./nvidia.nix
    ];

  # enable firmware updates 
  services.fwupd.enable = true; # sudo fwupdmgr refresh | sudo fwupdmgr get-updates | sudo fwupdmgr update
  
  # Bootloader - systemd
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; 
  # Enable swap and hibernation
  swapDevices = [{ device = "/dev/disk/by-uuid/baad3773-1ae7-48f0-9cda-099ebe80d246"; }];
  boot.kernelParams = [ "resume=UUID=baad3773-1ae7-48f0-9cda-099ebe80d246" ];
  #boot.resumeDevice = "/dev/disk/by-uuid/baad3773-1ae7-48f0-9cda-099ebe80d246";
  #systemd.services."systemd-hibernate-resume".enable = true;  # not sure

  #Enable GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  #Hostname & networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
  
  # Enable wayland
  services.xserver.displayManager.gdm.wayland = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment -> done in imported file!
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # System utilities
  bind
  efibootmgr
  gparted
  keyd
  libnotify
  piper
  qmk
  solaar
  traceroute
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
  calibre
  handbrake
  libreoffice
  mpv
  obs-studio
  obsidian
  speedcrunch
  vlc
  xournalpp

  # Internet & communication
  amule
  discord
  firefox
  google-chrome
  protonvpn-gui
  spotify
  telegram-desktop

  # Gaming
  steam

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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Java
  programs.java = {
    enable = true;
    # Puoi specificare la versione del pacchetto da usare per JAVA_HOME (opzionale)
    # package = pkgs.jdk; 
  };
  
  # Enable Nix-LD to run unpatched dynamic binaries (Fixes Gemini/VS Code extensions)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib  # libstdc++
    zlib
    openssl
    glib
    curl
    icu
    ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; 

}

