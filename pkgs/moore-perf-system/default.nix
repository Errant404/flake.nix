{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  writeShellApplication,
  symlinkJoin,
  makeDesktopItem,
  runCommand,
  bubblewrap,
  coreutils,
  zlib,
  zstd,
  xz,
  libglvnd,
  libX11,
  libXcomposite,
  libxcb,
  xcbutilwm,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  libxkbcommon,
  atk,
  cairo,
  dbus,
  libdrm,
  fontconfig,
  freetype,
  libgbm,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libinput,
  mtdev,
  pango,
  systemd,
  wayland,
}:
let
  version = "1.8.0";
  payload = stdenv.mkDerivation {
    pname = "moore-perf-system-unwrapped";
    inherit version;
    src = fetchurl {
      name = "moore-perf-system_${version}_amd64.deb";
      url = "https://dl.mthreads.com/repo/ui/tree-browser/artifact/action/download?repoKey=ubuntu2204&path=pool%2Fjammy%2Famd64%2Fmoore-perf-system_${version}_amd64.deb";
      hash = "sha256-wspcDizFg0gS+yni0leFwikqtqUhNUXAkroTbC/5lY4=";
    };
    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];
    buildInputs = [
      stdenv.cc.cc.lib
      zlib
      zstd
      xz
      libglvnd
      libX11
      libXcomposite
      libxcb
      xcbutilwm
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      libxkbcommon
      atk
      cairo
      dbus
      libdrm
      fontconfig
      freetype
      libgbm
      gdk-pixbuf
      glib
      gtk3
      harfbuzz
      libinput
      mtdev
      pango
      systemd
      wayland
    ];
    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x "$src" .
      runHook postUnpack
    '';
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/libexec"
      cp -a opt/moore-threads/moore-perf-system/${version} "$out/libexec/moore-perf-system"
      runHook postInstall
    '';
    # Preserve upstream binaries and their bundled Qt ABI; only fix ELF paths.
    dontStrip = true;
  };
  appDir = "${payload}/libexec/moore-perf-system";
  launcher =
    name: executable:
    writeShellApplication {
      inherit name;
      runtimeInputs = [
        bubblewrap
        coreutils
      ];
      text = builtins.replaceStrings [ "@appDir@" "@executable@" ] [ appDir executable ] (
        builtins.readFile ./launcher.sh
      );
    };
  desktop = makeDesktopItem {
    name = "moore-perf-system";
    desktopName = "Moore Perf System";
    exec = "msys-ui %f";
    icon = "moore-perf-system";
    categories = [
      "Development"
      "Profiling"
    ];
    startupWMClass = "Moore Perf System";
  };
  icon = runCommand "moore-perf-system-icon" { } ''
    install -Dm644 ${appDir}/host-linux-x86_64/msys-ui.png \
      "$out/share/icons/hicolor/256x256/apps/moore-perf-system.png"
  '';
in
symlinkJoin {
  name = "moore-perf-system-${version}";
  paths = [
    (launcher "msys-ui" "host-linux-x86_64/msys-ui")
    (launcher "msys" "target-linux-x86_64/msys")
    desktop
    icon
  ];
  passthru = { inherit payload; };
  meta = {
    description = "Moore Threads system profiler";
    homepage = "https://developer.mthreads.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "msys-ui";
  };
}
