# k3s on Gitpod

[![Gitpod ready-to-code](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/szab100/gitpod-k3s)

Just click on the button above and you will be in a Gitpod workspace with k3s running. 

Based on [fntlnz/gitpod-k3s](https://github.com/fntlnz/gitpod-k3s), this version is using a pre-baked workspace image, which has QEMU installed and the VM's root filesystem image pre-created, resulting in much faster initial workspace initialization.

Note: I do not plan to keep this workspace image up-to-date with gitpod/workspace-full. You can build and push your own after checking this repository out:

```
$ docker build -f Dockerfile.k3s -t <your_registry>/gitpod-k3s-qemu:latest .

$ docker login <your_registry>
$ docker push -a <your_registry>/gitpod-k3s-qemu
```

You can copy the `.gitpod.yml` to your own project to have the k3s environment ready in there.

Here's a diagram of the interactions that also shows how the various components interact with each other.

<center>

![img/diagram.svg](img/diagram.svg)

</center>

## Usage

At start, the workspace will start a VM in your gitpod workspace and
automatically install K3S on it on the first workspace start-up. Your local environment will be auto-configured to access it with `kubectl`.


### Connecting via kubectl

When you open your workspace terminal, `kubectl` is already configured to use
the kubeconfig located at `/workspace/.kubeconfig`.

### Connecting via K8S API

The Kubernetes API is reachable on localhost:6443.

### Connecting via SSH

You can connect to the VM via ssh at any moment. The ssh daemon
is exposed on `127.0.0.1` for the workspace on port `2222`.

- username: root
- password: root

```console
ssh -p 2222 root@127.0.0.1
```

You can use the `/opt/qemu-k3s/{ssh.sh, scp.sh}` scripts to run commands or copy files to/from the VM.
