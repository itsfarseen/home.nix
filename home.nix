{ config, pkgs, ... }:

let
  #nixpkgs_unstable = import <nixpkgs-unstable> {};
  #pkgsx = nixpkgs_unstable.pkgs;
in {
  imports = [
    ./alacritty.nix 
    ./fonts.nix
    ./picom.nix
    ./neovim
    ./polybar.nix
    ./haskell.nix
    ./xsettingsd.nix
    ./i3.nix
    ./sxhkd.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "farseen";
  home.homeDirectory = "/home/farseen";

  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.z-lua.enable = true;
  programs.jq.enable = true;
  programs.fzf.enable = true;
  programs.tmux = {
    enable = true;
  };
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    userName = "Farseen";
    userEmail = "oss@itsfarseen.anonaddy.me";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # programs.neovim = {
  #   enable = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  # };

  # nixpkgs.overlays = [
  #   (self: super: {
  #     chromium = super.chromium.override {
  #       commandLineArgs = [ "--ozone-platform-hint=auto" ];
  #     };
  #   })
  # ];

  home.packages = with pkgs; [
    discord
    slack
    chromium
    firefox
    spotify
    sumneko-lua-language-server
    libreoffice
    keepassxc
    pcmanfm
    # 
    gcc
    moreutils # sponge
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        "text-scaling-factor" = 1.25;
      };
    };
  };


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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
