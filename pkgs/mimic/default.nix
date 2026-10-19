{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
  bpftools,
  pkg-config,
  libbpf,
  libffi,
  ronn,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mimic";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "hack3ric";
    repo = "mimic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ztGGWX7asTgLFvSIunpeeb0lA2jWywD0U8v3uien1o=";
  };

  nativeBuildInputs = [
    llvmPackages.clang-unwrapped
    bpftools
    pkg-config
    ronn
  ];
  buildInputs = [
    libbpf
    libffi
  ];

  # BPF must not inherit the host compiler wrapper's hardening flags.
  env.BPF_CFLAGS = "-isystem ${lib.getDev libbpf}/include";

  makeFlags = [
    "BPF_CC=${llvmPackages.clang-unwrapped}/bin/clang"
    "BPFTOOL=bpftool"
    "MODE=release"
    "CHECKSUM_HACK=kfunc"
    "USE_LIBXDP=0"
    "ARGP_STANDALONE=0"
  ];
  buildFlags = [
    "build-cli"
    "generate-manpage"
  ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 out/mimic "$out/bin/mimic"
    install -Dm644 out/mimic.1.gz "$out/share/man/man1/mimic.1.gz"
    install -Dm644 install/eth0.conf "$out/share/doc/mimic/eth0.conf.example"
    runHook postInstall
  '';

  meta = {
    description = "eBPF UDP -> TCP obfuscator";
    homepage = "https://github.com/hack3ric/mimic";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mimic";
  };
})
