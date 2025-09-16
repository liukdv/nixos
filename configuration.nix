# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
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
	firefox
	keyd
	vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	wget
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
  system.stateVersion = "25.05"; # Did you read the comment?

}
