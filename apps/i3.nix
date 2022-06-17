{ config, pkgs, ... }:
let 
  inherit (pkgs.lib.attrsets) mapAttrsToList;
in {
  xsession.enable = true;
  # It defaults to `.xsession`.
  # If `.xsession` file is present, login manager 
  # always runs that regardless of the chosen WM/DE.
  home.sessionVariables = {
    WINIT_X11_SCALE_FACTOR = 1.25;
    GDK_SCALE_FACTOR = 1.25;
    QT_SCALE_FACTOR = 1.25;
  };
  xsession.scriptPath = ".xsession-hm";
  xsession.preferStatusNotifierItems = true;
  services = {

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;

    # Bluetooth
    blueman-applet.enable = true;

    # Pulseaudio
    pasystray.enable = true;

    # Battery Warning
    cbatticon.enable = true;

    # Keyring
    gnome-keyring = { enable = true; };

    syncthing.tray.enable = true;

  };

  home.packages = with pkgs; [
    blueberry
    lxsession
    lxqt.lxqt-config
  ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps; 
    extraConfig = ''
      for_window [class=".*"] border pixel 0
      gaps top 36

      for_window [class=".blueman-applet-wrapped" title="realme.*"] kill
      for_window [class=".blueman-applet-wrapped" title="Connected"] kill
    '';
    config = let
      merge_list_of_sets = cfgs: builtins.foldl' (a: b: a//b) {} cfgs; 
      workspaces = {
        "1" = "1: Web";
        "2" = "2: Code";
        "3" = "3: Code";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8: Comms";
        "9" = "9";
        "0" = "10: Temp";
      };
      mod = "Mod4";
      workspace_switch_fn = key: ws: {
        "${mod}+${key}" = "workspace number ${ws}";
        "${mod}+Shift+${key}" = "move container to workspace number ${ws}; workspace number ${ws}";
        "${mod}+Ctrl+${key}" = "move container to workspace number ${ws}";
      };
      workspace_switch_keybindings = merge_list_of_sets (mapAttrsToList workspace_switch_fn workspaces);
    in {
      modifier = mod;
      floating.modifier = mod;
      bars = [];
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

        "${mod}+Ctrl+h" = "move workspace to output left";
        "${mod}+Ctrl+l" = "move workspace to output right";
        "${mod}+Ctrl+k" = "move workspace to output up";
        "${mod}+Ctrl+j" = "move workspace to output down";

        "${mod}+v" = "split v";
        "${mod}+Shift+v" = "split h";

        "${mod}+f" = "fullscreen toggle";

        "${mod}+comma" = "layout stacking";
        "${mod}+period" = "layout tabbed";
        "${mod}+slash" = "layout toggle split";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+a" = "focus parent";
        "${mod}+Shift+a" = "focus child";

        "${mod}+Shift+s" = "sticky toggle";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Logout?' -b 'Yes' 'i3-msg exit'";

        "${mod}+r" = "mode resize";

        "${mod}+q" = "kill";
        "${mod}+d" = "exec rofi -show drun -show-icons";

        "${mod}+z" = "workspace back_and_forth";
        "${mod}+Shift+z" = "move container to workspace back_and_forth";

        "${mod}+g" = "gaps inner current plus 5";
        "${mod}+Shift+g" = "gaps inner current minus 5";

        "${mod}+m" = "[class=\"TelegramDesktop\" title=\"^Telegram.*\"] scratchpad show";
      };

      window.commands = [
        {
          criteria = {
            class = "TelegramDesktop";
            title = "^Telegram.*";
          };
          command = "move scratchpad";
        }
      ];

      startup = [
        { 
          command = "systemctl --user restart polybar"; 
          always = true;
          notification = false;
        }
        { 
          command = "systemctl --user restart picom"; 
          always = true;
          notification = false;
        }
        { 
          command = "pkill -SIGUSR1 sxhkd"; 
          always = true;
          notification = false;
        }
      ];

      floating.criteria = [
        { class="Pavucontrol"; }
        { class="Lxappearance"; }
        { class="Blueberry.pi"; }
        { class=".blueman-manager-wrapped"; }
        { title="Event Tester"; }
        { class="KeePassXC"; }
        { instance="nm-connection-editor"; }
      ];

      modes = {
        resize = {
          Left = "resize shrink width 10";
          Right = "resize grow width 10";
          Down = "resize shrink height 10";
          Up = "resize grow height 10";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      colors =
        let
          focused = "#45c482";
          unfocused = "#333333";
          text = "#000000";
          indicator = "#333333";
          fn = col: {
            border = col;
            childBorder = col;
            background = col;
            text = text;
            indicator = indicator;
          };
        in
        {
          focused = fn focused;
          unfocused = fn unfocused;
          focusedInactive = fn unfocused;
        };
    };
  };
}
