{ config, pkgs, ... }:
{ home.packages = with pkgs; [
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
  ];
}
