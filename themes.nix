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
    package = pkgs.arc-icon-theme;
    name = "Arc";
  };
  gtk.theme = {
    package = (pkgs.callPackage ./arc-black.nix {});
    name = "Arc-BLACK";
  };
  gtk.font = {name= "Liberation Sans"; size = 11;};
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
