{ config, pkgs, ... }:

let
  #nixpkgs_unstable = import <nixpkgs-unstable> {};
  #pkgsx = nixpkgs_unstable.pkgs;
in {
  imports = [
    ./apps/alacritty.nix 
    ./apps/i3.nix
    ./apps/polybar.nix
    ./apps/neovim
    ./apps/rofi
    ./apps/sxhkd.nix
    ./apps/picom.nix
    ./fonts.nix
    ./dev.nix
    ./xsettingsd.nix
    ./mold.nix
    ./nix-direnv.nix
    ./themes.nix
    ./mime.nix
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
    pinta
    gimp
    # 
    moreutils # sponge
    # 
    gnome.eog
    gnome.file-roller
    evince
    pulseaudio
    # 
    imagemagick
    ghostscript
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
    gce = "git commit --amend";
    gps = "git push";
    gpl = "git pull";
    gd = "git diff";
    gds = "git diff --staged";
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
