sudo -i

mount /dev/nvme0n1p11 /mnt
mount /dev/nvme0n1p12 /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot/efi

nixos-enter

NIXOS_INSTALL_BOOTLOADER=1 /run/current-system/bin/switch-to-configuration boot
# nixos-rebuild switch --install-bootloader # (fallback)

# su windows prompt: 
# bcdedit /set {bootmgr} path \EFI\systemd\systemd-bootx64.efi
