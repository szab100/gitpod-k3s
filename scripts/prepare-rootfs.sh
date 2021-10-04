#!/bin/bash

set -euo pipefail

img_url="https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.tar.gz"
image_dir="/opt/qemu-k3s/vm-images"

rm -Rf $image_dir
mkdir -p $image_dir

curl -L -o "${image_dir}/rootfs.tar.gz" $img_url

cd $image_dir

tar -xvf rootfs.tar.gz && rm rootfs.tar.gz

qemu-img convert -O qcow2 hirsute-server-cloudimg-amd64.img rootfs.img
rm hirsute-server-cloudimg-amd64.img
qemu-img resize rootfs.img +20G

netconf="
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: yes
"

sudo virt-customize -a rootfs.img \
--run-command 'resize2fs /dev/sda' \
--root-password password:root \
--run-command "echo '${netconf}' > /etc/netplan/01-net.yaml" \
--copy-in /lib/modules/$(uname -r):/lib/modules \
--run-command 'apt remove openssh-server -y && apt install openssh-server -y' \
--run-command "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config" \
--run-command "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config"

sudo rm -rf /var/tmp/.guestfs-0
echo "rootfs image is ready"

