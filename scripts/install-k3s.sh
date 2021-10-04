#!/bin/bash

script_dirname=/opt/qemu-k3s
k3sreadylock="/workspace/k3s-ready.lock"

if test -f "${k3sreadylock}"; then
    exit 0
fi

echo "🔥 Installing K3S on the VM.. This may take a while.."

$script_dirname/ssh.sh "curl -sfL https://get.k3s.io | sh -"
$script_dirname/scp.sh root@127.0.0.1:/etc/rancher/k3s/k3s.yaml /workspace/.kubeconfig

touch "${k3sreadylock}"
