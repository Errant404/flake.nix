{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.hysteria;
in
{
  options.services.hysteria = {
    enable = lib.mkEnableOption "Hysteria";
    package = lib.mkPackageOption pkgs "hysteria" { };
    mode = lib.mkOption {
      type = lib.types.enum [
        "client"
        "server"
      ];
      default = "client";
    };
    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/hysteria/config.yaml";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hysteria = {
      description = "Hysteria";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "systemd-modules-load.service"
        "dae.service"
      ];
      path = lib.optional (config.boot.mimic.enable or false) (
        pkgs.callPackage ../../pkgs/mimic/default.nix { }
      );
      environment = {
        HYSTERIA_LOG_LEVEL = "info";
        HOME = "/var/lib/hysteria";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          cfg.mode
          "--config"
          cfg.configFile
        ];
        User = "root";
        Group = "root";
        StateDirectory = "hysteria";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/hysteria";
        Restart = "on-failure";
        RestartSec = "5s";
        NoNewPrivileges = true;
      };
    };
  };
}
