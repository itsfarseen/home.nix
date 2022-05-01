{ config, pkgs, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = [ "org.gnome.eog.desktop" ];
      "image/png" = [ "org.gnome.eog.desktop" ];
      "text/html" = [ "chromium-browser.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
    };
  };
}
