# /etc/nixos/home/git.nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # Git configuration
    config = {
      user = {
        name = "liukdv";
        
      };

      # Ask password once and then store it
      credential.helper = "store";
      
      # Optional but useful settings
      init.defaultBranch = "main";  # Use 'main' instead of 'master'
      pull.rebase = false;           # Use merge strategy for pulls
    
      # Custom merge driver: always keep "our" version
      merge.ours = {
        driver = true;
        name = "Keep our version during merge";
      };
	};
  };
}
