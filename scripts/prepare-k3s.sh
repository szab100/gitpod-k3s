#!/bin/bash

script_dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
rootfslock="${script_dirname}/rootfs-ready.lock"
k3sreadylock="${script_dirname}/k3s-ready.lock"

if test -f "${k3sreadylock}"; then
    exit 0
fi

cd $script_dirname

function waitssh() {
  while ! nc -z 127.0.0.1 2222; do   
    sleep 0.1
  done
  ./ssh.sh "whoami" &>/dev/null
  if [ $? -ne 0 ]; then
    sleep 1
    waitssh
  fi
}

function waitrootfs() {
  while ! test -f "${rootfslock}"; do
    sleep 0.1
  done
}

echo "🔥 Installing K3S on QEMU, this will run only onnce per workspace."

echo "Checking if the root filesystem image is available"
waitrootfs
echo "✅ RootFS found."

echo "Waiting for the VM to start and become reachable by SSH.."
waitssh
echo "✅ VM has started up."

echo "Installing K3S cluster.."
./ssh.sh "curl -sfL https://get.k3s.io | sh -"

mkdir -p ~/.kube
./scp.sh root@127.0.0.1:/etc/rancher/k3s/k3s.yaml ~/.kube/config

echo "✅ K3S cluster is ready, KubeConfig activated."
echo "Pods running in the cluster:"
kubectl get pods --all-namespaces

touch "${k3sreadylock}"
