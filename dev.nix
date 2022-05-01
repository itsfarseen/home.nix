{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust
    rustup
    rust-analyzer
    cargo-edit
    clang
    llvm
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
