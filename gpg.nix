{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };
  home.packages = [ pkgs.kleopatra ];
}
