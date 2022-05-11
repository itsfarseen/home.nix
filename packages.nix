{ config, pkgs, ... }:
{
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
    wtf
    vscode
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

}
