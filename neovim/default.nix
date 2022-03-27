{ config, pkgs, ... }:
{
  home.sessionVariables = { EDITOR = "nvim"; };
  home.packages = with pkgs; [
    neovim
  ];
  xdg.configFile = {
    "nvim/init.lua".source = ./init.lua;
  };
}
