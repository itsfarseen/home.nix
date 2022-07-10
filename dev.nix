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
  assume-role = pkgs.stdenv.mkDerivation rec {
    pname = "assume-role";
    version = "0.3.2";

    src = pkgs.fetchurl {
      url = "https://github.com/remind101/assume-role/releases/download/${version}/assume-role-Linux";
      sha256 = "sha256-QPnuU07T5wuqpdm/6v58qEZ3G9dg2Mqai3RtmYR9OnE=";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    installPhase = ''
      install -m755 -D ${src} $out/bin/assume-role
    '';

    dontUnpack = true;

    meta = with pkgs.lib; {
      homepage = "https://github.com/remind101/assume-role";
      description = "Assume Role CLI for AWS";
      platforms = platforms.linux;
    };
  };
  cargo-udeps = pkgs.stdenv.mkDerivation rec {
    pname = "cargo-udeps";
    version = "0.1.30";

    src = builtins.fetchTarball {
      url = "https://github.com/est31/cargo-udeps/releases/download/v${version}/cargo-udeps-v${version}-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "sha256:1b0q6wkc3xps4iggds49dsff428vz1dibpshym7kpik4c8pn9wz7";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      zlib
      openssl
    ];

    installPhase = ''
      install -m755 -D ${src}/cargo-udeps $out/bin/cargo-udeps
    '';

    meta = with pkgs.lib; {
      homepage = "https://github.com/est31/cargo-udeps";
      description = "Find unused Rust dependencies";
      platforms = platforms.linux;
    };
  };
  cargo-depgraph = pkgs.rustPlatform.buildRustPackage {
    pname = "cargo-depgraph";
    version = "1.2.5";
    cargoSha256 = "sha256-Ce13vJ5zE63hHVkg/WFdz3LrASj7Xw6nqOO64uALOeQ=";

    src = pkgs.fetchgit {
      url = "https://git.sr.ht/~jplatte/cargo-depgraph";
      rev = "1ef6c5aa9ea64e9c7ee8aefd4fafcceef6d1ab98";
      sha256 = "sha256-ewlrxxHnsXBWSMPAlxTfrHj23jMiThkDSJhEsChO/sM=";
    };
  };
  devLibs = with pkgs; [
    xorg.libX11 
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi     
    vulkan-loader
    sqlite
  ];
in
{
  home.packages = with pkgs; [
    # Rust
    rustup
    rust-analyzer-fixed
    cargo-edit
    (writeShellScriptBin "ar" "exec -a $0 ${llvm}/bin/llvm-ar $@")
    clang
    cargo-udeps
    cargo-depgraph
    graphviz # for cargo-depgraph
    diesel-cli
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
    nodePackages.vscode-json-languageserver
    # Infra
    wireguard-tools
    awscli
    kubectl
    assume-role
    keybase
    keybase-gui
  ];

  programs.fish.functions = {
    assume-role = ''
      set --erase AWS_SECRET_ACCESS_KEY
      set --erase AWS_SESSION_TOKEN
      set --erase AWS_SECURITY_TOKEN
      set --erase ASSUMED_ROLE
      eval (command assume-role -duration=12h $argv)
    '';
  };

  home.sessionVariables = {
    # NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
    #   xorg.libX11
    # ];
    # NIX_LD = with pkgs; lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath devLibs; # for loader
    LIBRARY_PATH = pkgs.lib.makeLibraryPath devLibs; # for linker
  };
}
