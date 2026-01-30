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

        # Both shift keys together toggle Caps Lock
        leftshift = "leftshift";
        rightshift = "rightshift";
        "leftshift+rightshift" = "capslock";

        };
      extend = {
        # ---------- Number Row: becomes F1-F12 ----------
        "1" = "f1"; "2" = "f2"; "3" = "f3"; "4" = "f4"; "5" = "f5"; "6" = "f6"; "7" = "f7"; "8" = "f8"; "9" = "f9"; "0" = "f10";
        equal = "f11";
        escape = "f12";

        # ---------- Media & system ----------
        #f1 = "playpause"; f2 = "prev"; f3 = "next"; f4 = "stop";
        #f5 = "mute"; f6 = "volumedown"; f7 = "volumeup";
        #f8 = "brightnessdown"; f9 = "brightnessup";
        #f11 = "www"; f12 = "mail";

        # ---------- LEFT Colemak-intended combos (translated to QWERTY keys) ----------
        q = "escape";      
        w = "C-S-z";       
        e = "back";		# Colemak 'f'
        r = "forward";		# Colemak 'p'
        t = "S-tab"; 		# Colemak 'g' 
        
        a = "leftalt";		
        s = "leftcontrol";	# Colemak 'r'
        d = "leftshift"; 	# Colemak 's'
        f = "leftmeta";		# Colemak 't'
        g = "tab";		# Colemak 'd'

        z = "C-z";
        x = "C-x";
        c = "C-c";
        v = "C-v";
        b = "enter";
    
        # ---------- RIGHT Colemak-intended combos
        # Navigation & editing (kept where non-conflicting) 
        i = "up"; k = "down"; j = "left"; l = "right";
        y = "pageup"; h = "pagedown"; u = "home"; o = "end";
        # s = "down";   w = "up"                                   # mouse down/up?

        # Text editing
        semicolon = "backspace"; 
        p = "delete";
        # space = "backspace";
        
        # Browser / tab management
        # m = "refresh"; comma = "C-S-tab"; dot = "C-tab";
        
        # Special keys
        # pause = "mycomputer"; printscreen = "calculator";
        # enter = "printscreen"; leftbrace = "mycomputer";
        # apostrophe = "menu"; slash = "compose";
      };
    };
   };
  };

}
