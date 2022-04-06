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
    ./dev.nix
    ./xsettingsd.nix
    ./i3.nix
    ./sxhkd.nix
    ./mold.nix
    ./nix-direnv.nix
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
  programs.starship.enable = true;
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

  home.packages = with pkgs; [
    acpilight
    discord
    slack
    tdesktop
    chromium
    firefox
    spotify
    ytmdesktop
    libreoffice
    keepassxc
    pcmanfm
    ferdi
    flameshot
    yt-dlp
    # 
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

  home.shellAliases = {
    vim = "nvim";
    gst = "git status";
    gcv = "git commit -v";
    gps = "git push";
    gpl = "git pull";
    hms = "home-manager switch";
    nxsw = "sudo nixos-rebuild switch";
    nxs = "nix search nixpkgs";
  };

  services.parcellite.enable = true;
  services.poweralertd.enable = true;
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
