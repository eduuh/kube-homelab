#!/bin/bash
set -e

# Load kubeconfig and secrets
source ./export-kubeconfig.sh

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Pushing changes to git...${NC}"
git push

echo -e "${GREEN}Reconciling Flux Source (fetching new commit)...${NC}"
flux reconcile source git flux-system

echo -e "${GREEN}Reconciling Flux Kustomization (applying changes)...${NC}"
flux reconcile kustomization flux-system

echo -e "${GREEN}Done! Cluster is synced.${NC}"
