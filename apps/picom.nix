{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;
    experimentalBackends = true;
    shadow = true;
    shadowOffsets = [ (-9) (-8) ];
    shadowOpacity = "0.3";
    menuOpacity = "0.95";
    extraOptions = ''
      shadow-radius = 10;
      glx-no-stencil = true;

      opacity-rule = [
        "99:!focused",
        "100:focused",
      ];

      fading = true;
      fade-delta = 4;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
    '';
  };
}
