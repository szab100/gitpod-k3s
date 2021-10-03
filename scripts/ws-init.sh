#!/bin/bash

script_dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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

cd $script_dirname

echo "Waiting for the K3S Cluster (on QEMU VM) to start.."
waitssh
export KUBECONFIG=/workspace/.kubeconfig
echo "✅ K3S is up. 'kubectl' should work from here.."
