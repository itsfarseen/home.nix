{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        dynamic_padding = true;
        dynamic_title = true;
        opacity = 1.0;
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        size = 13;
        normal.family = "Iosevka";
      };
      key_bindings = [
        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
      ];
      colors = {
          primary = {
            background = "0x24283b";
            foreground = "0xc0caf5";
          };
          # Normal colors
          normal = {
            black =   "0x1D202F";
            red =     "0xf7768e";
            green =   "0x9ece6a";
            yellow =  "0xe0af68";
            blue =    "0x7aa2f7";
            magenta = "0xbb9af7";
            cyan =    "0x7dcfff";
            white =   "0xa9b1d6";
          };
          # Bright colors
          bright = {
            black =   "0x414868";
            red =     "0xf7768e";
            green =   "0x9ece6a";
            yellow =  "0xe0af68";
            blue =    "0x7aa2f7";
            magenta = "0xbb9af7";
            cyan =    "0x7dcfff";
            white =   "0xc0caf5";
          };

          indexed_colors = [
            { index = 16; color = "0xff9e64"; }
            { index = 17; color = "0xdb4b4b"; }
          ];
      };
    };
  };
}

