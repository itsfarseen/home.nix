{ config, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    config = 
    let
      merge_list_of_cfgs = cfgs: builtins.foldl' (a: b: a//b) {} cfgs; 
      mod = "Mod4";
      workspace_switch_fn = ws: {
        "${mod}+${ws}" = "workspace number ${ws}";
        "${mod}+Shift+${ws}" = "move container to workspace number ${ws}; workspace number ${ws}";
        "${mod}+Ctrl+${ws}" = "move container to workspace number ${ws}";
      };
      workspace_switch_keybindings = merge_list_of_cfgs (map workspace_switch_fn (builtins.genList (x: toString (x+1)) 9));
    in {
      modifier = mod;
      floating.modifier = mod;

      keybindings = workspace_switch_keybindings // {
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Right" = "move right";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Up" = "focus up";
        "${mod}+Down" = "focus down";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+j" = "move down";
        "${mod}+h" = "focus left";
        "${mod}+l" = "focus right";
        "${mod}+k" = "focus up";
        "${mod}+j" = "focus down";

        "${mod}+v" = "split v";
        "${mod}+Shift+v" = "split h";

        "${mod}+f" = "fullscreen toggle";

        "${mod}+Comma" = "layout stacking";
        "${mod}+Period" = "layout tabbed";
        "${mod}+Slash" = "layout toggle split";

        "${mod}+Shift+Space" = "floating toggle";
        "${mod}+Space" = "focus mode_toggle";

        "${mod}+a" = "focus parent";
        "${mod}+Shift+a" = "focus child";

        "${mod}+Shift+s" = "sticky toggle";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'Logout?' -b 'Yes' 'i3-msg exit'";

        "${mod}+r" = "mode resize";

        "${mod}+q" = "kill";
        "${mod}+w" = "exec chromium";
        "${mod}+e" = "exec dolphin";
        "${mod}+Return" = "exec alacritty";
        "${mod}+d" = "exec dmenu_run";
      };

      modes = {
        resize = {
          Left = "resize shrink width";
          Right = "resize grow width";
          Down = "resize shrink height";
          Up = "resize grow height";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };

      startup = [ ];

      #smart_borders = "on";
      #smart_gaps = "inverse_order";
    };
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      # dpi
      export QT_AUTO_SCREEN_SCALE_FACTOR=0
      export QT_SCALE_FACTOR=1.25
      export ELM_SCALE=1.25
      # enable wayland for chromium/electron based apps
      # broken: https://github.com/NixOS/nixpkgs/issues/158175
      # export NIXOS_OZONE_WL=1 
      # export NIXOS_OZONE=1 
    '';
  };
}
