{
  stdenv,
  callPackage,
  kernel,
  kernelModuleMakeFlags,
}:
let
  mimic = callPackage ./default.nix { };
  kernelBuild = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "mimic-kernel-module";
  inherit (mimic) src version;

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];
  enableParallelBuilding = true;

  preBuild = ''
    # Nix keeps vmlinux outside the build tree. Supply a writable tree with
    # BTF inputs instead of upstream's distro-specific bubblewrap overlay.
    cp -r ${kernelBuild} kernel-build
    chmod -R u+w kernel-build
    substituteInPlace kernel-build/Makefile \
      --replace-fail '${kernelBuild}' "$PWD/kernel-build"
    ln -s ${kernel.dev}/vmlinux kernel-build/vmlinux
    makeFlagsArray+=("-C" "$PWD/kernel-build" "KBUILD_OUTPUT=$PWD/kernel-build" "M=$PWD/kmod" "SYSTEM_BUILD_DIR=$PWD/kernel-build")
  '';

  makeFlags = kernelModuleMakeFlags ++ [ "CHECKSUM_HACK=kfunc" ];
  buildFlags = [ "modules" ];

  installPhase = ''
    runHook preInstall
    install -Dm644 kmod/mimic.ko "$out/lib/modules/${kernel.modDirVersion}/extra/mimic.ko"
    runHook postInstall
  '';

  postFixup = ''
    # Kbuild can silently skip BTF generation. Check the installed module
    # after stripping, since kfunc registration requires BTF at runtime.
    $READELF -SW "$out/lib/modules/${kernel.modDirVersion}/extra/mimic.ko" | grep -q ' \.BTF '
  '';

  meta = {
    inherit (mimic.meta) description homepage license platforms;
  };
}
