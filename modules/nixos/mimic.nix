{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.boot.mimic.enable = lib.mkEnableOption "";
  config = lib.mkIf config.boot.mimic.enable {
    environment.systemPackages = [
      (pkgs.callPackage ../../pkgs/mimic/default.nix { })
    ];
    boot.extraModulePackages = [
      (config.boot.kernelPackages.callPackage ../../pkgs/mimic/kernel-module.nix { })
    ];
    boot.kernelModules = [ "mimic" ];
  };
}
