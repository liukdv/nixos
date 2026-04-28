# /etc/nixos/keyd.nix
{ config, pkgs, ... }:

{
  #users.groups.keyd = {};

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          capslock = "layer(extend)";

          # Both shift keys together toggle Caps Lock
          leftshift = "leftshift";
          rightshift = "rightshift";
          "leftshift+rightshift" = "capslock";
        };

        extend = {
          # ---------- Number Row: becomes F1-F12 ----------
          "1" = "f1";
          "2" = "f2";
          "3" = "f3";
          "4" = "f4";
          "5" = "f5";
          "6" = "f6";
          "7" = "f7";
          "8" = "f8";
          "9" = "f9";
          "0" = "f10";
          equal = "f11";
          escape = "f12";

          # ---------- LEFT Colemak-intended combos (translated to QWERTY keys) ----------
          q = "escape";
          w = "C-S-z";
          e = "back";       # Colemak 'f'
          r = "forward";    # Colemak 'p'
          t = "S-tab";      # Colemak 'g'

          a = "layer(alt)";
          s = "layer(control)"; # Colemak 'r'
          d = "layer(shift)";   # Colemak 's'
          f = "layer(meta)";    # Colemak 't'
          g = "tab";            # Colemak 'd'

          z = "C-z";
          x = "C-x";
          c = "C-c";
          v = "C-v";
          b = "enter";

          # ---------- RIGHT Colemak-intended combos ----------
          i = "up";
          k = "down";
          j = "left";
          l = "right";
          y = "pageup";
          h = "pagedown";
          u = "home";
          o = "end";

          # Text editing
          semicolon = "backspace";
          p = "delete";
        };
      };
    };
  };
}
