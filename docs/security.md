# Security & Encryption

We use [sops](https://github.com/getsops/sops) with [age](https://github.com/FiloSottile/age) to encrypt sensitive configuration files.

## Encryption Prerequisites

1. Install `age` and `sops`:

    ```bash
    brew install age sops
    ```

2. Generate a key:

    ```bash
    age-keygen -o keys.txt
    ```

3. Set the environment variable (add this to your shell profile):

    ```bash
    export SOPS_AGE_KEY_FILE=$(pwd)/keys.txt
    ```

4. **Important:** Update `.sops.yaml` with your public key (found in `keys.txt`). Replace `AGE-PUBLIC-KEY-HERE` with your actual public key.

## Storing the Key in 1Password

To securely manage the private key, you can store it in 1Password:

1. Copy the content of `keys.txt`.
2. Save it in a 1Password item (e.g., "Talos Age Key").
3. Use the 1Password CLI (`op`) to set the variable:

    ```bash
    export SOPS_AGE_KEY=$(op read "op://Personal/Talos Age Key/notesPlain")
    ```

## Encrypting Files

To encrypt a file in place:

```bash
sops --encrypt --in-place cluster/controlplane.yaml
sops --encrypt --in-place cluster/worker.yaml
sops --encrypt --in-place cluster/talosconfig
sops --encrypt --in-place cluster/kubeconfig
```

## Using Encrypted Files

Since `talosctl` doesn't natively support sops, use process substitution to decrypt on the fly:

```bash
talosctl apply-config --insecure --nodes <NODE_IP> --file <(sops -d cluster/controlplane.yaml)
```

To edit an encrypted file:

```bash
sops cluster/controlplane.yaml
```
