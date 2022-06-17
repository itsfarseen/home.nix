{ config, pkgs, ... }:
let
  when-cli = pkgs.rustPlatform.buildRustPackage {
    name = "when-cli";
    cargoSha256 = "YWTE/t1mrSQ1AmjH3ZXObDQMIC6oIdOAeIKkrKPHgIE=";
    # Using this build support function to fetch it from github
    src = pkgs.fetchFromGitHub {
      owner = "mitsuhiko";
      repo = "when";
      # The git tag to fetch
      rev = "4cc12ce4dcd5f1a155ecb866c70809b2332b5172";
      # Hashes must be specified so that the build is purely functional
      sha256 = "AKBbfSHvEeRC2F7jBQLobAi5olXqAUyukKOkYcr25zo=";
      fetchSubmodules = true;
    };
    nativeBuildInputs = [ pkgs.cargo ];
  };
in { 
  home.packages = with pkgs; [
    acpilight
    discord
    tdesktop
    chromium
    firefox
    spotify
    libreoffice
    keepassxc
    pcmanfm
    flameshot
    yt-dlp
    pinta
    gimp
    inkscape
    wtf
    vscode
    tealdeer
    # 
    moreutils # sponge
    lxrandr
    # 
    gnome.eog
    gnome.file-roller
    evince
    pulseaudio
    # 
    imagemagick
    ghostscript
    #
    smplayer
    vlc
    mplayer
    mpv
    #
    when-cli
  ];
}
