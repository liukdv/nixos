# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.dev-machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.developer = {
            # Development packages
            home.packages = with pkgs; [
              vscode
              docker
              nodejs
            ];

            # Git configuration
            programs.git = {
              enable = true;
              userName = "Developer";
              userEmail = "dev@company.com";
            };

            # Shell with custom prompt
            programs.zsh = {
              enable = true;
              oh-my-zsh.enable = true;
              oh-my-zsh.theme = "robbyrussell";
            };
          };
        }
      ];
    };
  };
}
