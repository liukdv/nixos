# ~/Documents/mine/configs/nix/nixos_with_flakes/modules/programs/keyd.nix
{ config, pkgs, ... }:

{

  #users.groups.keyd = {};

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "0d62:3740" ];

      settings = {
        main = {
	  # Capslock enables extend layer
          capslock = "layer(extend)";
          enter = "overload(numpad, enter)";

	  # Both Shift keys together toggle Caps Lock - enabled in kde keyboard settings options
          leftshift = "leftshift";
          rightshift = "rightshift";
          #"leftshift+rightshift" = "capslock";
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
          x = "backspace";
          c = "escape";
          v = "delete";
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

          n = "S-grave";
          m = "volumedown";
          comma = "playpause";
          dot = "volumeup";
          slash = "mute";
        };

        numpad = {
          q = "apostrophe";
          w = "S-apostrophe";
          e = "minus";
          r = "S-equal";
          t = "S-tab";

          a = "layer(alt)";
          s = "layer(control)";
          d = "layer(shift)";
          f = "layer(meta)";
          g = "tab";

          z = "grave";
          x = "backspace";
          c = "escape";
          v = "delete";
          b = "enter";

          y = "S-8";
          u = "7";
          i = "8";
          o = "9";
          p = "backslash";
          minus = "G-5";

          h = "0";
          j = "4";
          k = "5";
          l = "6";
          semicolon = "equal";

          n = "dot";
          m = "1";
          comma = "2";
          dot = "3";
          slash = "slash";
        };

        # Nix sorts section names; composite layers must follow both components.
        "numpad+extend" = {
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
          equal = "equal";
          escape = "escape";

          q = "escape";
          a = "layer(alt)";
          s = "layer(control)";
          d = "layer(shift)";
          f = "layer(meta)";
          g = "insert";
          b = "sysrq";
          leftbrace = "A-f4";

          y = "f11";
          u = "f7";
          i = "f8";
          o = "f9";
          p = "f12";
          minus = "minus";

          h = "f10";
          j = "f4";
          k = "f5";
          l = "f6";
          semicolon = "brightnessup";

          n = "C-w";
          m = "f1";
          comma = "f2";
          dot = "f3";
          slash = "brightnessdown";

          # Avoid inheriting Extend/Numpad actions for firmware-specific keys.
          w = "w";
          e = "e";
          r = "r";
          t = "t";
          z = "z";
          x = "x";
          c = "c";
          v = "v";
        };
      };
    };
  };
}
