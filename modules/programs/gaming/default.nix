{ STEAM_HOME }:
{ ... }: {
  imports = [
    (import ./steam.nix { inherit STEAM_HOME; })
  ];
  home-manager.sharedModules = [
    ./retroarch.nix
  ];
  programs.gamemode.enable = true;
}
