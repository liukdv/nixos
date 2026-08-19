{ ... }:

{
  home.username = "liukdv";
  home.homeDirectory = "/home/liukdv";
  home.stateVersion = "26.05";

  home.packages = [ ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;

      merge.ours = {
        driver = true;
        name = "Keep our version during merge";
      };
    };
  };
}
