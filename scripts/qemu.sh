#!/bin/bash

set -xeuo pipefail

script_dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
base_image="/opt/qemu-k3s/vm-images/rootfs.img"
image="/workspace/rootfs.img"

if [ ! -f "$image" ]
then
	echo "No active rootfs image found, creating a new one from initial snapshot.."
    cp $base_image $image
fi

echo "Starting up the QEMU VM.."
sudo qemu-system-x86_64 -kernel "/boot/vmlinuz" \
-boot c -m 2049M -hda "${image}" \
-net user \
-smp 8 \
-append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" \
-nic user,hostfwd=tcp::2222-:22,hostfwd=tcp::6443-:6443 \
-serial mon:stdio -display none
