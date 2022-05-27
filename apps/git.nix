{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    userName = "Farseen";
    userEmail = "oss@itsfarseen.anonaddy.me";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
