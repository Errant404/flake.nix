{ STEAM_HOME }:
{
  lib,
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
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
}
