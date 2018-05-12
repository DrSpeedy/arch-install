#!/bin/bash
# Maintainer: Brian Wilson <doc@wiltech.org>
# Licence: MIT

name="Basic (Legacy)"
description="Basic filesystem setup"

rootfs_uuid=

# Sanity check
stat ${install_dev} > /dev/null 2>&1
if [[ $? -ne 0 || "${install_dev}" -eq "/dev/null" ]]; then
    _err_msg 3 "${install_dev} unusable, you must install to a real device!"
fi

_info_msg "Wiping filesystem labels on ${install_dev}"
wipefs --all ${install_dev}

_parttab=( \
    'mklabel msdos' \
    'mkpart primary ext2 1MiB 129MiB' \
    'mkpart primary ext4 129MiB 100%' \
    'set 1 boot on' \
    'print'
)

parted --script ${install_dev} "${_parttab[@]}"

_uuid_cache=($(blkid | grep ${install_dev}))

echo -e "boot => ${_uuid_cache[0]}\nroot => ${_uuid_cache[1]}" > ${work_dir}/dev_uuid

_info_msg "Formating ${install_dev}"
mkfs.ext2 ${install_dev}1
mkfs.ext4 ${install_dev}2

_info_msg "Mounting ${install_dev}"
mkdir -p ${mount_dir}
mount ${install_dev}2 ${mount_dir}

mkdir -p ${mount_dir}/boot
mount ${install_dev}1 ${mount_dir}/boot
