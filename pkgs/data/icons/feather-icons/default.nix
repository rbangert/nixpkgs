{ lib, stdenvNoCC, fetchFromGitHub, gtk3, gnome-icon-theme, mint-x-icons, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "feather-icons";
  version = "4.29.1";

  src = fetchFromGitHub {
    owner = "feathericons";
    repo = "feather";
    rev = "v${version}";
    sha256 = "sha256-/zEEO8onihzn40Eun8s3JeMCORBltY2msZLa2O+lA5s=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme mint-x-icons hicolor-icon-theme ];
  # still missing parent themes: Ambiant-MATE, Faenza-Dark, KFaenza

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a * $out/share/icons
  '';

  meta = with lib; {
    description = "Feather is a collection of simply beautiful open-source icons. Each icon is designed on a 24x24 grid with an emphasis on simplicity, consistency, and flexibility.";
    homepage = "https://feathericons.com";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
