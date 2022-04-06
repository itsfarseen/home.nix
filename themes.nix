{ config, pkgs, ... }:
{
  home.sessionVariables = {
    QT_QPA_PLATFORM_THEME = "qt5ct";
  };

  gtk.enable = true;
  gtk.cursorTheme = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors-white";
  };
  gtk.iconTheme = {
    package = pkgs.breeze-icons;
    name = "breeze-dark";
  };
  gtk.theme = {
    package = pkgs.breeze-gtk;
    name = "Breeze-Dark";
  };
  qt.enable = true;
  qt.style = {
    name = "qt5ct";
  };
}
