# Talos Kubernetes Cluster

This repository contains configuration files for a Talos Linux based Kubernetes cluster.

## Prerequisites

- [talosctl](https://www.talos.dev/latest/learn-more/talosctl/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Project Structure

- `cluster/controlplane.yaml`: Machine configuration for control plane nodes.
- `cluster/worker.yaml`: Machine configuration for worker nodes.
- `cluster/talosconfig`: Configuration for the `talosctl` CLI.
- `cluster/kubeconfig`: Configuration for the `kubectl` CLI.
- `export-kubeconfig.sh`: Helper script to set the KUBECONFIG environment variable.

## Usage

### Talos Dashboard

Start by accessing the Talos dashboard:

```bash
talosctl dashboard -n 10.0.0.24 -e 10.0.0.24 --talosconfig ./cluster/talosconfig
```

### Accessing the Cluster (kubectl)

To interact with the cluster using `kubectl`, you can use the provided helper script to set your environment variable:

```bash
source ./export-kubeconfig.sh
```

Then you can run kubectl commands:

```bash
kubectl get nodes
```

### Adding a Worker Node

To add a new worker node to the cluster, apply the `worker.yaml` configuration to the new node's IP address:

```bash
talosctl apply-config --insecure --nodes <NEW_WORKER_IP> --file <(sops -d cluster/worker.yaml)
```

### Removing a Node

To remove a node from the cluster:

1. Delete the node from Kubernetes:

    ```bash
    kubectl delete node <NODE_NAME>
    ```

2. Reset the node using `talosctl` (this will wipe the disk and reboot the node):

    ```bash
    talosctl reset --nodes <NODE_IP> --talosconfig cluster/talosconfig
    ```

## Security & Encryption

We use [sops](https://github.com/getsops/sops) with [age](https://github.com/FiloSottile/age) to encrypt sensitive configuration files.

### Encryption Prerequisites

1. Install `age` and `sops`:

    ```bash
    brew install age sops
    ```

2. Generate a key:

    ```bash
    age-keygen -o keys.txt
    ```

3. Set the environment variable (add this to your shell profile):

    ```bash
    export SOPS_AGE_KEY_FILE=$(pwd)/keys.txt
    ```

4. **Important:** Update `.sops.yaml` with your public key (found in `keys.txt`). Replace `AGE-PUBLIC-KEY-HERE` with your actual public key.

### Storing the Key in 1Password

To securely manage the private key, you can store it in 1Password:

1. Copy the content of `keys.txt`.
2. Save it in a 1Password item (e.g., "Talos Age Key").
3. Use the 1Password CLI (`op`) to set the variable:

    ```bash
    export SOPS_AGE_KEY=$(op read "op://Personal/Talos Age Key/notesPlain")
    ```

### Encrypting Files

To encrypt a file in place:

```bash
sops --encrypt --in-place cluster/controlplane.yaml
sops --encrypt --in-place cluster/worker.yaml
sops --encrypt --in-place cluster/talosconfig
sops --encrypt --in-place cluster/kubeconfig
```

### Using Encrypted Files

Since `talosctl` doesn't natively support sops, use process substitution to decrypt on the fly:

```bash
talosctl apply-config --insecure --nodes <NODE_IP> --file <(sops -d cluster/controlplane.yaml)
```

To edit an encrypted file:

```bash
sops cluster/controlplane.yaml
```
