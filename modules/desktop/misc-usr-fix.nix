# https://wiki.nixos.org/wiki/Fixes_for_non-Nix_applications
{ pkgs, ... }:
let
  # Mount options for the bind mounts
  mountOptions = [
    "ro"
    "x-gvfs-hide"
    # Resolves symlinks as if they were real files
    # Needed for things like OnlyOffice
    "resolve-symlinks"
  ];
in
{
  # Bind mounts fonts, icons and themes from
  # The /run/current-system/sw/share/* paths
  # to their /usr/share/* equivalents
  # Expose all fonts
  # under /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;
  # Flatpak: Bind mounts /usr/share/* directories
  system.fsPackages = [ pkgs.bindfs ];
  # Fonts
  fileSystems."/usr/share/fonts" = {
    device = "/run/current-system/sw/share/X11/fonts";
    fsType = "fuse.bindfs";
    options = mountOptions;
  };
  # Icons
  fileSystems."/usr/share/icons" = {
    device = "/run/current-system/sw/share/icons";
    fsType = "fuse.bindfs";
    options = mountOptions;
  };
  # Themes
  fileSystems."/usr/share/themes" = {
    device = "/run/current-system/sw/share/themes";
    fsType = "fuse.bindfs";
    options = mountOptions;
  };
}
