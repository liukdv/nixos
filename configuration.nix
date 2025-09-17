{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname & networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Locale
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

  # Enable X11 + KDE Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  # Printing
  services.printing.enable = true;

  # Sound (PipeWire instead of PulseAudio)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.luca = {
    isNormalUser = true;
    description = "luca";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    amule calibre discord firefox gedit git google-chrome gparted handbrake
    kdePackages.kate keyd libreoffice-qt6-fresh mpv obsidian obs-studio speedcrunch
    spotify solaar steam telegram-desktop vim vscode xournalpp wget
  ];

  # key mapping
  services.keyd = {
   enable = true;
   keyboards.default = {
    ids = [ "*" ];
    settings = {
      main = {
        capslock = "layer(extend)";
      };
      extend = {
        # ---------- Number Row: becomes F1-F12 ----------
        # grave = "f1";
        "1" = "f1"; "2" = "f2"; "3" = "f3"; "4" = "f4"; "5" = "f5"; "6" = "f6"; "7" = "f7"; "8" = "f8"; "9" = "f9"; "0" = "f10";
        minus = "f11";
        equal = "f12";

        # ---------- Colemak-intended combos (translated to QWERTY keys) ----------
        a = "leftalt";     # Colemak 'a'
        d = "leftshift";   # Colemak 's'
        f = "ctrl";    # Colemak 't'
        q = "escape";      # Colemak 'q'
        e = "back";        # Colemak 'f'
        r = "forward";     # Colemak 'p'
        w = "C-S-z";         # Colemak 'w'
        z = "C-z";         # Colemak 'z'

        # ---------- Navigation & editing (kept where non-conflicting) ----------
        i = "up"; k = "down"; j = "left"; l = "right";
        # s = "down";   w = "up"                                   # mouse down/up?
        y = "pageup"; h = "pagedown"; u = "home"; o = "end";


        # Text editing
        # [ = "escape;
        semicolon = "backspace"; p = "delete";
        space = "backspace";

        # Clipboard
        x = "C-x"; c = "C-c"; v = "C-v";

        # Browser / tab management
        # b = "back"; n = "forward"; m = "refresh";
        # comma = "C-S-tab"; dot = "C-tab";

        # Media & system
        f1 = "playpause"; f2 = "prev"; f3 = "next"; f4 = "stop";
        f5 = "mute"; f6 = "volumedown"; f7 = "volumeup";
        f8 = "brightnessdown"; f9 = "brightnessup";
        f10 = "sleep"; f11 = "www"; f12 = "mail";

        # Special keys
        pause = "mycomputer"; printscreen = "calculator";
        enter = "printscreen"; leftbrace = "mycomputer";
        apostrophe = "menu"; slash = "compose";
      };
    };
   };
  };
  # end keymapping

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # State version
  system.stateVersion = "25.05";
}
