{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "fhs-shell";

  targetPkgs = pkgs: with pkgs; [
    gcc
    python3
    zlib
  ];

  runScript = "bash";
}).env