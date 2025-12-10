# 🏠 Production Home Lab

Infrastructure as Code for a high-availability Kubernetes cluster running on [Talos Linux](https://www.talos.dev).

## 🌟 Overview

This repository manages the configuration and state of my home laboratory Kubernetes cluster. It follows GitOps principles and prioritizes security through encryption and immutable infrastructure.

**Key Technologies:**

* **OS:** Talos Linux (Immutable, API-managed)
* **Orchestration:** Kubernetes
* **Secret Management:** SOPS + Age + 1Password

## 📂 Repository Structure

* `cluster/`: Core cluster configuration (Control Plane, Workers, Kubeconfig). All sensitive files are encrypted.
* `docs/`: Detailed operational documentation.
* `export-kubeconfig.sh`: Helper script to decrypt and load the kubeconfig.

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
