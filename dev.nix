{ config, pkgs, ... }:
let
  rust-analyzer-fixed = pkgs.symlinkJoin {
    name = "rust-analyzer";
    paths = [ pkgs.rust-analyzer ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rust-analyzer \
        --set CARGO_TARGET_DIR target/rust-analyzer
    '';
  };
in
{
  home.packages = with pkgs; [
    # Rust
    rustup
    rust-analyzer-fixed
    cargo-edit
    (writeShellScriptBin "ar" "exec -a $0 ${llvm}/bin/llvm-ar $@")
    # Haskell
    stack
    haskell-language-server
    # Lua
    sumneko-lua-language-server
    stylua
    # JS
    nodejs-16_x
    yarn
  ];
}
