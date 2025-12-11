# DNS Configuration for Services

## Overview
This cluster uses multiple methods for DNS resolution:
1. **Internal DNS**: Kubernetes CoreDNS for service discovery
2. **External DNS**: Ingress with NGINX for external access
3. **Automatic DNS**: Optional External-DNS for automatic record management

## Current Services with DNS Names

| Service | Internal DNS | External DNS |
|---------|--------------|--------------|
| IT Tools | it-tools.it-tools.svc.cluster.local | it-tools.eduuh.home |

## Setup Requirements

### 1. Local DNS Server (Pi-hole, AdGuard Home, etc.)
Add A records pointing to your Ingress Controller's IP:
```
it-tools.eduuh.home -> <INGRESS_CONTROLLER_IP>
```

### 2. Find Ingress Controller IP
```bash
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

### 3. Client Configuration
Configure your local machines to use your DNS server or add entries to `/etc/hosts`:
```
<INGRESS_IP> it-tools.eduuh.home
```

## Adding New Services with DNS

1. Create an Ingress with the desired hostname
2. Add cert-manager annotations for TLS
3. Either:
   - Manually add DNS record to your DNS server
   - Use External-DNS for automatic management

## Testing DNS Resolution

```bash
# Test external DNS
nslookup it-tools.eduuh.home

# Test from within cluster
kubectl run -it --rm debug --image=nicolaka/netshoot --restart=Never -- nslookup it-tools.it-tools.svc.cluster.local
```
