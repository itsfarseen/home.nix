{ config, pkgs, ... }:
{
  services.sxhkd = {
    enable = true;

    keybindings = {
      "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ +3dB";
      "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ -3dB";
      "super + {Escape,F1,F2}" = "xbacklight {-set 0.06,-5,+5}";
      "Print" = "flameshot gui";
      "super + Return" = "alacritty";
      "super + e" = "pcmanfm";
      "super + w" = "chromium";
      "super + d" = "rofi -show drun -show-icons";
      "super + F3" = "pavucontrol";
    };
  };
}
