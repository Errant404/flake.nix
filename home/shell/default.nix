{ pkgs, ... }: {
  imports = [ ./starship.nix ];

  programs.bash = {
    enable = true;
    historyControl = [
      "ignoreboth"
    ];
    sessionVariables = {
      MCFLY_PATH = "${pkgs.mcfly}/bin/mcfly";
    };
    initExtra = ''
      export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
      export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

      export GOPATH="$XDG_DATA_HOME/go"
      export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
      export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
      export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
      export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
      export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
      export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
      export CARGO_HOME="$XDG_DATA_HOME/cargo"
      export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
      export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
      export GDBHISTFILE="$XDG_STATE_HOME/gdb/history"
      export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
      export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"
      export RUFF_CACHE_DIR="$XDG_CACHE_HOME/ruff"
      export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
    '';
  };
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
  };
}
