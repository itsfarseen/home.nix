{ config, pkgs, ... }:
{
  programs.bash.enable = true;
  programs.fish.enable = true;

  programs.fzf.enable = true;
  programs.starship.enable = true;

  programs.z-lua.enable = true;
  home.shellAliases = { 
    "zc" = "z -c"; # z but only under $PWD
    "zt" = "z -t"; # recent instead of frecent
    "zb" = "z -b"; # search backwards
    "zg" = "zb; zc"; # search under vcs root
  }; 
}

