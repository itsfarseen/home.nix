{ config, pkgs, ... }:
{
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  home.pointerCursor = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors-white";
  };

  gtk.enable = true;
  gtk.cursorTheme = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors-white";
    size = 38;
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

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        "text-scaling-factor" = 1.25;
      };
    };
  };

  home.file.".background-image".source = ./brady-bellini-WEQbe2jBg40-unsplash-adj.jpg;
}
