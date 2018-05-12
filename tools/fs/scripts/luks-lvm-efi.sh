#!/bin/bash
# Maintainer: Brian Wilson <doc@wiltech.org>
# Licence: MIT

#set -xe

export fstool_name='LVM on LUKS'
export fstool_desc='No description.'

dev_node=

vg_name=vg0
lv_root_size=4G
lv_home_size='+100%FREE'

map_crypt=/dev/mapper/crypt_root
map_root=/dev/mapper/${vg_name}-root
map_home=/dev/mapper/${vg_name}-home

mount_point=/mnt/usb
work_dir=

# Extra

# Create /data/local and /data/share directories
create_special_directories=false

run() {
    echo "[EXPRESS FS]: FS => '${fstool_name}' being applied to '${dev_node}'"

    # Check if device node exists
    stat ${dev_node} > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "[EXPRESS FS]: ERROR => Unable to stat '${dev_node}'"
        exit 1
    fi

    wipefs --all ${dev_node}

    _parttab=( \
        'mklabel gpt' \
        'mkpart esp fat32 1MiB 513MiB' \
        'mkpart primary ext4 513MiB 100%' \
        'name 1 GRUB_BOOT' \
        'name 2 CRYPT_ROOT' \
        'set 1 boot on' \
        'print' \
    )

    parted --script ${dev_node} "${_parttab[@]}"

    part_boot="$(ls ${dev_node}* | grep -E "^${dev_node}p?1$")"
    part_crypt="$(ls ${dev_node}* | grep -E "^${dev_node}p?2$")"

    echo -e "/\t${part_boot}\n" >> ${work_dir}/expressfs.log
    echo -e "%crypt%\t${part_crypt}\n" >> ${work_dir}/expressfs.log
 
    cryptsetup \
        --cipher aes-xts-plain64 \
        --hash sha512 \
        --key-size 512 \
        --use-random \
        --iter-time 5000 \
        --verify-passphrase \
        luksFormat "${part_crypt}"

    sleep 3

    cryptsetup luksOpen ${part_crypt} crypt_root

    echo "[EXPRESS-FS] FS => Creating LVM..."

    pvcreate ${map_crypt}
    pvdisplay

    vgcreate ${vg_name} ${map_crypt}
    vgdisplay

    lvcreate -L ${lv_root_size} -n root ${vg_name}
    lvcreate -l ${lv_home_size} -n home ${vg_name}

    echo "[EXPRESS-FS] FS => Formatting partitions..."
    mkfs.vfat -F32 ${part_boot}
    mkfs.ext4 ${map_home}
    mkfs.ext4 ${map_root}

    echo "[EXPRESS-FS] FS => Mounting filesystem to ${mount_point}"
    mount ${map_root} ${mount_point}

    mkdir -p ${mount_point}/boot
    mkdir -p ${mount_point}/home

    if [[ ${create_special_directories} ]]; then
        echo "[EXPRESS-FS] FS => Creating special directories..."
        mkdir -p ${mount_point}/data/disk ${mount_point}/data/share
    fi

    mount ${part_boot} ${mount_point}/boot
    mount ${map_home} ${mount_point}/home
}

usage() { echo "Usage: $0 [-d <device node>] [-w <work directory>] [-s]" 1>&2; exit 1; }

if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root!"
    usage
fi

while getopts ":d:w:sh" o; do
    case "${o}" in
        d)
            dev_node=${OPTARG}
            ;;
        w)
            work_dir=${OPTARG}
            ;;
        s)
            create_special_directories=true
            ;;
        h|*)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "${dev_node}" || -z "${work_dir}" ]]; then
    usage
fi

run
