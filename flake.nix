{
  description = "Home Manager configuration of Farseen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, home-manager, ... }:
    let 
      system = "x86_64-linux";
      username = "farseen";
      overlays = [
        self.inputs.neovim-nightly-overlay.overlay
      ];
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        configuration = { config, pkgs, ... }: 
        {
          nixpkgs.overlays = overlays;
          imports = [ ./home.nix ];
        };
        inherit system username;
        homeDirectory = "/home/${username}";

        stateVersion = "21.11";
      };
    };
}


      
