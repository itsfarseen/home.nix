{ config, pkgs, ... }:
{
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  gtk.enable = true;
  gtk.cursorTheme = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors-white";
  };
  gtk.iconTheme = {
    package = pkgs.qogir-icon-theme;
    name = "Qogir";
  };
  gtk.theme = {
    package = pkgs.qogir-theme;
    name = "Qogir";
  };
  gtk.font = {name= "Public Sans"; size = 12;};
  qt.enable = true;
  qt.style = {
    name = "qt5ct";
  };

  home.packages = with pkgs; [
    lxappearance
    qt5ct
  ];

  home.file.".background-image".source = ./brady-bellini-WEQbe2jBg40-unsplash-adj.jpg;
}
