# Cluster Usage

## Prerequisites

Ensure your SOPS key is available. The helper script will attempt to load it from 1Password automatically.

If you need to load it manually:

```bash
export SOPS_AGE_KEY=$(op read "op://Personal/Talos Age Key/notesPlain")
```

## Talos Dashboard

Start by accessing the Talos dashboard (using process substitution to decrypt the config on the fly):

```bash
talosctl dashboard -n 10.0.0.24 -e 10.0.0.24 --talosconfig <(sops -d ./cluster/talosconfig)
```

## Accessing the Cluster (kubectl)

To interact with the cluster using `kubectl`, you can use the provided helper script. This script will decrypt the `kubeconfig` using your loaded key and set the `KUBECONFIG` environment variable.

```bash
source ./export-kubeconfig.sh
```

Then you can run kubectl commands:

```bash
kubectl get nodes
```

## Adding a Worker Node

To add a new worker node to the cluster, apply the `worker.yaml` configuration to the new node's IP address:

```bash
talosctl apply-config --insecure --nodes <NEW_WORKER_IP> --file <(sops -d cluster/worker.yaml)
```

## Removing a Node

To remove a node from the cluster:

1. Delete the node from Kubernetes:

    ```bash
    kubectl delete node <NODE_NAME>
    ```

2. Reset the node using `talosctl` (this will wipe the disk and reboot the node):

    ```bash
    talosctl reset --nodes <NODE_IP> --talosconfig <(sops -d cluster/talosconfig)
    ```
