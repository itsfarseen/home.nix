{ config, pkgs, ... }:
let
  time-module = tz: label: {
    type = "custom/script";
    exec = "${pkgs.writeShellApplication { 
      name = "utc-time";
      runtimeInputs = [ pkgs.coreutils ];
      text = "TZ=${tz} date +\"${label} %I:%M %p\"";
    }}/bin/utc-time";
    interval = 30;
  };
in {
  systemd.user.services.polybar.Service.ExecStartPost = "${pkgs.coreutils}/bin/sleep 1";
  services.polybar = {
    enable = true;
    package = (pkgs.polybar.overrideAttrs (old: rec {
      pname = "polybar";
      version = "ff6ac9fefc53a8c97b67b81e8da41274936e6835";
      src = pkgs.fetchFromGitHub {
        owner = pname;
        repo = pname;
        rev = version;
        sha256 = "sha256-mln73iPTIuKJRXs6tLKwA5WrrYd7EgZuZAM1GjCTGx8=";
        fetchSubmodules = true;
      };
      cmakeFlags = ["-DBUILD_CONFIG=OFF"];
      buildInputs = (old.buildInputs) ++ [pkgs.libuv];
    })).override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    #script = "polybar main &";
    script = "PATH=$PATH:${pkgs.i3-gaps}/bin polybar main &";
    settings = rec {
      colors = {
        background = "#ee000000";
        background-alt  = "#88222222";
        foreground = "#efefef";
        foreground-alt = "#aaaaaa";
        primary = "#45c482";
        primary-alt = "#5d9478";
        alert = "#ff0000";
      };

      "bar/main" = {
        enable-ipc = true;
        width = "100%";
        dpi = 140;
        height = 32;
        fixed-center = true;
        wm-restack = "i3";
        override-redirect = true;
        #bottom = true;

        background = colors.background;
        foreground = colors.foreground;

        padding = { left = 0; right = 1; };

        module-margin = { left = 1; right = 2; };

        # border = {
        #   size = 5;
        #   color = "#00000000";
        # };

        font = [
          "Iosevka:size=8;3.8"
          "FontAwesome:size=9;3"
        ];

        modules = {
          left = "i3";
          center = "xwindow";
          right = "filesystem xbacklight pulseaudio memory cpu wlan battery powermenu date time-utc time-ind";
        };

        tray = {
          position = "right";
          #detached = true;
          #offset-x = -600;
          padding = 5;
          forground = colors.foreground;
        };
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = {
          text = "%d/%m/%y";
        };
        label = "%date%";
        format.prefix = {
          text = " ";
          foreground = colors.foreground-alt;
        };
      };

      "module/time-ind" = time-module "Asia/Kolkata" "IN";
      "module/time-utc" = time-module "UTC" "UK";
      "module/time-ny" = time-module "America/New_York" "NY";
      "module/time-wa" = time-module "US/Pacific" "WA";
      "module/time-nz" = time-module "NZ" "NZ";

      "module/filesystem" = {
        type = "internal/fs";
        interval = 25;
        mount = [ "/" ];
        label = {
          mounted = "%{F${colors.foreground-alt}}%mountpoint%%{F-}: %percentage_used%%";
          format-mounted-foreground = colors.primary;
        };
      };

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = true;
        wrapping-scroll = false;

        pin-workspaces = true;

        label = {
          mode = { text = "%mode%"; padding = 2; foreground = "#000000"; background = colors.primary-alt; };
          focused = { text = "%index%"; padding = 1; foreground = "#000000"; background = colors.primary; };
          unfocused = { text = "%index%"; padding = 1; };
          urgent = { text = "%index%"; padding = 1; background = colors.alert; };
        };
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format = {
          volume = {
            text = "<label-volume>";
            prefix = " ";
            prefix-foreground = colors.foreground-alt; 
          };
          muted = {
            prefix = "  ";
            prefix-foreground = colors.foreground-alt;
          };
       };

       label = {
         volume = "%percentage%%";
         volume-foreground = colors.foreground;
       };
     };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
        full-at = 100;

        format-charging = "<animation-charging> <label-charging>";

        format-discharging = "<ramp-capacity> <label-discharging>";

        format-full-prefix = " ";
        format-full-prefix-foreground = colors.foreground-alt;

        ramp-capacity = [ "" "" "" "" ];
        ramp-capacity-foreground = colors.foreground-alt;

        animation-charging = [ "" "" "" ];

        animation-charging-foreground = colors.foreground-alt;
        animation-charging-framerate = 750;
      };

      "module/xbacklight" = {
        type = "internal/xbacklight";
        format-prefix = " ";
        format-prefix-foreground = colors.foreground-alt;
        label = "%percentage%%";
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:50:...%";
      };
    };
  };
}
