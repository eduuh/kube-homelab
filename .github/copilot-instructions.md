# GitHub Copilot Instructions

This repository manages a high-availability Kubernetes cluster running on Talos Linux, managed via GitOps with Flux.

## Project Structure & Conventions

*   **`provisioning/`**: Contains Talos machine configurations (`controlplane.yaml`, `worker.yaml`) and the initial `kubeconfig`.
    *   **Rule**: These files are for bootstrapping nodes. Do not place standard Kubernetes manifests here.
    *   **Rule**: Sensitive values in these files are encrypted with SOPS.

*   **`cluster/`**: Contains Kubernetes manifests managed by Flux.
    *   **Rule**: This is the source of truth for the cluster state.
    *   **Rule**: All Secrets must be encrypted with SOPS before committing.
    *   **Rule**: Flux Kustomizations are defined here.

*   **`export-kubeconfig.sh`**: Helper script to decrypt and load the kubeconfig.
    *   **Usage**: Always source this script before running `kubectl` or `flux` commands against the cluster.
    *   **Example**: `source ./export-kubeconfig.sh && kubectl get nodes`

## Technology Stack

*   **OS**: Talos Linux (Immutable, API-managed).
*   **GitOps**: Flux v2.
*   **Secret Management**: SOPS (Mozilla) with Age encryption.

## Development Guidelines

1.  **Secret Management**:
    *   Never commit plaintext secrets.
    *   Use `sops --encrypt --in-place <file>` to encrypt new secrets.
    *   Ensure `.sops.yaml` is configured correctly for new paths if necessary.

2.  **Flux Workflows**:
    *   When adding new resources, place them in `cluster/`.
    *   Changes are applied automatically after a commit.
    *   Trigger a reconciliation with `flux reconcile source git flux-system` after pushing changes to speed up sync.

3.  **Talos Operations**:
    *   Use `talosctl` for node-level operations (upgrades, config patches).
    *   Do not SSH into nodes (Talos is immutable and has no shell).

4.  **Application Dashboard**:
    *   When adding new applications, update `cluster/apps/glance.yaml` to include the new service in the dashboard.
