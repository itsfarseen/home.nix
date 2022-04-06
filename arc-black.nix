{ config, stdenv, fetchFromGitHub, pkgs }:
stdenv.mkDerivation {
  name = "Arc-Black-theme";
  src = fetchFromGitHub {
    owner = "rtlewis88";
    repo = "rtl88-Themes";
    rev = "702a9f73364be40e664766b33e07b1f35e2b28bd";
    sha256 = "sha256-iWTbGSoSwuPrnys8PEiSVk9+4gr4cxvqU7SLfZGEhf8=";
  };
  installPhase = ''
    mkdir -p "$out/share/themes";
    mv Arc-BLACK "$out/share/themes";
  '';
}
