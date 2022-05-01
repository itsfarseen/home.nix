{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    inconsolata-nerdfont
    iosevka-bin
    font-awesome_4
    open-sans
    public-sans
    # Indian
    lohit-fonts.assamese
    lohit-fonts.bengali
    lohit-fonts.devanagari
    lohit-fonts.gujarati
    lohit-fonts.gurmukhi
    lohit-fonts.kannada
    lohit-fonts.kashmiri
    lohit-fonts.maithili
    lohit-fonts.malayalam
    lohit-fonts.marathi
    lohit-fonts.nepali
    lohit-fonts.odia
    lohit-fonts.sindhi
    lohit-fonts.tamil
    lohit-fonts.telugu
  ];
}
