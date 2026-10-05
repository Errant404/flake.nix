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

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };
  services.caddy = {
    enable = true;
    configFile = ./config/Caddyfile;
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        STEAM_HOME=${lib.escapeShellArg STEAM_HOME}

        if [ -z "''${XAUTHORITY:-}" ] && [ -f "$HOME/.Xauthority" ]; then
          export XAUTHORITY="$HOME/.Xauthority"
        fi

        export HOME="$STEAM_HOME"
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_CACHE_HOME="$HOME/.cache"
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_STATE_HOME="$HOME/.local/state"

        mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
        cd "$HOME"

        export FONTCONFIG_FILE="${pkgs.writeText "steam-fonts.conf" ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <include>/etc/fonts/fonts.conf</include>
            <match target="font">
              <edit name="antialias" mode="assign">
                <bool>true</bool>
              </edit>
            </match>
          </fontconfig>
        ''}"
      '';
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  environment.systemPackages = with pkgs; [
    steam-run
  ];
  programs.gamemode.enable = true;
}
