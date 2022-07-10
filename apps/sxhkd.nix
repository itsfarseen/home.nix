{ config, pkgs, ... }:
let
  writeShellScript = binary: contents: 
    let pkg = pkgs.writeShellScriptBin binary contents;
    in "${pkg}/bin/${binary}";
  cycle-monitor = writeShellScript "cycle-monitor" ''
      XRANDR_OUTPUT=$(xrandr | grep '\<connected')
      CONNECTED=$(echo "$XRANDR_OUTPUT" | grep mm | cut -d' ' -f 1 | head -n 1)
      DISCONNECTED=$(echo "$XRANDR_OUTPUT" | grep -v mm | cut -d' ' -f 1 | head -n 1)
      xrandr --output $CONNECTED --off --output $DISCONNECTED --auto
  '';
in {
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
      "super + p" = "${cycle-monitor}";
      "super + s" = "flameshot gui";
      "{XF86KbdBrightnessDown, XF86KbdBrightnessUp}" = "asusctl {-p,-n}";
    };
  };
}
