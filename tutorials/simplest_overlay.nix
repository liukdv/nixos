{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Let's add a popular CLI tool that's not in nixpkgs
    eza-src = {
      url = "github:eza-community/eza";  # Modern 'ls' replacement
      flake = false;  # Just source code
    };
  };

  outputs = { nixpkgs, eza-src, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{
        nixpkgs.overlays = [
          (final: prev: {
            eza-custom = final.rustPlatform.buildRustPackage {
              pname = "eza";
              version = "0.17.0";
              
              src = eza-src;
              
              cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
              # You'll need to run this once to get the real hash
              
              meta = with final.lib; {
                description = "A modern, maintained replacement for ls";
                homepage = "https://github.com/eza-community/eza";
                license = licenses.mit;
                platforms = platforms.unix;
              };
            };
          })
        ];
        
        # Now use your custom package
        environment.systemPackages = with pkgs; [
          eza-custom  # Your version from overlay
          # eza       # Official nixpkgs version (if it exists)
        ];
      }];
    };
  };
}
