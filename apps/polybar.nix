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
        background = "#ff1D202F";
        foreground = "#efefef";
        foreground-alt = "#aaaaaa";
        primary = "#7aa2f7";
        alert = "#ff0000";
      };

      "bar/main" = {
        enable-ipc = true;
        width = "100%";
        dpi = 120;
        height = 36;
        fixed-center = true;
        wm-restack = "i3";
        override-redirect = true;
        #bottom = true;

        background = colors.background;
        foreground = colors.foreground;

        padding = { left = 0; right = 1; };

        module-margin = { left = 1; right = 4; };

        font = [
          #"Iosevka:size=8;3.8"
          "Public Sans Medium:size=9.0;1.7"
          "FontAwesome:size=10;2.6"
        ];

        line-size = 3;
        line-color = colors.primary;

        modules = {
          left = "i3";
          center = "xwindow";
          right = "network filesystem xbacklight pulseaudio memory cpu wlan battery powermenu date time-ind";
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
          text = "  ";
          foreground = colors.foreground-alt;
        };

        format-underline = colors.primary;
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
          mode = { text = "%mode%"; padding = 2; foreground = "#000000"; background = colors.primary; };
          focused = { text = "%index%"; padding = 2; foreground = "#000000"; background = colors.primary; };
          unfocused = { text = "%index%"; padding = 2; };
          urgent = { text = "%index%"; padding = 2; background = colors.alert; };
        };
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format = {
          volume = {
            text = "<label-volume>";
            prefix = "  ";
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

        format-full-prefix = "  ";
        format-full-prefix-foreground = colors.foreground-alt;

        ramp-capacity = [ " " " " " " " " ];
        ramp-capacity-foreground = colors.foreground-alt;

        animation-charging = [ " " " " " " ];

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
        label = "%title:0:70:...%";

        format-underline = colors.primary;
      };

      "module/network" = {
        type = "internal/network";
        interface-type = "wireless";
        interval = 1.0;
        label = {
          connected = "  %essid% %downspeed:10% %upspeed:10%";
        };
      };
    };
  };
}
