{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    inconsolata-nerdfont
    iosevka-bin
    font-awesome_4
    open-sans
    public-sans
  ];
}
