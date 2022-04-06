{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = ./rofi.rasi;
    extraConfig = {
      modi = "drun,ssh";
    };
  };
}

