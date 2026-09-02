{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/desktop
    ./hardware-configuration.nix
  ];
  networking.hostName = "nixos";
  # https://wiki.nixos.org/wiki/NVIDIA
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  # https://wiki.nixos.org/wiki/GNU_GRUB
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        default = "saved";
        device = "nodev"; # "nodev" is used for UEFI
        efiSupport = true;
        useOSProber = true;
      };
    };
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

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };
  services.caddy = {
    enable = true;
    configFile = ./config/Caddyfile;
  };
}
