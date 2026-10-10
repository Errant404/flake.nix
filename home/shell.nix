{ lib, pkgs, ... }: {
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
      export GOBIN="$HOME/.local/bin"

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
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$kubernetes"
        "$nats"
        "$directory"
        "$vcsh"
        "$fossil_branch"
        "$fossil_metrics"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$hg_state"
        "$pijul_channel"
        "$docker_context"
        "$python"
        "$guix_shell"
        "$nix_shell"
        "$conda"
        "$pixi"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$direnv"
        "$env_var"
        "$custom"
        "$sudo"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$container"
        "$netns"
        "$os"
        "$shell"
        "$character"
      ];
      python = {
        detect_extensions = [ ];
        detect_files = [ ];
        detect_folders = [ ];
      };
    };
    presets = [ "nerd-font-symbols" ];
  };
}
