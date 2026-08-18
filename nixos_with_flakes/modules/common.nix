{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./desktop/plasma.nix
      ./programs/bash.nix
      ./programs/git.nix
      ./programs/keyd.nix
    ];

  # enable firmware updates
  services.fwupd.enable = true; # sudo fwupdmgr refresh | sudo fwupdmgr get-updates | sudo fwupdmgr update

  # Folder /tmp settings - decided to leave default 10d
  #boot.tmp = {
    #useTmpfs = false;
    #cleanOnBoot = true;
  #};

  # Hostname & networking
  networking.networkmanager.enable = true;

  # Disable modem/LTE function
  networking.modemmanager.enable = false;

  # Configure network proxy if necessary
  #networking.proxy.default = "http://user:password@proxy:port/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  # Enable CUPS to print and colors
  services.printing.enable = true;
  services.colord.enable = true;
  # Add Brother printer drivers
  services.printing.drivers = [ pkgs.brlaser ];

  # SANE to scan documents
  #hardware.sane.enable = true;
  #hardware.sane.brscan4.enable = true;

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
  #services.xserver.libinput.enable = true;

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
  # To search: nix search nixpkgs wget || nix-locate bin/wget
  environment.systemPackages = with pkgs; [
  # System utilities
  file
  gparted
  jq
  libnotify
  ripgrep
  tree
  wget
  keyd
  qmk
  whois

  # Development tools
  gh
  git
  gnumake
  neovim
  python314
  vim
  wl-clipboard
  emacs
  meld
  nix-prefetch-git
  postman
  uv
  vscode.fhs

  # Media & productivity
  mpv
  speedcrunch
  xournalpp
  calibre
  libreoffice
  obsidian
  vlc

  # Internet & communication
  firefox
  discord
  spotify
  telegram-desktop

  # Gaming - steam enabled with dedicated part
  #gfn-electron
  #steam
  #steam-run

  # Test
  #sl
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
     #enable = true;
     #enableSSHSupport = true;
   #};

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  programs.direnv = {
   enable = true;
   nix-direnv.enable = true;
  };

  # Enable nix-locate; this provides the 'nix-locate' command and a database of all packages.
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;

  # Enable flakes and ld loader for dynamic binaries
  programs.nix-ld.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable Flatpak {geforcenow; ;}
  # manual update with flatpak update!
  services.flatpak.enable = true;

  # Keep a copy of this configuration.nix in the system build
  # This option is disabled because system.copySystemConfiguration cannot be used with flakes.
  #system.copySystemConfiguration = true;

  # Optimize space
  # remove duplicate files through hard links
  nix.settings.auto-optimise-store = true;

  # garbage collector at 03:15 only unused packages
  #nix.gc.automatic = true;
}
