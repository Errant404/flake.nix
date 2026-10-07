{ pkgs, ... }: {
  imports = [
    ../common.nix
    ./misc-usr-fix.nix
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.yakuake
    kdePackages.kdeconnect-kde
    bitwarden-desktop
    flameshot
    # Audio
    amberol
    gapless
    recordbox
    # Video
    vlc
  ];

  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.flatpak.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = [
            rime-ice
          ];
        })
        fcitx5-gtk
        qt6Packages.fcitx5-qt
        qt6Packages.fcitx5-configtool
        qt6Packages.fcitx5-with-addons
      ];
      waylandFrontend = true;
    };
  };

  services.dae = {
    enable = true;
    package = pkgs.unstable.dae;
    configFile = ../config/dae/config.dae;
  };
  services.mihomo = {
    enable = true;
    package = pkgs.unstable.mihomo;
    # https://metacubex.github.io/metacubexd/
    webui = pkgs.unstable.metacubexd;
    processesInfo = true;
    configFile = "/etc/nixos/secrets/mihomo.yaml";
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;
}
