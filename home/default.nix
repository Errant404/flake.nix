{ pkgs, ... }: {
  home.username = "errant";
  home.homeDirectory = "/home/errant";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  imports = [
    ./shell
    ./flatpak.nix
  ];

  xdg = {
    enable = true;
    localBinInPath = true;
    autostart = {
      enable = true;
      readOnly = true;
      entries = [
        "${pkgs.kdePackages.yakuake}/share/applications/org.kde.yakuake.desktop"
        "${pkgs.bitwarden-desktop}/share/applications/bitwarden.desktop"
      ];
    };
    configFile = {
      "distrobox/distrobox.conf".text = ''
        container_manager="podman"
      '';
    };
    dataFile = {
      "fcitx5/rime/default.custom.yaml".source = ./config/rime/default.custom.yaml;
      "fcitx5/rime/rime_ice.custom.yaml".source = ./config/rime/rime_ice.custom.yaml;
    };
  };

  home.packages = with pkgs; [
    telegram-desktop
    ookla-speedtest
    llm-agents.omp
    llm-agents.chatgpt
    llm-agents.dsh
    (pkgs.buildFHSEnv {
      name = "pixi";
      runScript = "pixi";
      targetPkgs = pkgs: with pkgs; [ pixi ];
    })
    (pkgs.callPackage ../pkgs/moore-perf-system { })
  ];

  services.syncthing.enable = true;
  services.ssh-agent.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Errant";
      email = "erigidissimus@gmail.com";
    };
  };

  programs.firefox = {
    enable = true;
    policies.Preferences = {
      "ui.key.menuAccessKey" = {
        Value = 0;
        Status = "locked";
      };
      "ui.key.menuAccessKeyFocuses" = {
        Value = false;
        Status = "locked";
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
  };

  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
  };

  programs.gh.enable = true;

  programs.keepassxc = {
    enable = true;
    settings.Browser.UpdateBinaryPath = false;
  };

  programs.retroarch = {
    enable = true;
    cores = {
      melonds.enable = true;
      ppsspp.enable = true;
      swanstation.enable = true;
    };
    settings = { };
  };
}
