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

function waitkubectl() {
  CMD=$(kubectl get pod --all-namespaces 2>&1 >/dev/null)
  echo -n "."
  until $CMD
  do
    sleep 5
  done
}

function fail {
    printf '%s\n' "$1" >&2
    exit "${2-1}"
}

echo "⏳ Waiting for the QEMU VM to start.."
waitssh
echo "✅ QEMU VM is up."

if [ ! -f "${k3sreadylock}" ]
then
  echo "K3S not found, installer will start shortly.."
  $script_dirname/install-k3s.sh && echo "✅ K3S installation has completed." || fail "❌ K3S installation has failed.. :("
fi

export KUBECONFIG=/workspace/.kubeconfig
echo "⏳ Waiting until the K3S cluster is ready.."
waitkubectl
echo "✅ K3S cluster is up, use 'kubectl' or API [:6443] to manage."
