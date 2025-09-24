# /etc/nixos/keyd.nix
{ config, pkgs, ... }:

{

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
}
