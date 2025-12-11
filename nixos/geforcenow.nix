{ config, pkgs, ... }:
let
  # Chromium-based GeForce NOW launcher
  gfnLauncher = pkgs.writeShellScriptBin "geforcenowp" ''
    exec ${pkgs.chromium}/bin/chromium \
      --app=https://play.geforcenow.com \
      --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
      --enable-features=VaapiVideoDecodeLinuxGL \
      --ignore-gpu-blocklist \
      --enable-gpu-rasterization \
      --enable-zero-copy
  '';

  # AppImage-based GeForce NOW launcher
  gfnAppImageLauncher = pkgs.writeShellScriptBin "geforcenowi" ''
    APPIMAGE="/home/liukdv/Public/geforcenow/infinity-geforcenow/GeForceInfinity-linux-1.2.0-x86_64.AppImage"
    
    if [ ! -f "$APPIMAGE" ]; then
      echo "Error: AppImage not found at $APPIMAGE"
      exit 1
    fi
    
    exec ${pkgs.appimage-run}/bin/appimage-run "$APPIMAGE" --no-sandbox "$@"
  '';
in
{
  environment.systemPackages = [
    gfnLauncher
    gfnAppImageLauncher
  ];
}
