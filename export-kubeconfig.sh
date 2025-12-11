#!/bin/zsh

# Check if sops is installed
if ! command -v sops &> /dev/null; then
    echo "Error: sops is not installed."
    return 1
fi

# Unset SOPS_AGE_KEY_FILE if the file doesn't exist to avoid sops errors
if [ -n "$SOPS_AGE_KEY_FILE" ] && [ ! -f "$SOPS_AGE_KEY_FILE" ]; then
    unset SOPS_AGE_KEY_FILE
fi

# Try to get key from 1Password if not set
if [ -z "$SOPS_AGE_KEY" ] && [ -z "$SOPS_AGE_KEY_FILE" ]; then
    if command -v op &> /dev/null; then
        echo "Attempting to retrieve key from 1Password..."
        export SOPS_AGE_KEY=$(op read "op://Personal/Talos Age Key/notesPlain")
    fi
fi

# Check if SOPS keys are available
if [ -z "$SOPS_AGE_KEY" ] && [ -z "$SOPS_AGE_KEY_FILE" ]; then
    echo "Error: SOPS_AGE_KEY or SOPS_AGE_KEY_FILE is not set."
    echo "Please set up your keys first (see docs/security.md)."
    return 1
fi

# Decrypt kubeconfig to a temporary file
if [ ! -f "$(pwd)/provisioning/kubeconfig" ]; then
    echo "Error: $(pwd)/provisioning/kubeconfig not found."
    return 1
fi

TEMP_KUBECONFIG=$(mktemp)
if ! sops -d "$(pwd)/provisioning/kubeconfig" > "$TEMP_KUBECONFIG"; then
    echo "Error: Failed to decrypt kubeconfig."
    rm -f "$TEMP_KUBECONFIG"
    return 1
fi

export KUBECONFIG="$TEMP_KUBECONFIG"
echo "KUBECONFIG set to decrypted file: $KUBECONFIG"
echo "Note: This file is temporary and unencrypted."
