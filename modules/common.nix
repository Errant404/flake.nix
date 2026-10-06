{ pkgs, ... }: {
  networking.networkmanager.enable = true;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    QT_IM_MODULES = "wayland;fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    DOTNET_CLI_HOME = "${XDG_DATA_HOME}/dotnet";
    GTK2_RC_FILES = "${XDG_CONFIG_HOME}/gtk-2.0/gtkrc";
  };

  environment.systemPackages = with pkgs; [
    bind
    iproute2
    inetutils
    nexttrace

    wget
    ripgrep
    fd
    git
    htop
    tealdeer

    nil
    nixd
    nixfmt

    distrobox
    bubblewrap

    nodejs
    pnpm
    python3
  ];
  
  # https://wiki.nixos.org/wiki/Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  # https://wiki.nixos.org/wiki/Fonts
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans-static
      noto-fonts-cjk-serif-static
      noto-fonts-color-emoji
      vista-fonts
      vista-fonts-chs
      vista-fonts-cht
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
        ];
        monospace = [
          "Consolas"
          "CaskaydiaMono Nerd Font"
          "Noto Sans Mono CJK SC"
        ];
      };
    };
    fontDir.enable = true;
  };

  # https://wiki.nixos.org/wiki/Nix-ld
  programs.nix-ld.enable = true;

  nix.settings = {
    use-xdg-base-directories = true;
    substituters = [
      "https://mirror.nju.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nixpkgs.config.allowUnfree = true;
}
