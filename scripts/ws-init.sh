#!/bin/bash

script_dirname=/opt/qemu-k3s
k3sreadylock="/workspace/k3s-ready.lock"

function waitssh() {
  while ! nc -z 127.0.0.1 2222; do   
    sleep 0.1
  done
  $script_dirname/ssh.sh "whoami" &>/dev/null
  if [ $? -ne 0 ]; then
    sleep 1
    waitssh
  fi
}

echo "Waiting for the QEMU VM to start.."
waitssh
export KUBECONFIG=/workspace/.kubeconfig
[ -f "${k3sreadylock}" ] && echo "✅ VM is up. Once K3S is started, use 'kubectl' or API [:6443] to manage." || echo "✅ VM is up. K3S installer will start shortly.."
