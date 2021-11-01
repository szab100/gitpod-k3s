#!/bin/bash

export KUBECONFIG=/workspace/.kubeconfig
echo "export KUBECONFIG=/workspace/.kubeconfig" > ~/.bashrc
echo "⏳ Waiting until the K3S cluster is ready.."
waitkubectl
echo "✅ K3S cluster is up, use 'kubectl' or API [:6443] to manage."