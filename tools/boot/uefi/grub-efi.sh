#!/bin/bash
# Maintainer: Brian Wilson <doc@wiltech.org>
# Licence: MIT

echo "TOOLDIR_TEST: ${tool_dir}"

source "${tool_dir}/share/utilrc"

_info_msg "Resolving dependencies..."
_deps=(grub efibootmgr dosfstools)
_pacman "${_deps}"

#grub-install --target=x86_64-efi --efi-directory=$esp --bootloader-id=grub --removable --recheck
grub-install --target=x86_64-efi --efi-directory=${mount_dir}/boot --bootloader-id=GRUB_BOOT --removable --recheck

# rsync config...?

_chroot "grub-mkconfig -o /boot/grub/grub.cfg"
