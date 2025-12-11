# 🏠 Production Home Lab

Infrastructure as Code for a high-availability Kubernetes cluster running on [Talos Linux](https://www.talos.dev).

## 🌟 Overview

This repository manages the configuration and state of my home laboratory Kubernetes cluster. It follows GitOps principles and prioritizes security through encryption and immutable infrastructure.

**Key Technologies:**

* **OS:** Talos Linux (Immutable, API-managed)
* **Orchestration:** Kubernetes
* **Secret Management:** SOPS + Age + 1Password

## 📊 Cluster Status

* **Kubernetes:** `v1.34.1`
* **Talos Linux:** `v1.11.5`
* **Nodes:** 3 (1 Control Plane, 2 Workers)
* **Resources:** 24 CPU Cores, ~35GB RAM, ~1.35TB Storage
* **Networking:** Flannel CNI, Default Pod/Service CIDRs

## 📂 Repository Structure

* `provisioning/`: Talos machine configuration (Control Plane, Workers, Kubeconfig). These files are used to bootstrap the nodes.
* `cluster/`: Kubernetes manifests managed by Flux. This is the source of truth for the cluster state.
* `docs/`: Detailed operational documentation.
* `export-kubeconfig.sh`: Helper script to decrypt and load the kubeconfig.

## 🔄 GitOps & Flux

This cluster uses [Flux](https://fluxcd.io) for GitOps.

* **Sync:** Flux watches the `cluster/` directory and automatically applies changes to the cluster.
* **Encryption:** Secrets in the `cluster/` directory are encrypted with SOPS. Flux is configured with the Age key to decrypt them automatically.

### Verification (Podinfo)

A `podinfo` deployment is included in `cluster/podinfo.yaml` to verify the GitOps pipeline.

* **Deployment:** Verifies that Flux can sync and apply standard manifests.
* **Secret:** `cluster/podinfo-secret.yaml` contains an encrypted secret. This verifies that Flux's SOPS integration is working correctly (i.e., it can decrypt secrets before applying them).

## 🚀 Getting Started

### Prerequisites

Ensure you have the following tools installed:

* [talosctl](https://www.talos.dev/latest/learn-more/talosctl/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [sops](https://github.com/getsops/sops)
* [age](https://github.com/FiloSottile/age)
* [1Password CLI](https://developer.1password.com/docs/cli/) (`op`)

### 🔐 Secrets & Access

This repository uses **SOPS** with **Age** encryption. The private key is stored securely in 1Password.

1. **Authenticate with 1Password:**

    ```bash
    eval $(op signin)
    ```

2. **Load the Decryption Key:**

    ```bash
    export SOPS_AGE_KEY=$(op read "op://Personal/Talos Age Key/notesPlain")
    ```

3. **Access the Cluster:**

    ```bash
    source ./export-kubeconfig.sh
    kubectl get nodes
    ```

## 📚 Documentation

* **[Security Guide](docs/security.md)**: Detailed setup for encryption keys and secret management.
* **[Cluster Operations](docs/usage.md)**: How to access the dashboard, manage nodes, and perform maintenance.

## 🛠️ Maintenance

To apply changes to the cluster nodes:

```bash
# Example: Apply configuration to a worker node
talosctl apply-config --insecure --nodes <NODE_IP> --file <(sops -d cluster/worker.yaml)
```

---
Managed with ❤️ and Talos Linux
