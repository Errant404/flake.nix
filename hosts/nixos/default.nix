{
  lib,
  pkgs,
  ...
}:
let
  STEAM_HOME = "/home/errant/.local/share/steam-home";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/desktop
    ../../profiles/desktop/steam.nix
  ];
  networking.hostName = "nixos";
  # https://wiki.nixos.org/wiki/Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  # https://wiki.nixos.org/wiki/NVIDIA
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      efi.canTouchEfiVariables = true;
      # https://wiki.nixos.org/wiki/GNU_GRUB
      grub = {
        enable = true;
        default = "saved";
        device = "nodev"; # "nodev" is used for UEFI
        efiSupport = true;
        useOSProber = true;
      };
    };
    mimic.enable = true;
  };
  # https://wiki.nixos.org/wiki/NTFS
  fileSystems."/mnt/c" = {
    device = "/dev/disk/by-uuid/72673191CB18A4F2";
    fsType = "ntfs3";
    options = [
      "ro"
      "nofail"
    ];
  };
  # https://wiki.nixos.org/wiki/Filesystems
  fileSystems."/mnt/T7" = {
    device = "/dev/disk/by-uuid/648A-FDEB";
    fsType = "exfat";
    options = [
      "defaults"
      "umask=0000"
      "nofail"
    ];
  };
  # https://github.com/ValveSoftware/Proton/issues/3835
  fileSystems."/mnt/T7/SteamLibrary/steamapps/compatdata" = {
    device = "${STEAM_HOME}/.local/share/Steam/steamapps/compatdata";
    fsType = "none";
    options = [
      "bind"
      "x-systemd.automount"
      "nofail"
    ];
    depends = [ "/mnt/T7" ];
  };
  # https://wiki.nixos.org/wiki/Fingerprint_scanner
  services.fprintd.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/417965
  services.displayManager = {
    autoLogin.user = "errant";
    sddm.enable = true;
  };
  systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";
  security.pam.services.sddm-autologin.text = lib.mkDefault (
    lib.mkBefore ''
      auth optional ${pkgs.systemd}/lib/security/pam_systemd_loadkey.so
      auth include sddm
    ''
  );
  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";

  users.users."errant" = {
    isNormalUser = true;
    description = "Errant";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.dae = {
    enable = true;
    package = pkgs.unstable.dae;
    configFile = ./config/dae/config.dae;
  };
  services.mihomo = {
    enable = true;
    package = pkgs.unstable.mihomo;
    # https://metacubex.github.io/metacubexd/
    webui = pkgs.unstable.metacubexd;
    processesInfo = true;
    configFile = "/etc/nixos/secrets/mihomo.yaml";
  };
  services.hysteria = {
    enable = true;
    package = pkgs.unstable.hysteria;
    mode = "client";
    configFile = "/etc/nixos/secrets/hysteria.yaml";
  };

  services.tailscale = {
    # sudo tailscale set --accept-dns=false
    enable = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };
  services.caddy = {
    enable = true;
    configFile = ./config/Caddyfile;
  };
}
