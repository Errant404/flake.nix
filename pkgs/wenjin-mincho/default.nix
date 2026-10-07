{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wenjin-mincho";
  version = "2.100";

  src = fetchurl {
    url = "https://github.com/takushun-wu/WenJinMincho/releases/download/v${finalAttrs.version}/WenJinMincho-OTF.7z";
    hash = "sha256-qZtCJ0OFZ+/+9AD5sY/1NhZmDmxvZQ7Ev6mVjBDX1lo=";
  };

  nativeBuildInputs = [ _7zz ];

  unpackCmd = ''7zz x "$curSrc"'';

  installPhase = ''
    runHook preInstall
    install -Dm644 *.otf -t "$out/share/fonts/opentype"
    runHook postInstall
  '';

  meta = {
    description = "A large character set fonts in Songti(Mincho) style.";
    homepage = "https://github.com/takushun-wu/WenJinMincho";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
