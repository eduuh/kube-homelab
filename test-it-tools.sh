#!/bin/bash

set -e

echo "=== IT Tools Deployment Testing ==="
echo

# Source kubeconfig
echo "1. Loading kubeconfig..."
source ./export-kubeconfig.sh

# Apply the manifest
echo "2. Applying IT Tools manifest..."
kubectl apply -f cluster/it-tools.yaml

# Wait for deployment
echo "3. Waiting for deployment to be ready..."
kubectl rollout status deployment/it-tools -n it-tools --timeout=120s

# Check pod status
echo "4. Checking pod status..."
kubectl get pods -n it-tools

# Test internal DNS and service
echo "5. Testing internal service connectivity..."
kubectl run test-internal --rm -it --image=curlimages/curl --restart=Never -- \
  curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://it-tools.it-tools.svc.cluster.local

# Get Ingress details
echo "6. Checking Ingress configuration..."
kubectl get ingress -n it-tools
echo

# Get Ingress IP
echo "7. Getting Ingress Controller IP..."
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "LoadBalancer IP not found")

if [ "$INGRESS_IP" = "LoadBalancer IP not found" ]; then
  INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.clusterIP}')
  echo "Using ClusterIP: $INGRESS_IP"
else
  echo "Ingress Controller IP: $INGRESS_IP"
fi

echo
echo "=== DNS Configuration ==="
echo "Add this to your DNS server or /etc/hosts:"
echo "$INGRESS_IP it-tools.eduuh.home"
echo

# Test external connectivity if DNS is configured
echo "8. Testing external access (requires DNS/hosts configuration)..."
if grep -q "it-tools.eduuh.home" /etc/hosts; then
  curl -k -s -o /dev/null -w "HTTPS Status: %{http_code}\n" https://it-tools.eduuh.home || true
else
  echo "DNS not configured locally. Configure DNS first, then test with:"
  echo "curl -k https://it-tools.eduuh.home"
fi

echo
echo "=== Test Summary ==="
kubectl get all -n it-tools
echo
echo "Access the service at: https://it-tools.eduuh.home"
echo "Remember to configure DNS pointing to: $INGRESS_IP"
