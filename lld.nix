{ pkgs, ... }:
{
  home.packages = [
    pkgs.llvmPackages_14.clang
    (pkgs.hiPrio pkgs.llvmPackages_14.bintools)
  ];
  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.llvmPackages_14.bintools}/bin/ld"]
  '';
}
