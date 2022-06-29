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
  typescript-language-server-fixed = pkgs.symlinkJoin {
    name = "typescript-language-server";
    paths = [ pkgs.nodePackages.typescript-language-server ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/typescript-language-server \
        --add-flags --tsserver-path=${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/
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
    # JS/TS
    nodejs-16_x
    nodePackages.typescript
    yarn
    typescript-language-server-fixed
  ];
}
