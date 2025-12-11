# 🏗️ Cluster Overview

This document provides a snapshot of the current cluster configuration and status.

## 📊 Cluster Details

* **Kubernetes Version**: `v1.34.1`
* **Talos Version**: `v1.11.5`
* **Kernel Version**: `6.12.57-talos`
* **Container Runtime**: `containerd://2.1.5`
* **Control Plane Endpoint**: `https://10.0.0.24:6443`

## 🖥️ Nodes

| Name | Role | IP Address | CPU | Memory | Storage | OS Image | Status |
|------|------|------------|-----|--------|---------|----------|--------|
| `talos-o1t-vd9` | **Control Plane** | `10.0.0.24` | 16 | 13GB | 475GB | Talos (v1.11.5) | Ready |
| `talos-ly2-g4y` | Worker | `10.0.0.35` | 4 | 16GB | 230GB | Talos (v1.11.5) | Ready |
| `talos-nst-2ck` | Worker | `10.0.0.4` | 4 | 6GB | 48GB | Talos (v1.11.5) | Ready |

## 📊 Resource Capacity

* **Total CPU**: 24 Cores
* **Total Memory**: ~35 GB
* **Total Storage**: ~753 GB
* **Max Pods**: 330 (110 per node)

## 🔄 GitOps Status (Flux)

The cluster is managed by Flux v2.

* **Source**: `github.com/eduuh/kube-homelab` (Branch: `main`)
* **Sync Status**: ✅ Ready
* **Managed Resources**:
  * `flux-system` (Core components)
  * `podinfo` (Smoke test application)

## 🛠️ Network

* **CNI**: Flannel (Default Talos CNI)
* **Service CIDR**: `10.96.0.0/12` (Default)
* **Pod CIDR**: `10.244.0.0/16` (Default)
