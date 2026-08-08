# @todo: Replace this file with the Latitude's generated hardware configuration.
# Do not copy filesystem UUIDs, boot settings, CPU settings, or drivers from DellG.
{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
