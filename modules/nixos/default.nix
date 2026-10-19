{ lib, ... }:

{
  imports = builtins.filter (path: path != ./default.nix && lib.hasSuffix ".nix" (toString path)) (
    lib.filesystem.listFilesRecursive ./.
  );
}
