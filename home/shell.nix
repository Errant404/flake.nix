{ lib, pkgs, ... }: {
  programs.bash = {
    enable = true;
    historyControl = [
      "ignoreboth"
    ];
    sessionVariables = {
      MCFLY_PATH = "${pkgs.mcfly}/bin/mcfly";
    };
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
