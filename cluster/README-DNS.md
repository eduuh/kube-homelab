# DNS Configuration for Services

## Overview
This cluster uses multiple methods for DNS resolution:
1. **Internal DNS**: Kubernetes CoreDNS for service discovery
2. **External DNS**: Ingress with NGINX for external access
3. **Automatic DNS**: Optional External-DNS for automatic record management

## Current Services with DNS Names

| Service | Internal DNS | External DNS |
|---------|--------------|--------------|


## Setup Requirements

### 1. Configure Pi-hole (Conditional Forwarding)

Instead of manually adding records for every service, we configure Pi-hole to forward all `*.eduuh.home` queries to our Kubernetes cluster's DNS server (MetalLB IP).

#### Option A: SSH Access

1. SSH into your Pi-hole.

2. Copy the configuration file `docs/99-k8s-cluster.conf` to `/etc/dnsmasq.d/`:

   ```bash
   sudo cp 99-k8s-cluster.conf /etc/dnsmasq.d/
   ```

   *Alternatively, create it manually:*

   ```bash
   echo "server=/eduuh.home/10.0.0.53" | sudo tee /etc/dnsmasq.d/99-k8s-cluster.conf
   ```

3. Restart Pi-hole DNS:

   ```bash
   pihole restartdns
   ```

#### Option B: Docker

If running Pi-hole in Docker:

```bash
docker exec -it pihole bash -c 'echo "server=/eduuh.home/10.0.0.53" > /etc/dnsmasq.d/99-k8s-cluster.conf'
docker exec -it pihole pihole restartdns
```

### 2. Verify Configuration

From your local machine (not the Pi-hole), test that the domain resolves:

```bash
dig @<PIHOLE_IP> it-tools.eduuh.home
```

It should return an answer (e.g., `10.0.0.24` or your Ingress LoadBalancer IP).

### 3. Client Configuration

Ensure your local machines are using your Pi-hole as their DNS server. No local `/etc/hosts` entries are needed!

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
