# /etc/nixos/home/bash.nix
{ config, pkgs, ... }:

{
  programs.bash = {
    # Enable programmable completion (tab completion for commands)
    completion.enable = true;
    
    # System-wide aliases available to all users
    shellAliases = {
      # Enhanced ls commands
      ll = "ls -alF";    # Long format + all files + classify file types (/ for dirs, * for executables)
      la = "ls -A";      # List all files except . and .. (includes hidden files)
      l  = "ls -CF";      # Column format + classify file types
      
      # Navigation shortcuts
      c = "cd";              # Shorter cd command
      cn = "cd /etc/nixos/"; # Quick jump to NixOS configuration directory
      
      # Clear shortcut
      cl = "clear";

      # Sudo shortcut
      s = "sudo";  # Because typing sudo gets old fast
      
      # Power managment
      shutdown="systemctl poweroff";
      #hibernate="systemctl hibernate";
      restart="systemctl reboot";
      shutdowni="systemctl poweroff -i";
      #hibernatei="systemctl hibernate -i";
      restarti="systemctl reboot -i";

      lock="xdg-screensaver lock";

      # Text editor
      text="gnome-text-editor";
      stext="sudo gnome-text-editor";
      snvim="sudo -E nvim";

      # Network utility - get your public IP address
      publicip = "dig +short myip.opendns.com @resolver1.opendns.com";
      # Uses DNS query to OpenDNS to get external IP (faster than curl to web services)
      
      # System maintenance commands
      sysupdate = "sudo nixos-rebuild switch --upgrade && sudo nix-collect-garbage";
      # Rebuild NixOS system and clean up unreferenced packgs to save disk space
      sysupdatewipe = "sudo nixos-rebuild switch --upgrade && sudo nix-collect-garbage -d && sudo nixos-rebuild boot";       
      # Same but wipes old NixOS generations
      
      # Desktop notification for long-running commands
      alert = "notify-send --urgency=low -i \"$([ $? = 0 ] && echo terminal || echo error)\" \"$(history|tail -n1|sed -e 's/^[[:space:]]*[0-9]\\+[[:space:]]*//;s/[;&|]\\s*alert$//')\"";
      # Usage: long-command; alert
      # Shows desktop notification with success/failure icon and the command that just ran
    };
   };
     environment.sessionVariables = {    
      # ===== HISTORY CONFIGURATION =====
      # Control what gets saved to history
      HISTCONTROL="ignoreboth";
      # ignoreboth = ignorespace + ignoredups
      # ignorespace: don't save commands starting with space (for sensitive commands)
      # ignoredups: don't save duplicate consecutive commands
      
      HISTSIZE="5000";        # Keep 5000 commands in memory during session
      HISTFILESIZE="500000";    # Keep 500000 commands in ~/.bash_history file
      
     
      
      # ===== CUSTOM COLORED PROMPT =====
      # Format: username@hostname:/current/path$ 
      # Colors: green for user@host, blue for path, reset to normal for $
      PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ]";
      # \[\033[01;32m\] = bright green
      # \u = username
      # @ = literal @
      # \h = hostname
      # \[\033[00m\] = reset color
      # : = literal colon
      # \[\033[01;34m\] = bright blue  
      # \w = current working directory
      # \$ = $ for regular user, # for root
      
      # ===== COMPILER OUTPUT COLORS =====
      # Make GCC/G++ error messages colorized for easier reading
      GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      # error=01;31    = bright red for errors
      # warning=01;35  = bright magenta for warnings  
      # note=01;36     = bright cyan for informational notes
      # caret=01;32    = bright green for error location carets (^)
      # locus=01       = bright white for file:line:column locations
      # quote=01       = bright white for quoted code sections
    };  
    # Shell initialization commands
    environment.shellInit = ''
      # Additional bash configuration that goes into /etc/bashrc
      
       # ===== SHELL BEHAVIOR OPTIONS =====
      shopt -s histappend    # Append to history file instead of overwriting it
                            # Prevents losing history when multiple terminals are open

      shopt -s checkwinsize  # Update LINES and COLUMNS variables after each command
                            # Fixes display issues when terminal is resized

      shopt -s globstar     # Enable ** recursive globbing (bash 4.0+)
                           # Allows: ls **/*.txt (find all .txt files recursively)
      '';
  
  # ===== SYSTEM-WIDE ENVIRONMENT VARIABLES =====
  # These are available to all programs, not just bash
  environment.variables = {
    # Same GCC colors, but available to all shells and programs
    GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
  };

  # Add directories to the user's PATH - useless / to change
  #home.sessionPath = [
    #"$HOME/.cargo/bin"
    #"$HOME/.local/bin"
  #];

  # Configure pyenv using the dedicated Home-Manager module - useless / to change
  #programs.pyenv.enable = true;
}
