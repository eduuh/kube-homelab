# DNS Configuration for Cluster Services

## Current Setup
This cluster uses:
- **Internal DNS**: CoreDNS (built into Kubernetes)
- **External Access**: NGINX Ingress Controller
- **Certificate Management**: cert-manager with self-signed issuer

## Service DNS Names

| Service | Namespace | Internal DNS | External DNS |
|---------|-----------|--------------|--------------|
| IT Tools | it-tools | it-tools.it-tools.svc.cluster.local | it-tools.eduuh.home |

## Prerequisites

1. **Find your Ingress Controller IP**:
```bash
source ./export-kubeconfig.sh
kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

2. **Configure your local DNS server** (Pi-hole, AdGuard Home, or router DNS):
   - Add A record: `it-tools.eduuh.home` → `<INGRESS_IP>`

3. **Alternative: Local hosts file**:
```bash
echo "<INGRESS_IP> it-tools.eduuh.home" | sudo tee -a /etc/hosts
```

## Adding New Services

1. Create an Ingress with desired hostname
2. Add to your DNS server or hosts file
3. Commit to Git and let Flux sync

## Testing

```bash
# External DNS
curl -k https://it-tools.eduuh.home

# Internal DNS (from a pod)
kubectl run test --rm -it --image=curlimages/curl -- sh
curl http://it-tools.it-tools.svc.cluster.local
```
