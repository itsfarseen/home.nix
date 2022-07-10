{
  description = "Home Manager configuration of Farseen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    dml-urwid.url = "github:itsfarseen/burns-mood-log-urwid";
  };

  outputs = { self, home-manager, ... }:
    let 
      system = "x86_64-linux";
      username = "farseen";
      overlays = [
        self.inputs.neovim-nightly-overlay.overlay
        (prev: final: rec {
            dml = self.inputs.dml-urwid.packages.${system}.default;
        })
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


      
