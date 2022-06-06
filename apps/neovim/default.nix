{ config, pkgs, ... }:
{
  home.sessionVariables = { EDITOR = "nvim"; };
  home.packages = with pkgs; [
    neovim
  ];
  xdg.configFile = {
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink (builtins.toString ./init.lua);
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink (builtins.toString ./lua);
  };
}
