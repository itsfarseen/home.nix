{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    sccache
  ];
  home.sessionVariables = {
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };
}
