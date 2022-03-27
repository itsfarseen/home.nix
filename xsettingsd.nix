{ config, pkgs, ... }:
{
  services.xsettingsd.enable = true;
  services.xsettingsd.settings = {
    "Xft/Antialias" = true;
    "Xft/Hinting" = true;
    "Xft/RGBA" = "rgb";
    "Xft/DPI" = 120000;
  };
}
