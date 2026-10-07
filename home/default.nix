{ pkgs, ... }: {
  home.username = "errant";
  home.homeDirectory = "/home/errant";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  imports = [
    ./flatpak.nix
    ./shell.nix
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
  };

  home.packages = with pkgs; [
    telegram-desktop
    llm-agents.omp
    llm-agents.chatgpt
    (llm-agents.dsh.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
              substituteInPlace \
                $out/lib/node_modules/@deepseek-ai/dsh/node_modules/@deepseek-ai/dsh-app-boot/lib/index.js \
                --replace-fail \
              'createRequire(import.meta.url)("node-addon-require-builtin")' \
        '{ requireBuiltin: createRequire(import.meta.url) }'
      '';
    }))
    (pkgs.buildFHSEnv {
      name = "pixi";
      runScript = "pixi";
      targetPkgs = pkgs: with pkgs; [ pixi ];
    })
  ];

  services.syncthing.enable = true;

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
    terminal = "tmux-256color";
    extraConfig = ''
      set -as terminal-features ",xterm-256color:RGB"
    '';
  };

  programs.keepassxc = {
    enable = true;
    settings.Browser.UpdateBinaryPath = false;
  };

  xdg.dataFile = {
    "fcitx5/rime/default.custom.yaml".source = ./config/rime/default.custom.yaml;
    "fcitx5/rime/rime_ice.custom.yaml".source = ./config/rime/rime_ice.custom.yaml;
  };
}
