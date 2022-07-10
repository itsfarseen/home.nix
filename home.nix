{ config, pkgs, ... }:

let
  #nixpkgs_unstable = import <nixpkgs-unstable> {};
  #pkgsx = nixpkgs_unstable.pkgs;
in { imports = [
    ./shells.nix
    ./aliases.nix
    ./packages.nix
    #
    ./fonts.nix
    ./dev.nix
    ./xsettingsd.nix
    ./mold.nix
    # ./lld.nix
    ./nix-direnv.nix
    ./themes.nix
    ./mime.nix
    #./sccache.nix
    ./gpg.nix
    # apps
    ./apps/alacritty.nix 
    ./apps/i3.nix
    ./apps/polybar.nix
    ./apps/neovim
    ./apps/rofi
    ./apps/sxhkd.nix
    ./apps/picom.nix
    ./apps/tmux.nix
    ./apps/git.nix
    ./apps/deadd-notification-center
  ];

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "farseen";
  home.homeDirectory = "/home/farseen";

  programs.jq.enable = true;

  xdg.configFile = {
    "discord/settings.json" = {
      force = true;
      text = ''
        {
          "SKIP_HOST_UPDATE": true
        }
      '';
    };
  };

  services.parcellite.enable = true;
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  home.packages = [ pkgs.poweralertd ];
  services.poweralertd.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
