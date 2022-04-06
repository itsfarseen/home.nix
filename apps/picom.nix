{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;
    experimentalBackends = true;
    shadow = true;
    shadowOffsets = [ (-9) (-8) ];
    shadowOpacity = "0.3";
    #blur = true;
    menuOpacity = "0.95";
    extraOptions = ''
      #corner-radius = 10.0;
      shadow-radius = 10;
      # blur-method = "dual_kawase";
      # blur-strength = 10;
      glx-no-stencil = true;

      opacity-rule = [
        "98:class_g = 'Code'",
        "98:class_g = 'Alacritty'"
      ];

      rounded-corners-exclude = [
        "class_g = 'Polybar'"
      ];
    '';
  };
}
