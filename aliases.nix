{ config, pkgs, ... }:
{
  home.shellAliases = {
    vim = "nvim";
    gs = "gst";
    gst = "git status";
    gcv = "git commit -v";
    gce = "git commit --amend";
    gps = "git push";
    gpl = "git pull";
    gd = "git diff";
    gds = "git diff --staged";
    hms = "home-manager switch";
    nxsw = "sudo nixos-rebuild switch";
    nxs = "nix search nixpkgs";
    cdg = "cd $(git rev-parse --show-toplevel)";
  };
}
