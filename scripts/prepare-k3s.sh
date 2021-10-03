#!/bin/bash

script_dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
rootfslock="${script_dirname}/rootfs-ready.lock"
k3sreadylock="/workspace/k3s-ready.lock"

if test -f "${k3sreadylock}"; then
    exit 0
fi

cd $script_dirname

echo "🔥 Installing K3S on the VM (only on first startup).. This may take a while.."

./ssh.sh "curl -sfL https://get.k3s.io | sh -"
./scp.sh root@127.0.0.1:/etc/rancher/k3s/k3s.yaml /workspace/.kubeconfig

echo "✅ K3S cluster is ready, KubeConfig activated."
echo "Pods running in the cluster [kubectl get pods --all-namespaces]:"
kubectl get pods --all-namespaces

touch "${k3sreadylock}"
